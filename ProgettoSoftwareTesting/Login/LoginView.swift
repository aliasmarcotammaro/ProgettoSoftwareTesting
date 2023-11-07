//
//  ContentView.swift
//  ProgettoSoftwareTesting
//
//  Created by Marco Tammaro on 31/10/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject  var vm = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                
                Text("Software Testing\nProject")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .accessibilityLabel("Title")
                
                TextField("Email",
                          text: $vm.email ,
                          prompt: Text("Email")
                )
                .accessibilityLabel("EmailTextField")
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 1.5)
                }
                .padding(.horizontal)
                .autocapitalization(.none)
                
                HStack {
                    Group {
                        if vm.showPassword {
                            TextField("Password",
                                      text: $vm.password,
                                      prompt: Text("Password"))
                            .accessibilityLabel("PasswordTextField")
                        } else {
                            SecureField("Password",
                                        text: $vm.password,
                                        prompt: Text("Password"))
                            .accessibilityLabel("PasswordSecureTextField")
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 1.5)
                    }
                    
                    Button {
                        vm.showPassword.toggle()
                    } label: {
                        Image(systemName: vm.showPassword ? "eye.slash" : "eye")
                    }.accessibilityLabel("ShowPasswordButton")
                    
                }.padding(.horizontal)
                
                ForEach(vm.missingValidators, id: \.rawValue) { validator in
                    Text(validator.rawValue)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                .accessibilityLabel("ValidatorsList")
                
                Spacer()
                
                Button {
                    self.vm.didTapOnLogin()
                } label: {
                    Text("Login")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .accessibilityLabel("LoginButton")
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    vm.isSignInButtonDisabled ? .gray : .blue
                )
                .cornerRadius(10)
                .disabled(vm.isSignInButtonDisabled)
                .padding(.horizontal)
                
                Button {
                    self.vm.didTapOnRegister()
                } label: {
                    Text("Sign Up")
                }
                .accessibilityLabel("SignupButton")
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .padding(.horizontal)
                
            }
            .navigationDestination(isPresented: $vm.pushToHome) {
                TaskView()
                EmptyView().hidden()
            }
            .alert(vm.alertMessage ?? "", isPresented: $vm.showingAlert) {
                Button("OK", role: .cancel) { }.accessibilityLabel("AlertCloseButton")
            }
                
        }
    }
}
