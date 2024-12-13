//
//  ProfileSetupView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/19/24.
//

import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    @State var auth: FireAuthViewModel = FireAuthViewModel()
    @State var s3ViewModel: S3ViewModel = S3ViewModel()
    @State var imagePickerViewModel: ImagePickerViewModel = ImagePickerViewModel()
    @State var userViewModel: UserViewModel = UserViewModel()
    @State var selectedImages: [UIImage] = [] // Changed to non-optional
    @State var showCamera: Bool = false
    @State var sourceType: SourceType = .camera
    @State var uploaded: Bool = false
    @State var inputText: String = ""
    @State var errorMessage: String = ""
    @State var showAlert: Bool = false
    @State var saved: Bool = false
    @State var uploadType: String = "profile"

    
    var body: some View {
        VStack{
            Spacer()
            if !selectedImages.isEmpty {
                Image(uiImage: selectedImages[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: 325, height: 325)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.black.opacity(1))
                        .fontWeight(.ultraLight)
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 15)
                }
            HStack{
                Spacer()
                ImagePickerView(imagePickerViewModel: $imagePickerViewModel, uploadType: $uploadType)
                    .onChange(of: imagePickerViewModel.images, {
                        oldValue, newValue in
                        if !newValue.isEmpty {
                            selectedImages = imagePickerViewModel.images
                        }
                    }).padding()
                Spacer()
                Button(action: {
                    sourceType = .camera
                    self.showCamera.toggle()
                }, label: {
                    Image(systemName: "person.fill.viewfinder")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)

                }).sheet(isPresented: $showCamera) {
                    accessMediaView(selectedImages: $selectedImages, sourceType: sourceType).ignoresSafeArea()
                }.padding()
                Spacer()
                Button(action: {
                    if !selectedImages.isEmpty {
                        Task{
                            uploaded = await s3ViewModel.uploadImageToS3(image: selectedImages[0])
                        }
                    }
                }, label: {
                    if uploaded {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.black)
                    }
                }).padding()
                Spacer()
            }.padding()
            if uploaded {
                UnderlinedTextField(text: $inputText, title: "", placeholder: "Username", underlineColor: .black)
                    .padding()
            }
            Spacer()
            if uploaded && !inputText.isEmpty {
                Button {
                    if let photoURL = URL(string: s3ViewModel.imageUrl) {
                        auth.UpdateProfile(displayName: inputText, photoURL: photoURL, completion: {
                            isSuccess, message in
                            if isSuccess {
                                Task{
                                    userViewModel.user.uid = auth.user!.uid
                                    userViewModel.user.username = (auth.user?.displayName)!
                                    userViewModel.user.userPhotoURL = (auth.user?.photoURL!.absoluteString)!
                                    saved = await userViewModel.createNewUser()
                                }
                            }
                            errorMessage = message
                        })
                    } else {
                        showAlert = true
                        errorMessage = "Invalid photo URL"
                    }
                } label: {
                    Text("Save")
                        .fontWeight(.ultraLight)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                        )
                } .alert("Error", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {
                        inputText = ""
                    }
                } message: {
                    Text(errorMessage)
                }
                .navigationDestination(isPresented: $saved, destination: {
                    ProfileView().navigationBarBackButtonHidden(true)
                })

            }
        }.onAppear{
            auth.fetchFirebaseAuthToken()
        }
        .onChange(of: auth.token, {
            oldValue, newValue in
            
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: "authToken")
                auth.GetCurrentUser()
            }
        })
        .onChange(of: uploaded, {
            oldValue, newValue in
            
            if !newValue {
                uploaded = newValue
            }
        })
    }
}

#Preview {
    ProfileSetupView()
}
