//
//  ProfileSetupView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/19/24.
//

import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    @State var s3ViewModel: S3ViewModel = S3ViewModel()
    @State var selectedImage: UIImage?
    @State var showCamera: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack{
            Button(action: {
                    self.showCamera.toggle()
                }, label: {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.black)
                }).fullScreenCover(isPresented: $showCamera) {
                    accessCameraView(selectedImage: $selectedImage, sourceType: sourceType)
                        .background(.black)
                }
        }
    }
}

#Preview {
    ProfileSetupView()
}
