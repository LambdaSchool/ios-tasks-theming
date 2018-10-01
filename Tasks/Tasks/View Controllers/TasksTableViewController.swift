//
//  TasksTableViewController.swift
//  Tasks
//
//  Created by Andrew R Madsen on 8/11/18.
//  Copyright © 2018 Andrew R Madsen. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: Appearance.applicationFont(with: .title1, at: 30)]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func refresh(_ sender: Any) {
        taskController.fetchTasksFromServer { _ in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = task.name
        style(cell: cell)
        switch task.priority {
        case TaskPriority.critical.rawValue:
            cell.backgroundColor = Appearance.colorForPosition(color: Appearance.criticalPriorityColor, position: indexPath.row)
        case TaskPriority.high.rawValue:
            cell.backgroundColor = Appearance.colorForPosition(color: Appearance.highPriorityColor, position: indexPath.row)
        case TaskPriority.normal.rawValue:
            cell.backgroundColor = Appearance.colorForPosition(color: Appearance.normalPriorityColor, position: indexPath.row)
        case TaskPriority.low.rawValue:
            cell.backgroundColor = Appearance.colorForPosition(color: Appearance.lowPriorityColor, position: indexPath.row)
        default:
            cell.backgroundColor = Appearance.darkBackground
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
//        return sectionInfo.name.capitalized
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = fetchedResultsController.object(at: indexPath)
            
            
            taskController.deleteTaskFromServer(task) { (error) in
                if let error = error {
                    NSLog("Error deleting task from server: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    let moc = CoreDataStack.shared.mainContext
                    moc.delete(task)
                    do {
                        try moc.save()
                    } catch {
                        moc.reset()
                        NSLog("Error saving managed object context: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskDetail" {
            let detailVC = segue.destination as! TaskDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.task = fetchedResultsController.object(at: indexPath)
            }
            detailVC.taskController = taskController
        }
        
        if segue.identifier == "ShowCreateTask" {
            let detailVC = segue.destination as! TaskDetailViewController
            detailVC.taskController = taskController
        }
    }
    
    // MARK: Utility Methods
    private func style(cell: UITableViewCell) {
        cell.textLabel?.font = Appearance.applicationFont(with: .body, at: 16)
        cell.textLabel?.textColor = .white
    }
    
    // MARK: Properties
    
    private let taskController = TaskController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true),
                                        NSSortDescriptor(key: "name", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "priority", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
}
