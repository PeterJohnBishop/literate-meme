//
//  RegisterView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/18/24.
//

import SwiftUI

struct RegisterView: View {
    @State var auth: FireAuthViewModel = FireAuthViewModel()
    @State var confirmPassword: String = ""
    @State var existingUser: Bool = false
    @State var showAlert: Bool = false
    
    
    var body: some View {
        NavigationStack{
                    VStack{
                        Spacer()
                        Text("Register").font(.system(size: 34))
                            .fontWeight(.ultraLight)
                        Divider().padding()
                        TextField("Email", text: $auth.email)
                            .tint(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                        
                        SecureField("Password", text: $auth.password)
                            .tint(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .tint(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                        
                        
                        Button("Submit", action: {
                            Task{
                                auth.CreateUser()
                            }
                        })
                        .fontWeight(.ultraLight)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                        )
                        .alert("Error", isPresented: $showAlert) {
                                        Button("OK", role: .cancel) {
                                            auth.email = ""
                                            auth.password = ""
                                        }
                                    } message: {
                                        Text(auth.status)
                                    }
                                    .navigationDestination(isPresented: $auth.success, destination: {
                                        ProfileSetupView().navigationBarBackButtonHidden(true)
                                    })
                        Spacer()
                        HStack{
                            Spacer()
                            Text("I have an account.").fontWeight(.ultraLight)
                            Button("Login", action: {
                                existingUser = true
                            }).foregroundStyle(.black)
                                .fontWeight(.light)
                                .navigationDestination(isPresented: $existingUser, destination: {
                                    LoginUserView().navigationBarBackButtonHidden(true)
                                })
                            Spacer()
                        }
                    }.onAppear{
                        
                    }
                }
    }
}

#Preview {
    RegisterView()
}
