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
            
            // Computing
            viewModel?.email = inputStrings.first!
            viewModel?.password = inputStrings.last!
            
            let result = viewModel?.isSignInButtonDisabled
            
            //  Assertion
            XCTAssertEqual(result, expectedResult)
        }
        
    }
    
    func testCheckValidators() throws {
        
        // Precondition
        precondition(viewModel != nil)
        
        // Input
        let inputData: [[String]:[StringValidators.Validators]] = [
            ["", ""]:                           [.invalidFormat, .pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
            ["", "abcdefghi"]:                  [.invalidFormat, .pswOneDigit, .pswOneUpper, .pswOneSymbol],
            ["", "Abc"]:                        [.invalidFormat, .pswLen8, .pswOneDigit, .pswOneSymbol],
            ["", "Abc123"]:                     [.invalidFormat, .pswLen8, .pswOneSymbol],
            ["", "Abcd1!"]:                     [.invalidFormat, .pswLen8],
            ["", "Abcd123!"]:                   [.invalidFormat, ],
            ["", "abcd123!"]:                   [.invalidFormat, .pswOneUpper],
            
            ["test@dom.abcdef", "Abc123"]:      [.invalidFormat, .pswLen8, .pswOneSymbol],
            ["test@", "abcdefghi"]:             [.invalidFormat, .pswOneDigit, .pswOneUpper, .pswOneSymbol],
            ["@", "Abc"]:                       [.invalidFormat, .pswLen8, .pswOneDigit, .pswOneSymbol],
            ["test@", "Abc123"]:                [.invalidFormat, .pswLen8, .pswOneSymbol],
            ["test@dom.it", "Abcd1!"]:          [.pswLen8],
            ["username_42@dom.it", "Abcd123!"]: [],
            ["test@", "abcd123!"]:              [.invalidFormat, .pswOneUpper],
            
            ["test@dom.abcdef", ""]:            [.invalidFormat, .pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
            ["test@", ""]:                      [.invalidFormat, .pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
            ["@", ""]:                          [.invalidFormat, .pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
            ["!#£@123.it", ""]:                 [.invalidFormat, .pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
            ["test@dom.it", ""]:                [.pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
            ["username_42@dom.it", ""]:         [.pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
        ]
        
        for (inputStrings, expectedResult) in inputData {
            
            // Computing
            viewModel?.email = inputStrings.first!
            viewModel?.password = inputStrings.last!
            
            let result = viewModel?.checkValidators()
            
            // Assertion
            XCTAssertNotNil(result)
            XCTAssertEqual(result!.count, expectedResult.count)
            XCTAssertEqual(result!.sorted(), expectedResult.sorted())
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
        viewModel?.email = email
        viewModel?.password = password
        
        // Computing
        viewModel?.saveUser()
        let registeredPassword = viewModel?.userDefaults.string(forKey: email)
        let canLogin = viewModel?.canLogin
        
        // Assertion
        XCTAssertEqual(password, registeredPassword)
        XCTAssertEqual(canLogin, true)
    }
    
    func testLogin() throws {
        
        let email = "prova@prova.it"
        let password = "Prova123!"
        
        // Precondition
        precondition(viewModel != nil)
        
        // Input
        viewModel?.email = email
        viewModel?.password = password
        
        // Computing
        viewModel?.saveUser()
        let canLogin = viewModel?.canLogin
        
        // Assertion
        XCTAssertEqual(canLogin, true)
        
    }
    
}
