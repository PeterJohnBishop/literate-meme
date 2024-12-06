//
//  ProjectViewModel.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import Foundation
import Observation

@Observable class ProjectViewModel {
    
    var project: ProjectModel = ProjectModel()
    var projects: [ProjectModel] = []
    var baseURL: String = "http://127.0.0.1:4000/projects"
    var error: String = ""
    var token: String = ""
    
    func createNewProject() async -> Bool {
            print("Creating a new project.")
            guard let url = URL(string: "\(baseURL)/project") else { return false }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


            let body: [String: Any] = [
                "uid": project.uid,
                "photos": project.photos,
                "title": project.title,
                "description": project.description,
                "tags": project.tags
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false}

            request.httpBody = jsonData

            do {
                let (_, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("New project successfully added to MongoDB.")
                    return true
                } else {
                    self.error = "Error creating tag: \(response)"
                    print(self.error)
                    return false
                }
            } catch {
                self.error = "Error submitting data for new project: \(error.localizedDescription)"
                print(self.error)
                return false
            }
        }
    
    // Get a user by uid
    func getProjectByUid() async -> Bool {
        guard let url = URL(string: "\(baseURL)/project/\(project.uid)") else { return false }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.error = "Error fetching project by UID."
                return false
            }
            self.project = try JSONDecoder().decode(ProjectModel.self, from: data)
            return true
        } catch {
            self.error = "Error fetching project: \(error.localizedDescription)"
            return false
        }
    }
    
    func fetchAllProjects() async -> Bool {
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
                    let decodedProjects = try JSONDecoder().decode([ProjectModel].self, from: data)
                    self.projects = decodedProjects
                    return true
                } catch {
                    self.error = "Error decoding project: \(error.localizedDescription)"
                    return false
                }
            } else {
                self.error = "Error: Unexpected status code \(httpResponse.statusCode)."
                return false
            }
        } catch {
            self.error = "Error fetching project: \(error.localizedDescription)"
            return false
        }
    }
    
    func updateProjectByUid(uid: String) async -> Bool {
        guard let url = URL(string: "\(baseURL)/project/\(uid)") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "photos": project.photos,
            "title": project.title,
            "description": project.description,
            "tags": project.tags
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return false }
        request.httpBody = jsonData

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return true
            } else {
                self.error = "Error updating project: \(response)"
                return false
            }
        } catch {
            self.error = "Error updating project: \(error.localizedDescription)"
            return false
        }
    }

    func deleteProjectByUid(uid: String) async -> Bool {
        guard let url = URL(string: "\(baseURL)/project/\(uid)") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return true
            } else {
                self.error = "Error deleting project: \(response)"
                return false
            }
        } catch {
            self.error = "Error deleting project: \(error.localizedDescription)"
            return false
        }
    }
    
}
