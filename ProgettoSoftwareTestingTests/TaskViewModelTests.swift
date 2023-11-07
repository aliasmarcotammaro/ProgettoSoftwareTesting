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
    var userDefaults: UserDefaults? = nil
    
    override func setUpWithError() throws {
        
        guard let userDefaults = UserDefaults(suiteName: #file) else {
            fatalError("Unable to create User Defaults")
        }
        
        self.userDefaults = userDefaults
        userDefaults.removePersistentDomain(forName: #file)
        viewModel = TaskViewModel(userDefaults: userDefaults)
        
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testCreateNewTask() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Input
        let newTaskName = "Test"
        
        // Computing
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        let expectedCount = 1
        
        //  Assertion
        XCTAssertEqual(expectedCount, viewModel?.tasks.count)
        XCTAssertTrue(viewModel!.tasks.contains(where: { task in
            task.name == newTaskName && !task.completed
        }))
    }
    
    func testToggleTask() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        // Input
        let indexToToggle = 0
        
        // Computing
        let result = viewModel?.toggleTask(index: indexToToggle)
        
        let expectedResult = true
        let expectedCount = 1
        
        //  Assertion
        XCTAssertEqual(expectedResult, result)
        XCTAssertEqual(expectedCount, viewModel?.tasks.count)
        XCTAssertTrue(viewModel!.tasks.contains(where: { task in
            task.name == newTaskName && task.completed
        }))
    }
    
    func testToggleTaskInvalidIndex() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        // Input
        let indexToToggle = -4
        
        // Computing
        let result = viewModel?.toggleTask(index: indexToToggle)
        
        let expectedResult = false
        
        //  Assertion
        XCTAssertEqual(expectedResult, result)
        XCTAssertTrue(viewModel!.tasks.contains(where: { task in
            task.name == newTaskName && !task.completed
        }))
    }
    
    func testDeleteTask() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        // Input
        let indexToRemove = 0
        
        // Computing
        let result = viewModel?.deleteTask(indexSet: IndexSet(integer: indexToRemove))
        
        let expectedCount = 0
        let expectedResult = true
        
        //  Assertion
        XCTAssertEqual(expectedResult, result)
        XCTAssertEqual(expectedCount, viewModel?.tasks.count)
    }
    
    func testDeleteMultipleTask() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: Some tasks exist
        let newTaskNames = ["Test1", "Test2", "Test3", "Test4", "Test5"]
        for name in newTaskNames {
            viewModel?.newTaskName = name
            viewModel?.createNewTask()
        }
        
        // Input
        let indexToRemove = IndexSet([0, 1, 3, 4])
        
        // Computing
        let result = viewModel?.deleteTask(indexSet: indexToRemove)
        
        let expectedCount = 1
        let expectedTaskName = newTaskNames[2]
        let expectedResult = true
        
        //  Assertion
        XCTAssertEqual(expectedResult, result)
        XCTAssertEqual(expectedCount, viewModel?.tasks.count)
        XCTAssertEqual(expectedTaskName, viewModel?.tasks.first?.name)
    }
    
    func testDeleteAllTask() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: Some tasks exist
        let newTaskNames = ["Test1", "Test2", "Test3", "Test4", "Test5"]
        for name in newTaskNames {
            viewModel?.newTaskName = name
            viewModel?.createNewTask()
        }
        
        // Computing
        viewModel?.deleteAllTask()
        
        let expectedCount = 0
        
        //  Assertion
        XCTAssertEqual(expectedCount, viewModel?.tasks.count)
    }
    
    func testDeleteTaskInvalidIndex() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        // Input
        let indexToRemove = 1
        
        // Computing
        let result = viewModel?.deleteTask(indexSet: IndexSet(integer: indexToRemove))

        let expectedCount = 1
        let expectedResult = false
        
        //  Assertion
        XCTAssertEqual(expectedResult, result)
        XCTAssertEqual(expectedCount, viewModel?.tasks.count)
    }
    
    func testReadPersistanceOnCreate() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Input
        let newTaskName = "Test"
        
        // Computing
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        let persistance = viewModel!.readPersistance()

        let expectedCount = 1
        
        //  Assertion
        XCTAssertEqual(expectedCount, persistance.count)
        XCTAssertTrue(persistance.contains(where: { task in
            task.name == newTaskName && !task.completed
        }))
    }
    
    func testReadPersistanceOnToggle() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        // Input
        let indexToToggle = 0
        
        // Computing
        let result = viewModel?.toggleTask(index: indexToToggle)
        let persistance = viewModel!.readPersistance()
        
        let expectedResult = true
        let expectedCount = 1
        
        //  Assertion
        XCTAssertEqual(expectedResult, result)
        XCTAssertEqual(expectedCount, viewModel?.tasks.count)
        XCTAssertTrue(persistance.contains(where: { task in
            task.name == newTaskName && task.completed
        }))
    }
    
    func testReadPersistanceOnDelete() throws {
        // Precondition
        precondition(viewModel != nil)
        precondition(userDefaults != nil)
        
        // Precondition: A task exist
        let newTaskName = "Test"
        viewModel?.newTaskName = newTaskName
        viewModel?.createNewTask()
        
        // Input
        let indexToDelete = 0
        
        // Computing
        let result = viewModel?.deleteTask(indexSet: IndexSet(integer: indexToDelete))
        let persistance = viewModel!.readPersistance()
        
        let expectedResult = true
        let expectedCount = 0
        
        //  Assertion
        XCTAssertEqual(expectedResult, result)
        XCTAssertEqual(expectedCount, persistance.count)
    }

}
