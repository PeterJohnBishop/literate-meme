//
//  AddTagsView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/4/24.
//

import SwiftUI

struct AddTagsView: View {
    //load these options into mongodb
    let tagOptions: [String] = [
        "React",
        "SwiftUI",
        "Flutter",
        "MongoDB",
        "Mongoose",
        "Firebase Auth",
        "Firebase Cloud Database",
        "Firebase Firestore",
        "AWS",
        "S3",
        "PhotoKit",
        "MapKit",
        "GTFS-RT",
        "REST API",
        "OAuth",
        "JSON Web Token",
        "Heroku",
        "Socket.IO",
        "Google Maps API",
        "OpenWeather API",
    ]
    
    var body: some View {
        Text("Add Tags")
    }
}

#Preview {
    AddTagsView()
}
