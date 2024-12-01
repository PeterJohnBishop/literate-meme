//
//  LoginView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/18/24.
//

import SwiftUI

struct LoginUserView: View {
    @State var auth: FireAuthViewModel = FireAuthViewModel()
    @State var newUser: Bool = false
    @State var showAlert: Bool = false
    
    
    var body: some View {
        NavigationStack{
                    VStack{
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
                        .onChange(of: auth.response, {
                            oldResponse, newResponse in
                            if newResponse != "" {
                                showAlert = true
                            }
                        })
                        .alert("Error", isPresented: $showAlert) {
                                        Button("OK", role: .cancel) {
                                            auth.email = ""
                                            auth.password = ""
                                            auth.response = ""
                                        }
                                    } message: {
                                        Text(auth.response)
                                    }
                                    .navigationDestination(isPresented: $auth.success, destination: {
                                        ProfileView().navigationBarBackButtonHidden(true)
                                    })
                        Spacer()
                        HStack{
                            Spacer()
                            Text("I don't have an account.").fontWeight(.ultraLight)
                            Button("Register", action: {
                                newUser = true
                            }).foregroundStyle(.black)
                                .fontWeight(.light)
                                .navigationDestination(isPresented: $newUser, destination: {
                                    RegisterView().navigationBarBackButtonHidden(true)
                                })
                            Spacer()
                        }
                    }.onAppear{
                        
                    }
                }
    }
}

#Preview {
    LoginUserView()
}
