//
//  LoginViewModelTests.swift
//  ProgettoSoftwareTestingTests
//
//  Created by Marco Tammaro on 03/11/23.
//

import XCTest
@testable import ProgettoSoftwareTesting

final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel? = nil
    
    override func setUpWithError() throws {
        
        let userDefaults = UserDefaults(suiteName: #file)
        precondition(userDefaults != nil)
        
        userDefaults!.removePersistentDomain(forName: #file)
        viewModel = LoginViewModel(userDefaults: userDefaults!)
        
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testIsSignInButtonDisabled() throws {
        
        // Precondition
        precondition(viewModel != nil)
        
        // Input
        let inputData: [[String]:Bool] = [
            ["", ""]: true,
            ["", "test"]: true,
            ["test", "test"]: false,
            ["test", ""]: true,
        ]
        
        for (inputStrings, expectedResult) in inputData {
            
            let activityName = "\(#function) with \(inputStrings) to get \(expectedResult)"
            XCTContext.runActivity(named: activityName) { activity in
                
                // Computing
                viewModel!.email = inputStrings.first!
                viewModel!.password = inputStrings.last!
                
                let result = viewModel!.isSignInButtonDisabled
                
                //  Assertion
                XCTAssertEqual(result, expectedResult)
                
            }
        }
    }
    
    func testCheckValidators() throws {
        
        // Precondition
        precondition(viewModel != nil)
        
        // Input
        let inputData: [[String]:[StringValidators.Validators]] = [
            ["usernametest_42@dom.it", "Test123!"]:     [],
            ["username", "Test123!"]:                   [.invalidFormat],
            ["usernametest_42@dom.it", "123"]:          [.pswLen8, .pswOneSymbol, .pswOneLower, .pswOneUpper],
            ["usernametest_42@dom.it", "Test"]:         [.pswLen8, .pswOneSymbol, .pswOneDigit],
            ["usernametest_42@dom.it", "test"]:         [.pswLen8, .pswOneSymbol, .pswOneDigit, .pswOneUpper],
            ["usernametest_42@dom.it", "TEST"]:         [.pswLen8, .pswOneSymbol, .pswOneLower, .pswOneDigit],
            ["usernametest_42@dom.it", "!!!"]:          [.pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper],
        ]
        
        for (inputStrings, expectedResult) in inputData {
            
            let activityName = "\(#function) with \(inputStrings) to get \(expectedResult)"
            XCTContext.runActivity(named: activityName) { activity in
                
                // Computing
                viewModel!.email = inputStrings.first!
                viewModel!.password = inputStrings.last!
                
                let result = viewModel!.checkValidators()
                
                // Assertion
                XCTAssertNotNil(result)
                XCTAssertEqual(result.count, expectedResult.count)
                XCTAssertEqual(result.sorted(), expectedResult.sorted())
                
            }
        }
    }
    
    
    func testRegistration() throws {
        
        let email = "prova@prova.it"
        let password = "Prova123!"
        
        // Precondition
        precondition(viewModel != nil)
        precondition(StringValidators.Email.isValid(string: email))
        precondition(StringValidators.Password.isValid(string: password))
        
        // Input
        viewModel!.email = email
        viewModel!.password = password
        
        // Computing
        viewModel!.saveUser()
        let registeredPassword = viewModel!.userDefaults.string(forKey: email)
        
        // Assertion
        XCTAssertEqual(password, registeredPassword)
        
        // Postcondition
        XCTAssert(viewModel!.canLogin)
    }
    
    func testLogin() throws {
        
        // Input
        let email = "prova@prova.it"
        let password = "Prova123!"
        
        // Precondition
        precondition(viewModel != nil)
        
        // Precondition: User is registered
        viewModel!.email = email
        viewModel!.password = password
        viewModel!.saveUser()
        
        // Computing
        viewModel!.email = email
        viewModel!.password = password
        let result = viewModel!.canLogin
        
        // Assertion
        XCTAssert(result)
        
    }
    
}
