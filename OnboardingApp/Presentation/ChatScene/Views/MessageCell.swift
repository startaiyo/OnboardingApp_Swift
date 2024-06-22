//
//  MessageCell.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/02.
//

import SwiftUI

struct MessageCell: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .padding()
        }
    }
}
