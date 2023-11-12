//
//  TaskViewModelTests.swift
//  ProgettoSoftwareTestingTests
//
//  Created by Marco Tammaro on 05/11/23.
//

import XCTest
@testable import ProgettoSoftwareTesting

final class TaskViewModelTests: XCTestCase {

    var viewModel: TaskViewModel? = nil
    
    override func setUpWithError() throws {
        
        let userDefaults = UserDefaults(suiteName: #file)
        precondition(userDefaults != nil)
        
        userDefaults!.removePersistentDomain(forName: #file)
        viewModel = TaskViewModel(userDefaults: userDefaults!)
        
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testCreateNewTask() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Input
        let newTaskName = "Test"
        
        // Computing
        viewModel!.newTaskName = newTaskName
        let result = viewModel!.createNewTask()
        let persistance = viewModel!.readPersistance()
        
        //  Assertion
        XCTAssert(result)
        
        // Postcondition
        XCTAssertEqual(1, viewModel!.tasks.count)
        XCTAssertTrue(viewModel!.tasks.contains(where: { task in
            task.name == newTaskName && !task.completed
        }))
        
        XCTAssertEqual(1, persistance.count)
        XCTAssertTrue(persistance.contains(where: { task in
            task.name == newTaskName && !task.completed
        }))
    }
    
    func testCreateNewTaskFailure() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Input
        let newTaskName = ""
        
        // Computing
        viewModel!.newTaskName = newTaskName
        let result = viewModel!.createNewTask()
        
        //  Assertion
        XCTAssertFalse(result)
        
        //  Postcondition
        XCTAssert(viewModel!.tasks.isEmpty)
    }
    
    func testToggleTask() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel!.newTaskName = newTaskName
        viewModel!.createNewTask()
        
        // Input
        let indexToToggle = 0
        
        // Computing
        let result = viewModel!.toggleTask(index: indexToToggle)
        let persistance = viewModel!.readPersistance()
        
        //  Assertion
        XCTAssert(result)
        
        //  Postcondition
        XCTAssertEqual(1, viewModel!.tasks.count)
        XCTAssertTrue(viewModel!.tasks.contains(where: { task in
            task.name == newTaskName && task.completed
        }))
        
        XCTAssertEqual(1, persistance.count)
        XCTAssertTrue(persistance.contains(where: { task in
            task.name == newTaskName && task.completed
        }))
    }
    
    func testToggleTaskInvalidIndex() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel!.newTaskName = newTaskName
        viewModel!.createNewTask()
        
        // Input
        let indexToToggle = -4
        
        // Computing
        let result = viewModel!.toggleTask(index: indexToToggle)
        
        //  Assertion
        XCTAssertFalse(result)
        
        //  Postcondition
        XCTAssertTrue(viewModel!.tasks.contains(where: { task in
            task.name == newTaskName && !task.completed
        }))
    }
    
    func testDeleteTask() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel!.newTaskName = newTaskName
        viewModel!.createNewTask()
        
        // Input
        let indexToRemove = 0
        
        // Computing
        let result = viewModel!.deleteTask(indexSet: IndexSet(integer: indexToRemove))
        let persistance = viewModel!.readPersistance()
        
        //  Assertion
        XCTAssert(result)
        
        //  Postcondition
        XCTAssert(viewModel!.tasks.isEmpty)
        XCTAssert(persistance.isEmpty)
    }
    
    func testDeleteMultipleTask() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Precondition: Some tasks exist
        let newTaskNames = ["Test1", "Test2", "Test3", "Test4", "Test5"]
        for name in newTaskNames {
            viewModel!.newTaskName = name
            viewModel!.createNewTask()
        }
        
        // Input
        let indexToRemove = IndexSet([0, 1, 3, 4])
        
        // Computing
        let result = viewModel!.deleteTask(indexSet: indexToRemove)
        let persistance = viewModel!.readPersistance()
        
        //  Assertion
        XCTAssert(result)
        
        //  Postcondition
        XCTAssertEqual(1, viewModel!.tasks.count)
        XCTAssertEqual(newTaskNames[2], viewModel!.tasks.first?.name)
        
        XCTAssertEqual(1, persistance.count)
        XCTAssertEqual(newTaskNames[2], persistance.first?.name)
    }
    
    func testDeleteAllTask() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Precondition: Some tasks exist
        let newTaskNames = ["Test1", "Test2", "Test3", "Test4", "Test5"]
        for name in newTaskNames {
            viewModel!.newTaskName = name
            viewModel!.createNewTask()
        }
        
        // Computing
        let result = viewModel!.deleteAllTask()
        let persistance = viewModel!.readPersistance()
        
        //  Assertion
        XCTAssert(result)
        
        //  Postcondition
        XCTAssert(viewModel!.tasks.isEmpty)
        XCTAssert(persistance.isEmpty)
    }
    
    func testDeleteTaskInvalidIndex() throws {
        // Precondition
        precondition(viewModel != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel!.newTaskName = newTaskName
        viewModel!.createNewTask()
        
        // Input
        let indexToRemove = 1
        
        // Computing
        let result = viewModel!.deleteTask(indexSet: IndexSet(integer: indexToRemove))
        
        //  Assertion
        XCTAssertFalse(result)
        
        //  Postcondition
        XCTAssertEqual(1, viewModel!.tasks.count)
    }
    
}
