//
//  ChatRow.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/04/08.
//

import SwiftUI

struct ChatRow: View {
    let message: MessageModel
    let isCurrentUser: Bool
    let userAppService: UserAppService
    @State var messageUserName: String = ""
    private let incomingMessageCornerRadii = RectangleCornerRadii(topLeading: 0.0,
                                                                  bottomLeading: 10.0,
                                                                  bottomTrailing: 10.0,
                                                                  topTrailing: 10.0)
    private let outgoingMessageCornerRadii = RectangleCornerRadii(topLeading: 10.0,
                                                                  bottomLeading: 10.0,
                                                                  bottomTrailing: 0.0,
                                                                  topTrailing: 10.0)

    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading) {
            if !isCurrentUser {
                HStack {
                    Image(systemName: "person.circle")
                    Text(messageUserName)
                }
            }
            if let image = message.image {
                ImageMessageCell(title: image.title,
                                 imageURLString: image.imageURLString)
                    .frame(maxWidth: .infinity)
                    .background{
                        UnevenRoundedRectangle(cornerRadii: isCurrentUser ? outgoingMessageCornerRadii : incomingMessageCornerRadii)
                            .foregroundStyle(.green)
                    }
            } else {
                MessageCell(text: message.text)
                    .frame(maxWidth: .infinity)
                    .background{
                        UnevenRoundedRectangle(cornerRadii: isCurrentUser ? outgoingMessageCornerRadii : incomingMessageCornerRadii)
                            .foregroundStyle(.green)
                    }
            }
        }
        .onAppear {
            Task {
                messageUserName = try await userAppService.getUser(message.userID).name
            }
        }
    }
}

#Preview {
    ChatRow(message: .init(id: "", text: "", image: nil, createdAt: Date(), userID: ""), isCurrentUser: false, userAppService: DefaultUserAppService())
}
