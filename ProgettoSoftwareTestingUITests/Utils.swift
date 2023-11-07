//
//  Utils.swift
//  ProgettoSoftwareTestingUITests
//
//  Created by Marco Tammaro on 07/11/23.
//

import Foundation
import XCTest

extension XCUIElement {
    func waitUntilExists(timeout: TimeInterval = 600, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let elementExists = waitForExistence(timeout: timeout)
        if elementExists {
            return self
        } else {
            XCTFail("Could not find \(self) before timeout", file: file, line: line)
        }
        
        return self
    }
}

extension XCTestCase {
    func waitUntilElementHasFocus(element: XCUIElement?, timeout: TimeInterval = 600, file: StaticString = #file, line: UInt = #line) -> XCUIElement? {
        let expectation = expectation(description: "waiting for element \(String(describing: element)) to have focus")
        
        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            guard element?.hasFocus ?? false else { return }
            
            expectation.fulfill()
            timer.invalidate()
        }
        
        RunLoop.current.add(timer, forMode: .common)
        
        wait(for: [expectation], timeout: timeout)
        
        return element
    }
}
