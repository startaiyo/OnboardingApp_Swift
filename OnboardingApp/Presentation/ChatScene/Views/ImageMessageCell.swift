//
//  ImageMessageCell.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import SwiftUI

struct ImageMessageCell: View {
    var title: String
    var imageURLString: String

    var body: some View {
        LazyVStack {
            Text(title)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            AsyncImage(url: URL(string: imageURLString)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "photo")
            }
        }
        .padding()
    }
}
