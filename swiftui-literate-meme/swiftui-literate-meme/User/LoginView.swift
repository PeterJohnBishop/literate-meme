//
//  LoginView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/18/24.
//

import SwiftUI

struct LoginUserView: View {
    @State var auth: FireAuthViewModel = FireAuthViewModel()
    @State var password: String = ""
    @State var success: Bool = false
    @State var saved: Bool = false
    @State var newUser: Bool = false
    @State var showAlert: Bool = false
    @State var toSetup: Bool = false
    
    
    var body: some View {
        NavigationStack{
                    VStack{
                        HStack{
                            Spacer()
                            Button("Register", action: {
                                newUser = true
                            }).foregroundStyle(.black)
                                .fontWeight(.light)
                                .padding()
                                .navigationDestination(isPresented: $newUser, destination: {
                                })
                        }
                        Spacer()
                        Text("Login").font(.system(size: 34))
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
                        
                        
                        Button("Submit", action: {
                            Task{
                                auth.SignInWithEmailAndPassword()
//                                if !success {
//                                    showAlert = true
//                                }
//                                if !saved {
//                                    toSetup = true
//                                }
                            }
                           
                        }).navigationDestination(isPresented: $saved, destination: {
//                            VerifyView().navigationBarBackButtonHidden(true)
                        })
                        .navigationDestination(isPresented: $toSetup, destination: {
//                            AvatarView(userViewModel: $userViewModel).navigationBarBackButtonHidden(true)
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
                                        Text("Please re-confirm your cridentials and try again!")
                                    }
                        Spacer()
                    }.onAppear{
                        
                    }
                }
    }
}

#Preview {
    LoginUserView()
}
