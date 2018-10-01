//
//  TaskController.swift
//  Tasks
//
//  Created by Andrew R Madsen on 8/15/18.
//  Copyright © 2018 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://tasks-1c65a.firebaseio.com/")!

class TaskController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchTasksFromServer()
    }
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            
            do {
                let taskRepresentations = Array(try JSONDecoder().decode([String : TaskRepresentation].self, from: data).values)
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                try self.updateTasks(with: taskRepresentations, context: moc)
                completion(nil)
            } catch {
                NSLog("Error decoding task representations: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    func put(task: Task, completion: @escaping CompletionHandler = { _ in }) {
        
        let uuid = task.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = task.taskRepresentation else {
                completion(NSError())
                return
            }
            representation.identifier = uuid.uuidString
            task.identifier = uuid
            
            try CoreDataStack.shared.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(task): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func deleteTaskFromServer(_ task: Task, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let uuid = task.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(error)
            }.resume()
    }
    
    private func updateTasks(with representations: [TaskRepresentation], context: NSManagedObjectContext) throws {
        
        var error: Error? = nil
        context.performAndWait {
            for taskRep in representations {
                guard let uuid = UUID(uuidString: taskRep.identifier) else { continue }
                
                if let task = self.task(forUUID: uuid, in: context) {
                    self.update(task: task, with: taskRep)
                } else {
                    let _ = Task(taskRepresentation: taskRep, context: context)
                }
            }
            
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
    private func update(task: Task, with representation: TaskRepresentation) {
        task.name = representation.name
        task.notes = representation.notes
        task.priority = representation.priority
    }
    
    private func task(forUUID uuid: UUID, in context: NSManagedObjectContext) -> Task? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        
        var result: Task? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching task with uuid \(uuid): \(error)")
            }
        }
        return result
    }
}
