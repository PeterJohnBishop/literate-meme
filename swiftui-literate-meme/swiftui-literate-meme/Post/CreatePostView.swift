//
//  CreatePostView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/10/24.
//

import Foundation
import SwiftUI

struct CreatePostView: View {
    @State var postViewModel: PostViewModel = PostViewModel()
    @State var s3ViewModel: S3ViewModel = S3ViewModel()
    @State var imagePickerViewModel: ImagePickerViewModel = ImagePickerViewModel()
    @State var selectedImages: [UIImage] = [] // Changed to non-optional
    @State var showCamera: Bool = false
    @State var sourceType: SourceType = .camera
    @State var uploaded: Bool = false
    @State var submitted: Bool = false
    
    var body: some View {
        ScrollView {
            ImageUploadView(s3ViewModel: $s3ViewModel, imagePickerViewModel: $imagePickerViewModel, selectedImages: $selectedImages, showCamera: $showCamera, sourceType: $sourceType, uploaded: $uploaded)
            TextField("Title", text: $postViewModel.post.title).padding()
            TextEditor(text: $postViewModel.post.content)
                .frame(height: 300)
                .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                .tint(.black)
                .padding()
            Button {
                postViewModel.post.photos = s3ViewModel.imageUrls
                Task{
                    submitted = await postViewModel.createNewPost()
                }
                } label: {
                    Text("Submit")
                }.fontWeight(.ultraLight)
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    )
                    .navigationDestination(isPresented: $submitted, destination: {
                        ProfileView().navigationBarBackButtonHidden(true)
                    })
            Spacer()
        }.padding()
    }
}


#Preview {
    CreatePostView()
}
