//
//  StringValidatorsTests.swift
//  ProgettoSoftwareTestingTests
//
//  Created by Marco Tammaro on 01/11/23.
//

import XCTest
@testable import ProgettoSoftwareTesting

final class StringValidatorsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEmailValidator() throws {
        
        // Input
        let inputData: [String:Bool] = [
            "": false,
            "test": false,
            "test@": false,
            "test@dom": false,
            "test@dom.it": true,
            "test123@dom123.com": true,
            "username_42@dom.it": true,
            "@dom.it": false,
            "!#£@123.it": false,
            "test@dom.abcdef": false
        ]
        
        for (inputString, expectedResult) in inputData {
            
            let activityName = "\(#function) with \(inputString) to get \(expectedResult)"
            XCTContext.runActivity(named: activityName) { activity in
                
                // Computing
                let result = StringValidators.Email.isValid(string: inputString)
                
                //  Assertion
                XCTAssertEqual(result, expectedResult)
                
            }
        }
        
    }
    
    func testPasswordValidator() throws {
        
        // Input
        let inputData: [String:Bool] = [
            "": false,
            "abcdefghi": false,
            "Abc": false,
            "Abc123": false,
            "Abcd1!": false,
            "Abcd123!": true,
            "abcd123!": false,
        ]
        
        for (inputString, expectedResult) in inputData {
            
            let activityName = "\(#function) with \(inputString) to get \(expectedResult)"
            XCTContext.runActivity(named: activityName) { activity in
                
                // Computing
                let result = StringValidators.Password.isValid(string: inputString)
                
                //  Assertion
                XCTAssertEqual(result, expectedResult)
                
            }
        }
    }
    
    func testPasswordMissingValidators() throws {
        
        // Input
        let inputData: [String:[StringValidators.Validators]] = [
            "": [.pswLen8, .pswOneDigit, .pswOneLower, .pswOneUpper, .pswOneSymbol],
            "abcdefghi": [.pswOneDigit, .pswOneUpper, .pswOneSymbol],
            "Abc": [.pswLen8, .pswOneDigit, .pswOneSymbol],
            "Abc123": [.pswLen8, .pswOneSymbol],
            "Abcd1!": [.pswLen8],
            "Abcd123!": [],
            "abcd123!": [.pswOneUpper],
        ]
        
        for (inputString, expectedResult) in inputData {
            
            let activityName = "\(#function) with \(inputString) to get \(expectedResult)"
            XCTContext.runActivity(named: activityName) { activity in
                
                // Computing
                let result = StringValidators.Password.getMissingValidation(string: inputString)
                
                //  Assertion
                XCTAssertEqual(result.count, expectedResult.count)
                XCTAssertEqual(result.sorted(), expectedResult.sorted())
                
            }
        }
    }
    
    func testEmailMissingValidators() throws {
        
        // Input
        let inputData: [String:[StringValidators.Validators]] = [
            "": [.invalidFormat],
            "test": [.invalidFormat],
            "test@": [.invalidFormat],
            "test@dom": [.invalidFormat],
            "test@dom.it": [],
            "test123@dom123.com": [],
            "username_42@dom.it": [],
            "@dom.it": [.invalidFormat],
            "!#£@123.it": [.invalidFormat],
            "test@dom.abcdef": [.invalidFormat]
        ]
        
        for (inputString, expectedResult) in inputData {
            
            let activityName = "\(#function) with \(inputString) to get \(expectedResult)"
            XCTContext.runActivity(named: activityName) { activity in
                
                // Computing
                let result = StringValidators.Email.getMissingValidation(string: inputString)
                
                //  Assertion
                XCTAssertEqual(result.count, expectedResult.count)
                XCTAssertEqual(result.sorted(), expectedResult.sorted())
                
            }
        }
    }

}
