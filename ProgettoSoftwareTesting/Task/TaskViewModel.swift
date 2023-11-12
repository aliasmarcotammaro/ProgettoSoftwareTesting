//
//  HomeViewModel.swift
//  ProgettoSoftwareTesting
//
//  Created by Marco Tammaro on 01/11/23.
//

import Foundation

class TaskViewModel: ObservableObject {
    
    final private let dataKey = "TasksData"
    
    @Published var tasks: [Task] = []
    @Published var newTaskAlertPresented: Bool = false
    @Published var newTaskName: String = ""
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.tasks = readPersistance()
    }
    
    // Tasks Methods
    
    @discardableResult
    func createNewTask() -> Bool {
        
        guard self.newTaskName != "" else { return false }
        
        let newTask = Task(name: self.newTaskName, completed: false)
        self.tasks.append(newTask)
        self.newTaskName = ""
        updatePersistance(tasks: self.tasks)
        return true
    }
    
    @discardableResult
    func toggleTask(index: Int) -> Bool {
        
        guard self.tasks.indices.contains(index) else { return false }
        
        let task = self.tasks[index]
        task.completed.toggle()
        
        self.tasks.remove(at: index)
        self.tasks.insert(task, at: index)
        updatePersistance(tasks: self.tasks)
        return true
    }
    
    @discardableResult
    func deleteTask(indexSet: IndexSet) -> Bool {
        
        for index in indexSet {
            guard self.tasks.indices.contains(index) else { return false }
        }
        
        var arr = Array(self.tasks.enumerated())
        arr.removeAll{ indexSet.contains($0.offset) }
        self.tasks = arr.map{ $0.element }
        updatePersistance(tasks: self.tasks)
        return true
    }
    
    @discardableResult
    func deleteAllTask() -> Bool {
        self.tasks = []
        updatePersistance(tasks: self.tasks)
        return true
    }
    
    // Persistance Methods
    
    func updatePersistance(tasks: [Task]) {
        let newDataDict = tasks.map { task in return try! task.toDict() }
        userDefaults.setValue(newDataDict, forKey: dataKey)
    }
    
    func readPersistance() -> [Task] {
        let data = userDefaults.array(forKey: dataKey) ?? []
        
        return data.map({ data in
            let dataDict = data as? [String:Any]
            return try! Task(dict: dataDict!)
        })
    }
    
    // Other Methods
    
    func showNewTaskAlert() {
        self.newTaskAlertPresented = true
    }
    
    func accessibilityLabelFor(task: Task) -> String {
        guard task.completed else { return task.name }
        return "striked: " + task.name
    }
    
}
