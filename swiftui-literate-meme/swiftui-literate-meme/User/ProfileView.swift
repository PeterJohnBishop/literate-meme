//
//  ProfileView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/19/24.
//

import SwiftUI

struct ProfileView: View {
    @State var auth: FireAuthViewModel = FireAuthViewModel()
    
    var body: some View {
        VStack{
            Text(auth.user?.displayName ?? "")
            if let photoURL = auth.user?.photoURL {
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
                .frame(width: 325, height: 325)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            } else {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .frame(width: 256, height: 256)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }.onAppear{
            auth.GetCurrentUser()
        }
    }
}

//#Preview {
//    ProfileView()
//}

