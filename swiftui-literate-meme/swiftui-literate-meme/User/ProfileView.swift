//
//  ProfileView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/19/24.
//

import SwiftUI

struct ProfileView: View {
    @State var auth: FireAuthViewModel = FireAuthViewModel()
    @State var userUID: String = ""
    @State var showQR: Bool = false
    @State var showScanner: Bool = false
    @State var scannedText: String = ""
    @State var responseText: String = ""
    
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
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .frame(width: 256, height: 256)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                    }
                    Button(action: {
                        showScanner = true
                    }, label: {
                        Image(systemName: "qrcode.viewfinder").foregroundStyle(.black)
                    }).frame(width: 50, height: 50) // Circular button size
                        .background(Circle().fill(Color.white)) // Circular background
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5) // Drop shadow
                        .navigationDestination(isPresented: $showScanner, destination: {
                            QRCodeScan(showScanner: $showScanner, scannedText: $scannedText)
                        }).padding()
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

