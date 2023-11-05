//
//  StringValidators.swift
//  ProgettoSoftwareTesting
//
//  Created by Marco Tammaro on 01/11/23.
//

import Foundation

class StringValidators {
    
    enum Validators: String, Comparable {
        static func < (lhs: StringValidators.Validators, rhs: StringValidators.Validators) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case invalidFormat = "The provided email is invalid"
        case pswOneUpper = "Password should containts one uppercased letter"
        case pswOneLower = "Password should containts one lowercased letter"
        case pswOneDigit = "Password should containts one digit"
        case pswOneSymbol = "Password should containts one symbol"
        case pswLen8 = "Password should be at least 8 chars long"
    }
    
    
    enum Email {
        
        static func isValid(string: String) -> Bool {
            let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
            let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
            return emailTest.evaluate(with: string)
        }
        
        static func getMissingValidation(string: String) -> [Validators] {
            if self.isValid(string: string) {
                return []
            }
            
            return [.invalidFormat]
            
        }
        
    }
    
    enum Password {
        
        static func isValid(string: String) -> Bool {
            
            /*
             The password should contains:
             - At least one uppercase
             - At least one digit
             - At least one lowercase
             - At least one symbol
             - Min 8 characters
             */
            
            let password = string.trimmingCharacters(in: CharacterSet.whitespaces)
            let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: password)
        }
        
        static func getMissingValidation(string: String) -> [Validators] {
            var errors: [Validators] = []
            if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: string)){
                errors.append(.pswOneUpper)
            }
            
            if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: string)){
                errors.append(.pswOneDigit)
            }

            if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: string)){
                errors.append(.pswOneSymbol)
            }
            
            if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: string)){
                errors.append(.pswOneLower)
            }
            
            if(string.count < 8){
                errors.append(.pswLen8)
            }
            
            return errors
        }
        
    }
    
}
