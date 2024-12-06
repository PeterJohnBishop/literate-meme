//
//  TagView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import SwiftUI

// Upload a new tag or Select from a list of existing tags

struct TagView: View {
    @State var imagePickerViewModel: ImagePickerViewModel = ImagePickerViewModel()
    @State var s3ViewModel: S3ViewModel = S3ViewModel()
    @State var tagViewModel: TagViewModel = TagViewModel()
    @State var selectedImage: UIImage?
    @State var isProcessing: Bool = false
    @State var uploaded: Bool = false
    @State var saved: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            if isProcessing {
                ProgressView()
            } else {
                if let selectedImage = selectedImage {
                    ZStack{
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action: {
                                    Task{
                                        uploaded = await s3ViewModel.uploadImageToS3(image: selectedImage, token: UserDefaults.standard.string(forKey: "authToken") ?? "invalidToken")
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
                                }).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 20))
                            }
                        }
                    }
                } else {
                    ImagePickerView(imagePickerViewModel: $imagePickerViewModel, uploadType: "tag")
                        .onChange(of: imagePickerViewModel.images, {
                            oldValue, newValue in
                            if !newValue.isEmpty {
                                selectedImage = imagePickerViewModel.images[0]
                            }
                        }).padding()
                }
            }
            ZStack{
                HStack{
                    UnderlinedTextField(text: $tagViewModel.tag.tag, title: "", placeholder: "Tag Name", underlineColor: .black)
                        .padding()
                }
                HStack{
                    Spacer()
                        Button(action: {
                            if uploaded {
                                tagViewModel.tag.icon = s3ViewModel.imageUrl
                                Task{
                                    saved = await tagViewModel.createNewTag()
                                }
                            }
                        }, label: {
                            Image(systemName: "square.and.arrow.up").resizable()
                                .frame(width: 30, height: 40)
                                .foregroundStyle(.black)
                        }).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 30))
                    
                }
            }
            Spacer()
        }.onAppear{
            tagViewModel.token = UserDefaults.standard.string(forKey: "authToken")!
        }
    }
}

#Preview {
    TagView()
}
