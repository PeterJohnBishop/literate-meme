//
//  QRGenerator.swift
//  swiftui-literate-meme
//
//  Created by m1_air on 11/21/24.
//

import Foundation
import SwiftUI

struct QRCodeGen: View {
    @Binding var encode: String
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 300, height: 300)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                Image(uiImage: UIImage(data: getQRCodeDate(text: encode)!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 215, height: 215)
                
            }.padding()
        }
        
        func getQRCodeDate(text: String) -> Data? {
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
            let data = text.data(using: .ascii, allowLossyConversion: false)
            filter.setValue(data, forKey: "inputMessage")
            guard let ciimage = filter.outputImage else { return nil }
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledCIImage = ciimage.transformed(by: transform)
            let uiimage = UIImage(ciImage: scaledCIImage)
            return uiimage.pngData()!
        }
}
