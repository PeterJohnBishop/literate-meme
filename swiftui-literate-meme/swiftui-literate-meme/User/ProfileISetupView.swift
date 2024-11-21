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
    @State var selectedImage: UIImage?
    @State var showCamera: Bool = false
    @State var sourceType: SourceType = .camera
    @State var uploaded: Bool = false
    @State var next: Bool = false
    @State var inputText: String = ""
    @State var errorMessage: String = ""
    @State var showAlert: Bool = false
    @State var saved: Bool = false

    
    var body: some View {
        VStack{
            Spacer()
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 325, height: 325)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.black.opacity(0.2))
                        .fontWeight(.ultraLight)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
//            Text("+Photo").font(.system(size: 34))
//                .fontWeight(.ultraLight)
            HStack{
                Spacer()
                ImagePickerView(imagePickerViewModel: $imagePickerViewModel, uploadType: "profile")
                    .onChange(of: imagePickerViewModel.images, {
                        oldValue, newValue in
                        if !newValue.isEmpty {
                            selectedImage = imagePickerViewModel.images[0]
                        }
                    })
                Spacer()
                Button(action: {
                    sourceType = .camera
                    self.showCamera.toggle()
                }, label: {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)
                }).sheet(isPresented: $showCamera) {
                    accessMediaView(selectedImage: $selectedImage, sourceType: sourceType).ignoresSafeArea()
                }
                Spacer()
                Button(action: {
                    if let selectedImage = selectedImage {
                        Task{
                            uploaded = await s3ViewModel.uploadImageToS3(image: selectedImage)
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
                })
                Spacer()
            }.padding()
            UnderlinedTextField(text: $inputText, next: $next, title: "", placeholder: "Username (REQUIRED)", underlineColor: .black)
                           .padding()
            Spacer()
            if uploaded && !inputText.isEmpty {
                Button {
                    if let photoURL = URL(string: s3ViewModel.imageUrl) {
                        auth.UpdateProfile(displayName: inputText, photoURL: photoURL, completion: {
                            isSuccess, message in
                            saved = isSuccess
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
        }.onChange(of: uploaded, {
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
