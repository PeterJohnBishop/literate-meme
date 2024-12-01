//
//  PlaygroundView.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 12/1/24.
//

import SwiftUI

struct PlaygroundView: View {
    @State var output: String = "Hey World"
    
    var body: some View {
        Text(output)
    }
}

#Preview {
    PlaygroundView()
}
