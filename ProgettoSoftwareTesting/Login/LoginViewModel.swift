//
//  ContentViewModel.swift
//  ProgettoSoftwareTesting
//
//  Created by Marco Tammaro on 01/11/23.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var missingValidators: [StringValidators.Validators] = []
    
    @Published var alertMessage: String? = nil
    @Published var showingAlert: Bool = false
    
    @Published var pushToHome: Bool = false
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    var isSignInButtonDisabled: Bool {
        [email, password].contains(where: \.isEmpty)
    }
    
    var canLogin: Bool {
        
        guard let savedPassword = userDefaults.string(forKey: self.email) else {
            return false
        }
        
        return savedPassword == self.password
    }
    
    func didTapOnLogin() {
        if canLogin {
            navigateToHome()
        } else {
            alertMessage = "Unable to login"
            showingAlert = true
        }
    }
    
    func didTapOnRegister() {
        
        let validators = checkValidators()
        
        if validators.isEmpty {
            saveUser()
            alertMessage = "Registration Successful!"
            showingAlert = true
            return
        }
        
        self.missingValidators = validators
        
    }
    
    func checkValidators() -> [StringValidators.Validators] {
        
        var validators: [StringValidators.Validators] = []
        if !StringValidators.Password.isValid(string: self.password) {
            validators.append(contentsOf: StringValidators.Password.getMissingValidation(string: password))
        }
        
        if !StringValidators.Email.isValid(string: self.email) {
            validators.append(contentsOf: StringValidators.Email.getMissingValidation(string: email))
        }
        
        return validators
        
    }
    
    func saveUser() {
        userDefaults.setValue(self.password, forKey: self.email)
    }
    
    func navigateToHome() {
        pushToHome = true
    }
    
}
