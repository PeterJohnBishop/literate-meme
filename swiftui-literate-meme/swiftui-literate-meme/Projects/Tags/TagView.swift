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
            
            ZStack{
                HStack{
                    UnderlinedTextField(text: $tagViewModel.tag.tag, title: "", placeholder: "Tag Name", underlineColor: .black)
                        .padding()
                }
                HStack{
                    Spacer()
                        Button(action: {
                            tagViewModel.tag.uid = UUID().uuidString
                                Task{
                                    saved = await tagViewModel.createNewTag()
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
