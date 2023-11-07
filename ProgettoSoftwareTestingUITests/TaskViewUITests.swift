//
//  TaskViewUITests.swift
//  ProgettoSoftwareTestingUITests
//
//  Created by Marco Tammaro on 07/11/23.
//

import XCTest

final class TaskViewUITests: XCTestCase {

    var app: XCUIApplication?

    override func setUpWithError() throws {
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app?.launch()
        
        // Precondition: Login completed successfully
        
        let emailTextField = app?.textFields["EmailTextField"]
        emailTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: emailTextField)?.typeText("test@test.it")
        
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        passwordTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: passwordTextField)?.typeText("Test123!")
    
        app?.buttons["SignupButton"].tap()
        app?.alerts.element.buttons["AlertCloseButton"].tap()
        app?.buttons["LoginButton"].tap()
        
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testTaskLifecycle() throws {
        
        // Computing: All task delete
        app?.navigationBars["Tasks"].buttons["DeleteAllTaskButton"].tap()
        
        // Precondition: There should be no task
        precondition(app?.staticTexts["NoTaskLabel"].exists ?? false)
        
        // Input
        let newTaskName = "UITest Alert"
        
        // Computing: Task Creation
        app?.buttons["CreateTaskButton"].tap()
        
        let alertTextField = app?.alerts.element.textFields["Name"]
        alertTextField?.typeText(newTaskName)
        app?.alerts.element.buttons["CreateTaskAlertConfirmButton"].tap()
        
        let newTask = app?.staticTexts[newTaskName]
        XCTAssert(newTask?.exists ?? false)
        
        // Computing: Task Toggling
        newTask?.tap()
        let strikedTaskName = "striked: " + newTaskName
        let completedNewTask = app?.staticTexts[strikedTaskName]
        XCTAssert(completedNewTask?.exists ?? false)
        
        completedNewTask?.tap()
        let uncompletedNewTask = app?.staticTexts[newTaskName]
        XCTAssert(uncompletedNewTask?.exists ?? false)
    
        // Computing: Deleting Task
        let cell = app?.cells.element(boundBy: 0)

        let rightOffset = CGVector(dx: 0.95, dy: 0.5)
        let leftOffset = CGVector(dx: 0.05, dy: 0.5)

        /// Right to left gesture
        let cellFarRightCoordinate = cell?.coordinate(withNormalizedOffset: rightOffset)
        let cellFarLeftCoordinate = cell?.coordinate(withNormalizedOffset: leftOffset)
        cellFarRightCoordinate?.press(forDuration: 0.1, thenDragTo: cellFarLeftCoordinate!)
        
        let emptyState = app?.staticTexts["NoTaskLabel"]
        
        XCTAssert(emptyState?.exists ?? false)
    }
    
    func testBackToLogin() throws {
        
        app?.navigationBars["Tasks"].buttons["Back"].tap()
        
        let title = app?.staticTexts["Title"]
        let emailTextField = app?.textFields["EmailTextField"]
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        
        XCTAssert(title?.exists ?? false)
        XCTAssert(emailTextField?.exists ?? false)
        XCTAssert(passwordTextField?.exists ?? false)
        
    }
    
    func testDeleteAllTasks() throws {
        
        // Input
        let newTaskName = "UITest Alert"
        
        // Computing: Task Creation
        app?.buttons["CreateTaskButton"].tap()
        
        let alertTextField = app?.alerts.element.textFields["Name"]
        alertTextField?.typeText(newTaskName)
        app?.alerts.element.buttons["CreateTaskAlertConfirmButton"].tap()
        
        let newTask = app?.staticTexts[newTaskName]
        XCTAssert(newTask?.exists ?? false)
        
        // Computing: All task delete
        app?.navigationBars["Tasks"].buttons["DeleteAllTaskButton"].tap()
        
        let emptyState = app?.staticTexts["NoTaskLabel"]
        XCTAssert(emptyState?.exists ?? false)
        
    }

}
