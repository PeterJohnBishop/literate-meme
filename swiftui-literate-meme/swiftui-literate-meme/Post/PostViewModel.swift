//
//  PostViewModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/10/24.
//

import Foundation
import Observation

@Observable class PostViewModel {
    var post: PostModel = PostModel()
    var posts: [PostModel] = []
    var baseURL: String = "http://127.0.0.1:4000/posts"
    var error: String = ""

    func createNewPost() async -> Bool {
            guard let url = URL(string: "\(baseURL)/post") else { return false }
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                self.error = "Error: No token found."
                print(self.error)
                return false
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


            let body: [String: Any] = [
                "documentId": post.documentId,
                "photos": post.photos,
                "title": post.title,
                "content": post.content,
                "comments": post.comments
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false}

            request.httpBody = jsonData

            do {
                let (_, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("New Post successfully added to MongoDB.")
                    return true
                } else {
                    self.error = "Error creating Post: \(response)"
                    print(self.error)
                    return false
                }
            } catch {
                self.error = "Error submitting data for new Post: \(error.localizedDescription)"
                print(self.error)
                return false
            }
        }
    
    func getPostByDocumentID(id: String) async -> Bool {
        guard let url = URL(string: "\(baseURL)/post/\(id)") else { return false }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            self.error = "Error: No token found."
            print(self.error)
            return false
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.error = "Error fetching Post by DocumentID."
                return false
            }
            self.post = try JSONDecoder().decode(PostModel.self, from: data)
            return true
        } catch {
            self.error = "Error fetching post: \(error.localizedDescription)"
            return false
        }
    }
    
    func fetchAllPosts() async -> Bool {
                        
            guard let url = URL(string: "\(baseURL)/") else {
                self.error = "Invalid URL."
                print(self.error)
                return false
            }
            
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                self.error = "Error: No token found."
                print(self.error)
                return false
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Ensure response is of type HTTPURLResponse
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "Error: Invalid response format."
                    print(self.error)
                    return false
                }

                if httpResponse.statusCode == 200 {
                    do {
                        let decodedPosts = try JSONDecoder().decode([PostModel].self, from: data)
                        self.posts = decodedPosts
                        return true
                    } catch {
                        self.error = "Error decoding tags: \(error.localizedDescription)"
                        print(self.error)
                        return false
                    }
                } else {
                    self.error = "Error: Unexpected status code \(httpResponse.statusCode)."
                    print(self.error)
                    return false
                }
            } catch {
                self.error = "Error fetching tags: \(error.localizedDescription)"
                print(self.error)
                return false
            }
            
        }
        
        func updatePostByDocumentID(id: String) async -> Bool {
            guard let url = URL(string: "\(baseURL)/post/\(id)") else { return false }
            
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                self.error = "Error: No token found."
                print(self.error)
                return false
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let body: [String: Any] = [
                "photos": post.photos,
                "title": post.title,
                "content": post.content,
                "comments": post.comments
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false }
            request.httpBody = jsonData

            do {
                let (_, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    return true
                } else {
                    self.error = "Error updating post: \(response)"
                    return false
                }
            } catch {
                self.error = "Error updating post: \(error.localizedDescription)"
                return false
            }
        }

        func deletePostByDocumentID(id: String) async -> Bool {
            guard let url = URL(string: "\(baseURL)/post/\(id)") else { return false }
            
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                self.error = "Error: No token found."
                print(self.error)
                return false
            }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            do {
                let (_, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    return true
                } else {
                    self.error = "Error deleting post: \(response)"
                    return false
                }
            } catch {
                self.error = "Error deleting post: \(error.localizedDescription)"
                return false
            }
        }

}
