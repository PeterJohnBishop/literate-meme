//
//  UserViewModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/18/24.
//

import Foundation
import Observation
import CryptoKit

@Observable class UserViewModel {
    
    var user: UserModel = UserModel()
    var users: [UserModel] = []
    var baseURL: String = "http://127.0.0.1:4000/users"
    var error: String = ""
    
    func createNewUser() async -> Bool {
            print("Creating a new user.")
            guard let url = URL(string: "\(baseURL)/user") else { return false }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "uid": user.uid,
                "username": user.username,
                "userPhotoURL": user.userPhotoURL
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false}

            request.httpBody = jsonData

            do {
                let (_, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("New user successfully added to MongoDB.")
                    return true
                } else {
                    self.error = "Error creating user: \(response)"
                    print(self.error)
                    return false
                }
            } catch {
                self.error = "Error submitting data for new user: \(error.localizedDescription)"
                print(self.error)
                return false
            }
        }
    
    // Get a user by uid
    func getUserByUid() async -> Bool {
        guard let url = URL(string: "\(baseURL)/user/\(user.uid)") else { return false }
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
                self.error = "Error fetching user by UID."
                return false
            }
            self.user = try JSONDecoder().decode(UserModel.self, from: data)
            return true
        } catch {
            self.error = "Error fetching user: \(error.localizedDescription)"
            return false
        }
    }
    
    func fetchAllUsers() async -> Bool {
        guard let url = URL(string: "\(baseURL)/") else {
            self.error = "Invalid URL."
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
                return false
            }

            if httpResponse.statusCode == 200 {
                do {
                    let decodedUsers = try JSONDecoder().decode([UserModel].self, from: data)
                    self.users = decodedUsers
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
    func updateUserByUid(uid: String) async -> Bool {
        guard let url = URL(string: "\(baseURL)/user/\(uid)") else { return false }
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
            "username": user.username,
            "userPhotoURL": user.userPhotoURL
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false }
        request.httpBody = jsonData

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return true
            } else {
                self.error = "Error updating user: \(response)"
                return false
            }
        } catch {
            self.error = "Error updating user: \(error.localizedDescription)"
            return false
        }
    }

    // Delete a user by uid
    func deleteUserByUid(uid: String) async -> Bool {
        guard let url = URL(string: "\(baseURL)/user/\(uid)") else { return false }
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
                self.error = "Error deleting user: \(response)"
                return false
            }
        } catch {
            self.error = "Error deleting user: \(error.localizedDescription)"
            return false
        }
    }

}
