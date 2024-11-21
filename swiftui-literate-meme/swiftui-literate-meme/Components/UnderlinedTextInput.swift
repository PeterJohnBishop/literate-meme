//
//  CustomTextInput.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/20/24.
//

import Foundation
import SwiftUI

struct UnderlinedTextField: View {
    @Binding var text: String
    @Binding var next: Bool
    var title: String = ""
    var placeholder: String = ""
    var underlineColor: Color = .black

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).fontWeight(.ultraLight)
                TextField(placeholder, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 8)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(underlineColor)
                            .padding(.top, 35),
                        alignment: .bottom
                    ).tint(.black)
        }
        .padding(.horizontal)
    }
}
