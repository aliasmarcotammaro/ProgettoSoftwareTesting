//
//  TaskViewUITests.swift
//  ProgettoSoftwareTestingUITests
//
//  Created by Marco Tammaro on 07/11/23.
//

import XCTest

final class TaskViewUITests: XCTestCase {

    var app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-uitesting")
        app.launch()
        
        // Precondition: Login completed successfully
        
        let emailTextField = app.textFields["EmailTextField"]
        emailTextField.tap()
        emailTextField.typeText("test@test.it")
        
        let passwordTextField = app.secureTextFields["PasswordSecureTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("Test123!")
    
        app.buttons["SignupButton"].tap()
        app.alerts.element.buttons["AlertCloseButton"].tap()
        app.buttons["LoginButton"].tap()
        
    }

    func testTaskLifecycle() throws {
        
        // Computing: All task delete
        app.navigationBars["Tasks"].buttons["DeleteAllTaskButton"].tap()
        
        // Precondition: There should be no task
        precondition(app.staticTexts["NoTaskLabel"].exists)
        
        // Input
        let newTaskName = "UITest Alert"
        
        // Computing: Task Creation
        app.buttons["CreateTaskButton"].tap()
        
        let alertTextField = app.alerts.element.textFields["Name"]
        alertTextField.typeText(newTaskName)
        app.alerts.element.buttons["CreateTaskAlertConfirmButton"].tap()
        
        let newTask = app.staticTexts[newTaskName]
        XCTAssert(newTask.exists)
        
        // Computing: Task Toggling
        newTask.tap()
        let strikedTaskName = "striked: " + newTaskName
        let completedNewTask = app.staticTexts[strikedTaskName]
        XCTAssert(completedNewTask.exists)
        
        completedNewTask.tap()
        let uncompletedNewTask = app.staticTexts[newTaskName]
        XCTAssert(uncompletedNewTask.exists)
    
        // Computing: Deleting Task
        let cell = app.cells.element(boundBy: 0)

        let rightOffset = CGVector(dx: 0.95, dy: 0.5)
        let leftOffset = CGVector(dx: 0.05, dy: 0.5)

        /// Right to left gesture
        let cellFarRightCoordinate = cell.coordinate(withNormalizedOffset: rightOffset)
        let cellFarLeftCoordinate = cell.coordinate(withNormalizedOffset: leftOffset)
        cellFarRightCoordinate.press(forDuration: 0.1, thenDragTo: cellFarLeftCoordinate)
        
        let emptyState = app.staticTexts["NoTaskLabel"]
        
        XCTAssert(emptyState.exists)
    }
    
    func testBackToLogin() throws {
        
        app.navigationBars["Tasks"].buttons["Back"].tap()
        
        let title = app.staticTexts["Title"]
        let emailTextField = app.textFields["EmailTextField"]
        let passwordTextField = app.secureTextFields["PasswordSecureTextField"]
        
        XCTAssert(title.exists)
        XCTAssert(emailTextField.exists)
        XCTAssert(passwordTextField.exists)
        
    }
    
    func testDeleteAllTasks() throws {
        
        // Input
        let newTaskName = "UITest Alert"
        
        // Computing: Task Creation
        app.buttons["CreateTaskButton"].tap()
        
        let alertTextField = app.alerts.element.textFields["Name"]
        alertTextField.typeText(newTaskName)
        app.alerts.element.buttons["CreateTaskAlertConfirmButton"].tap()
        
        let newTask = app.staticTexts[newTaskName]
        XCTAssert(newTask.exists)
        
        // Computing: All task delete
        app.navigationBars["Tasks"].buttons["DeleteAllTaskButton"].tap()
        
        let emptyState = app.staticTexts["NoTaskLabel"]
        XCTAssert(emptyState.exists)
        
    }

}
