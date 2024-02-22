//
//  MyCapturesCellView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by JunHyuk Yoon on 2/21/24.
//

import SwiftUI

struct MyCapturesCellView: View {
    
    let thumbnailPath: String
    
    var body: some View {
        let aspectRatio = 3.0/4.0
        let frameWidth = UIScreen.main.bounds.width / 2.2
        let frameHeight = frameWidth / aspectRatio
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: thumbnailPath), transaction: Transaction(animation: .default)) { phase in
                switch phase {
                case .empty:
                    //ProgressView()
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.yellow.opacity(0.5))
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: frameWidth, height: frameHeight)
                        .cornerRadius(10)
                case .failure:
                    Color.blue // Indicates an error.
                    Text("\(phase.error?.localizedDescription ?? "")")
                    //let _ = print("AsyncImage Error : \(phase.error?.localizedDescription ?? "")")
                default:
                    Color.green // Indicates an error.
                    Text("\(phase.error?.localizedDescription ?? "")")
                }
            }
            .frame(width: frameWidth, height: frameHeight)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(thumbnailPath)
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundColor(Color("DarkPurpleColor"))
                Text("@Richeeze.com")
            }
            .font(.callout)
            .foregroundColor(Color("SecondaryAccentColor"))
        }
    }
}
