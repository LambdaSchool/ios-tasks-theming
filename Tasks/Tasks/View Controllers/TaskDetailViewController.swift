//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Andrew R Madsen on 8/11/18.
//  Copyright © 2018 Andrew R Madsen. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()

        updateViews()
    }

    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        let priorityIndex = priorityControl.selectedSegmentIndex
        let priority = TaskPriority.allPriorities[priorityIndex]
        let notes = notesTextView.text
        
        if let task = task {
            // Editing existing task
            task.name = name
            task.priority = priority.rawValue
            task.notes = notes
            taskController.put(task: task)
        } else {
            let task = Task(name: name, notes: notes, priority: priority)
            taskController.put(task: task)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = task?.name ?? "Create Task"
        nameTextField.text = task?.name
        let priority: TaskPriority
        if let taskPriority = task?.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        priorityControl.selectedSegmentIndex = TaskPriority.allPriorities.index(of: priority)!
        notesTextView.text = task?.notes
    }
    
    private func setupAppearance() {
        UILabel.appearance(whenContainedInInstancesOf: [TaskDetailViewController.self]).textColor = AppearanceHelper.gold
        UILabel.appearance(whenContainedInInstancesOf: [TaskDetailViewController.self]).font = AppearanceHelper.mainFont(with: .title1, pointSize: 21)
        view.backgroundColor = AppearanceHelper.darkNavy
        
        nameTextField.backgroundColor = AppearanceHelper.darkNavy
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.borderColor = AppearanceHelper.gold.cgColor
        nameTextField.textColor = AppearanceHelper.paperWhite
        nameTextField.font = AppearanceHelper.mainFont(with: .body, pointSize: 17)
        
        notesTextView.backgroundColor = AppearanceHelper.darkNavy
        notesTextView.layer.cornerRadius = 8
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = AppearanceHelper.gold.cgColor
        notesTextView.textColor = AppearanceHelper.paperWhite
        notesTextView.font = AppearanceHelper.mainFont(with: .body, pointSize: 18)
    }

    
    // MARK: Properties
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    var taskController: TaskController!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priorityControl: UISegmentedControl!
    @IBOutlet var notesTextView: UITextView!
}
