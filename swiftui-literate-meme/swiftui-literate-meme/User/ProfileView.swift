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
    @State var postViewModel: PostViewModel = PostViewModel()
    @State var userUID: String = ""
    @State var addProject: Bool = false
    @State var showScanner: Bool = false
    @State var scannedText: String = ""
    @State var responseText: String = ""
    @State var showAlert: Bool = false
    @State var createPost: Bool = false
    @State var showPosts: Bool = false
    
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
                        }
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .foregroundStyle(.black.opacity(1))
                            .fontWeight(.ultraLight)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 15)
                    }
                    Button(action: {
                        createPost = true
                    }, label: {
                        Image(systemName: "plus.rectangle.on.rectangle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.black)
                    }).navigationDestination(isPresented: $createPost, destination: {
                        CreatePostView()
                    })
                    .padding()
                    if showPosts {
                                    ForEach(postViewModel.posts.indices, id: \.self) { index in
                                        HStack{
                                            Group{
                                                Text(postViewModel.posts[index].title).fontWeight(.bold).foregroundStyle(.black)
                                            }.onTapGesture {
                                                
                                            }
                                        }
                                    }
                                }
                    Spacer()
                }
                Spacer()
            }.onAppear{
                    auth.fetchFirebaseAuthToken()
                Task {
                    showPosts = await postViewModel.fetchAllPosts()
                }
            }
            .onChange(of: auth.token, {
                oldValue, newValue in
                if !newValue.isEmpty {
                    UserDefaults.standard.set(newValue, forKey: "authToken")
                    auth.GetCurrentUser()
                }
            })
        }.tint(.black)
    }
}

#Preview {
    ProfileView()
}

