//
//  TagViewModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import Foundation
import Observation

@Observable class TagViewModel {
    
    var tag: TagModel = TagModel()
    var tags: [TagModel] = []
    var baseURL: String = "http://192.168.0.134:4000/tags"
    var error: String = ""
    var token: String = ""
    
    func createNewTag() async -> Bool {
            print("Creating a new tag.")
        
            guard let url = URL(string: "\(baseURL)/tag") else { return false }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("Current token: \(token)")

            let body: [String: Any] = [
                "uid": tag.uid,
                "tag": tag.tag
            ]
        
        print("Sending tag: \(String(describing: body))" )

            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false}

            request.httpBody = jsonData

            do {
                let (_, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("New tag successfully added to MongoDB.")
                    return true
                } else {
                    self.error = "Error creating tag: \(response)"
                    print(self.error)
                    return false
                }
            } catch {
                self.error = "Error submitting data for new tag: \(error.localizedDescription)"
                print(self.error)
                return false
            }
        }
    
    func getTagByUid() async -> Bool {
        guard let url = URL(string: "\(baseURL)/tag/\(tag.uid)") else { return false }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.error = "Error fetching tag by UID."
                return false
            }
            self.tag = try JSONDecoder().decode(TagModel.self, from: data)
            return true
        } catch {
            self.error = "Error fetching tag: \(error.localizedDescription)"
            return false
        }
    }
    
    func fetchAllTags() async -> Bool {
        
        print("Requesting all tags.")
        
        guard let url = URL(string: "\(baseURL)/") else {
            self.error = "Invalid URL."
            return false
        }
        
        // Retrieve the JWT token from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "jwt") else {
            self.error = "Error: No token found."
            return false
        }
        
        print("Current token: \(token)")

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Ensure response is of type HTTPURLResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                self.error = "Error: Invalid response format."
                return false
            }

            if httpResponse.statusCode == 200 {
                do {
                    let decodedTags = try JSONDecoder().decode([TagModel].self, from: data)
                    self.tags = decodedTags
                    return true
                } catch {
                    self.error = "Error decoding users: \(error.localizedDescription)"
                    return false
                }
            } else {
                self.error = "Error: Unexpected status code \(httpResponse.statusCode)."
                return false
            }
        } catch {
            self.error = "Error fetching users: \(error.localizedDescription)"
            return false
        }
    }
    
    // Update a user by uid
    func updateTagByUid(uid: String) async -> Bool {
        guard let url = URL(string: "\(baseURL)/tag/\(uid)") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "tag": tag.tag
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false }
        request.httpBody = jsonData

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return true
            } else {
                self.error = "Error updating tag: \(response)"
                return false
            }
        } catch {
            self.error = "Error updating tag: \(error.localizedDescription)"
            return false
        }
    }

    // Delete a user by uid
    func deleteTagByUid(uid: String) async -> Bool {
        guard let url = URL(string: "\(baseURL)/tag/\(uid)") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return true
            } else {
                self.error = "Error deleting tag: \(response)"
                return false
            }
        } catch {
            self.error = "Error deleting tag: \(error.localizedDescription)"
            return false
        }
    }
    
}


