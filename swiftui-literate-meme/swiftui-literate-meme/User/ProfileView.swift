//
//  ProfileView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/19/24.
//

import SwiftUI

struct ProfileView: View {
    @State var auth: FireAuthViewModel = FireAuthViewModel()
    @State var userViewModel: UserViewModel = UserViewModel()
    @State var userUID: String = ""
    @State var showQR: Bool = false
    @State var showScanner: Bool = false
    @State var scannedText: String = ""
    @State var responseText: String = ""
    @State var showAlert: Bool = false
    
    func confirmSecureEndpoint(token: String) {
        guard let url = URL(string: "http://localhost:4000/secured-endpoint") else {
            responseText = "Invalid URL"
            return
        }
        
        // Add your authorization token if required
        let token = token // Replace with your actual token
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseText = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    responseText = "Server error or unauthorized access"
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseText = responseString
                }
            } else {
                DispatchQueue.main.async {
                    responseText = "Failed to decode response"
                }
            }
        }
        
        task.resume()
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    Text(auth.user?.displayName ?? "").font(.system(size: 34))
                        .fontWeight(.ultraLight)
                    Text(auth.user?.email ?? "").font(.system(size: 14))
                        .fontWeight(.ultraLight)
                }
                Divider().padding()
                VStack{
                    if (showQR) {
                        if let userUID = auth.user?.uid {
                            QRCodeGen(encode: $userUID)
                                .onTapGesture {
                                    showQR.toggle()
                                }
                        }
                    } else {
                        if let photoURL = auth.user?.photoURL {
                            VStack{
                                AsyncImage(url: photoURL) { phase in
                                    switch phase {
                                    case .failure:
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                    case .success(let image):
                                        image
                                            .resizable()
                                    default:
                                        ProgressView()
                                    }
                                }
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                .onTapGesture {
                                    showQR.toggle()
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 300, height: 300)
                                .foregroundStyle(.black.opacity(1))
                                .fontWeight(.ultraLight)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 15)
                        }
                    }
                    HStack{
                        Spacer()

                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "map").resizable().frame(width: 50, height: 50).foregroundStyle(.black)
                        }).frame(width: 50, height: 50) // Circular button size
                            .padding()
                        Spacer()
                        Button(action: {
                            showScanner = true
                        }, label: {
                            Image(systemName: "qrcode.viewfinder").resizable().frame(width: 50, height: 50).foregroundStyle(.black)
                        }).frame(width: 50, height: 50) // Circular button size
                            .navigationDestination(isPresented: $showScanner, destination: {
                                QRCodeScan(showScanner: $showScanner, scannedText: $scannedText)
                            }).padding()
                            .onChange(of: scannedText, {
                                userViewModel.user.uid = scannedText
                                Task{
                                    let found = await userViewModel.getUserByUid()
                                    if found {
                                        print("Add \(userViewModel.user.username) to your connections?")
                                    } else {
                                        print("No user found by uid \(userViewModel.user.uid)!")
                                    }
                                }
                            })
                            .alert("Connect with \(userViewModel.user.username)?", isPresented: $showAlert) {
                                HStack{
                                    Button("OK", role: .cancel) {
                                        auth.email = ""
                                        auth.password = ""
                                        auth.response = ""
                                    }
                                    Button("Connect", role: .cancel) {
                                        
                                    }
                                }
                                
                                        } message: {
                                            Text(auth.response)
                                        }
                                        .navigationDestination(isPresented: $auth.success, destination: {
                                            ProfileView().navigationBarBackButtonHidden(true)
                                        })
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "mappin.and.ellipse").resizable().frame(width: 50, height: 50).foregroundStyle(.black)
                        }).frame(width: 50, height: 50) // Circular button size
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
            }.onAppear{
                    auth.fetchFirebaseAuthToken()
            }
            .onChange(of: auth.token, {
                oldValue, newValue in
                
                if !newValue.isEmpty {
                    UserDefaults.standard.set(newValue, forKey: "authToken")
                    confirmSecureEndpoint(token: UserDefaults.standard.string(forKey: "authToken") ?? "noToken")
                    auth.GetCurrentUser()
                }
            })
        }
    }
}

#Preview {
    ProfileView()
}

