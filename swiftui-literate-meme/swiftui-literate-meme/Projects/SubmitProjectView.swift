//
//  SubmitProjectView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import SwiftUI

// Publish a Project to the website

struct SubmitProjectView: View {
//    @State var auth: FireAuthViewModel = FireAuthViewModel()
    @State var s3ViewModel: S3ViewModel = S3ViewModel()
    @State var tagViewModel: TagViewModel = TagViewModel()
    @State var imagePickerViewModel: ImagePickerViewModel = ImagePickerViewModel()
//    @State var userViewModel: UserViewModel = UserViewModel()
    @State var selectedImages: [UIImage?] = []
    @State var selectedTags: [TagModel] = []
    @State var capturedImage: UIImage?
    @State var sourceType: SourceType = .camera
    @State var uploaded: Bool = false
    @State var showCamera: Bool = false
    @State var next: Bool = false
    @State var titleText: String = ""
    @State var uploadedImages = 0
    @State var descriptionText: String = ""
    @State var newTag: Bool = false
    @State private var isProject: Bool = true
    
    var body: some View {
        HStack {
                   Button(action: {
                       isProject = true
                   }) {
                       Text("Project")
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(isProject ? Color.black : Color.gray.opacity(0.2))
                           .foregroundColor(isProject ? .white : .black)
                           .cornerRadius(8)
                   }

                   Button(action: {
                       isProject = false
                   }) {
                       Text("Blog Post")
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(!isProject ? Color.black : Color.gray.opacity(0.2))
                           .foregroundColor(!isProject ? .white : .black)
                           .cornerRadius(8)
                   }
               }
               .padding()
        ScrollView{
                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 20) {
                                ForEach(selectedImages.indices, id: \.self) { index in
                                    Image(uiImage: selectedImages[index]!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 325, height: 325)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                        .padding()
                                }
                            }.padding()
                        }
                    } else {
                        Image(systemName: "photo.stack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .foregroundStyle(.black.opacity(1))
                            .fontWeight(.ultraLight)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 15)
                    }
            HStack{
                Spacer()
                ImagePickerView(imagePickerViewModel: $imagePickerViewModel, uploadType: "project")
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
                    Image(systemName: "camera.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)

                }).sheet(isPresented: $showCamera) {
                    accessMediaView(selectedImage: $capturedImage, sourceType: sourceType).ignoresSafeArea()
                }.padding()
                Spacer()
                Button(action: {
                    if let capturedImage = capturedImage {
                        Task{
                            uploaded = await s3ViewModel.uploadImageToS3(image: capturedImage, token: UserDefaults.standard.string(forKey: "authToken") ?? "invalidToken")
                        }
                    }
                    if !selectedImages.isEmpty {
                        Task {
                                for index in selectedImages.indices {
                                    let success = await s3ViewModel.uploadImageToS3(
                                        image: selectedImages[index]!,
                                        token: UserDefaults.standard.string(forKey: "authToken") ?? "invalidToken"
                                    )
                                    if success {
                                        uploadedImages += 1 // Increment only on successful upload
                                    }
                                }

                                if uploadedImages == selectedImages.count {
                                    print("All images uploaded successfully!")
                                } else {
                                    print("Uploaded \(uploadedImages) out of \(selectedImages.count) images.")
                                }
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
            UnderlinedTextField(text: $titleText, title: "", placeholder: "Title", underlineColor: .black)
                    .padding()
            TextEditor(text: $descriptionText)
                            .frame(height: 300)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            .tint(.black)
                            .padding()
            Button("+ New Tag", action: {
                newTag = true
            })
            .fontWeight(.ultraLight)
            .foregroundColor(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
            ).sheet(isPresented: $newTag, onDismiss: {
                Task{
                    await tagViewModel.fetchAllTags()
                }
            }, content: {
                TagView()
                    .presentationDetents([.height(300)])
            })
            if !tagViewModel.tags.isEmpty {
                ForEach(tagViewModel.tags.indices, id: \.self) { index in
                    HStack{
                        Group{
                            AsyncImage(url: URL(string: tagViewModel.tags[index].icon))
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                .padding()
                            Text(tagViewModel.tags[index].tag).fontWeight(.bold).foregroundStyle(.black)
                        }.onTapGesture {
                            selectedTags.append(tagViewModel.tags[index])
                        }
                    }
                }
            }
        }.onAppear{
            Task{
                await tagViewModel.fetchAllTags()
            }
        }
    }
}

#Preview {
    SubmitProjectView()
}
