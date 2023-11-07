//
//  LoginViewUITests.swift
//  ProgettoSoftwareTestingUITests
//
//  Created by Marco Tammaro on 07/11/23.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    
    var app: XCUIApplication?

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app?.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLoginAppear() throws {
        
        let title = app?.staticTexts["Title"]
        let emailTextField = app?.textFields["EmailTextField"]
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        
        XCTAssert(title?.exists ?? false)
        XCTAssert(emailTextField?.exists ?? false)
        XCTAssert(passwordTextField?.exists ?? false)
    }
    
    func testSignupFail() throws {
        
        let emailTextField = app?.textFields["EmailTextField"]
        emailTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: emailTextField)?.typeText("123456789")
        
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        passwordTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: passwordTextField)?.typeText("123456789")
        
        app?.buttons["SignupButton"].tap()
        
        XCTAssert(app?.staticTexts["ValidatorsList"].exists ?? false)
    }
    
    func testSignupSuccess() throws {
        
        let emailTextField = app?.textFields["EmailTextField"]
        emailTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: emailTextField)?.typeText("123456789")
        
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        passwordTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: passwordTextField)?.typeText("123456789")
        
        app?.buttons["SignupButton"].tap()
        
        let alert = app?.alerts.element
        let alertDescription = app?.alerts.element.staticTexts["Registration Successful!"]
        
        XCTAssert(alert?.exists ?? false)
        XCTAssert(alertDescription?.exists ?? false)
    }
    
    
    func testLoginFail() throws {
        
        let emailTextField = app?.textFields["EmailTextField"]
        emailTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: emailTextField)?.typeText("123456789")
        
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        passwordTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: passwordTextField)?.typeText("123456789")
        
        app?.buttons["LoginButton"].tap()
        
        XCTAssert(app?.alerts.element.exists ?? false)
    }
    
    func testLoginSuccess() throws {
        
        // Registration
        let emailTextField = app?.textFields["EmailTextField"]
        emailTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: emailTextField)?.typeText("test@test.it")
        
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        passwordTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: passwordTextField)?.typeText("Test123!")
        
        app?.buttons["SignupButton"].tap()
        app?.alerts.element.buttons["AlertCloseButton"].tap()
        
        // Login
        app?.buttons["LoginButton"].tap()
        
        // Check TaskView show
        let taskTitle = app?.navigationBars.element.staticTexts["Tasks"]
        XCTAssert(taskTitle?.exists ?? false)
    }
    
    func testShowPassword() throws {
        
        let password = "Test123!"
        
        let passwordTextField = app?.secureTextFields["PasswordSecureTextField"]
        passwordTextField?.waitUntilExists().tap()
        waitUntilElementHasFocus(element: passwordTextField)?.typeText(password)
        
        app?.buttons["ShowPasswordButton"].tap()
        
        let clearPasswordTextField = app?.textFields["PasswordTextField"]
        let clearPasswordTextFieldValue = clearPasswordTextField?.value as? String ?? ""
        
        XCTAssert(clearPasswordTextField?.exists ?? false)
        XCTAssertEqual(clearPasswordTextFieldValue, password)
    }
    
}

/*
 
 
 
 */
