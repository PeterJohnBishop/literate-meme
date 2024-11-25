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
    var token: String = ""
    
    func createNewUser() async -> Bool {
            print("Creating a new user.")
            guard let url = URL(string: "\(baseURL)/user") else { return false }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


            let body: [String: Any] = [
                "uid": user.uid,
                "username": user.username,
                "userPhotoURL": user.userPhotoURL,
                "connections": user.connections,
                "media": user.media,
                "locationLat": user.locationLat,
                "locationLong": user.locationLong
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
    
//    func fetchUser(byId userId: String) async -> Bool {
//        guard let url = URL(string: "\(baseURL)/\(userId)") else { return false }
//        
//        // Retrieve the JWT token from UserDefaults
//        guard let token = UserDefaults.standard.string(forKey: "jwt") else {
//            self.error = "Error: No token found."
//            return false
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                let decodedUser = try JSONDecoder().decode(UserData.self, from: data)
//                self.user = decodedUser
//                return true
//            } else {
//                self.error = "Error: No user found with that ID."
//                return false
//            }
//        } catch {
//            self.error = "Error fetching user: \(error.localizedDescription)"
//            return false
//        }
//    }
    
    func fetchAllUsers() async -> Bool {
        guard let url = URL(string: "\(baseURL)/") else {
            self.error = "Invalid URL."
            return false
        }
        
        // Retrieve the JWT token from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "jwt") else {
            self.error = "Error: No token found."
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
    
//    func updateUser(userUpdate: UserData) async -> Bool {
//        print("Updating user!")
//        guard let url = URL(string: "\(baseURL)/\(userUpdate._id ?? "NoUser")") else { return false }
//        
//        // Retrieve the JWT token from UserDefaults
//        guard let token = UserDefaults.standard.string(forKey: "jwt") else {
//            self.error = "Error: No token found."
//            return false
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        let body: [String: Any] = [
//            "username": userUpdate.username,
//            "email": userUpdate.email,
//            "password": userUpdate.password,
//        ]
//
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false }
//
//        request.httpBody = jsonData
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                return true
//            } else {
//                self.error = "Error: Invalid response"
//                return false
//            }
//        } catch {
//            self.error = "Error updating user: \(error.localizedDescription)"
//            return false
//        }
//    }
//    
//    func deleteUser(byId userId: String) async -> Bool {
//        guard let url = URL(string: "\(baseURL)/\(userId)") else { return false }
//        
//        // Retrieve the JWT token from UserDefaults
//        guard let token = UserDefaults.standard.string(forKey: "jwt") else {
//            self.error = "Error: No token found."
//            return false
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        do {
//            let (_, response) = try await URLSession.shared.data(for: request)
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                self.error = "User deleted successfully"
//                return true
//            } else {
//                self.error = "Error: Invalid response"
//                return false
//            }
//        } catch {
//            self.error = "Error deleting user: \(error.localizedDescription)"
//            return false
//        }
//    }

}
