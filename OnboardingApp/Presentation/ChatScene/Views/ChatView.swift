//
//  ChatView.swift
//  OnboardingApp
//
//  Created by Shotaro Doi on 2024/03/27.
//

import SwiftUI

struct ChatView: View {
    @State var input = ""
    @ObservedObject var viewModel: ChatViewModel
    

    var body: some View {
        VStack {
            ScrollViewReader { value in
                List(viewModel.messages,
                     id: \.id) { message in
                        ChatRow(message: message,
                                isCurrentUser: viewModel.currentUser?.userID == message.userID,
                                userAppService: viewModel.userAppService)
                        .listRowSeparator(.hidden)
                        .id(message.id)
                }
                     .frame(maxWidth: .infinity)
                     .scrollContentBackground(.hidden)
                     .listStyle(PlainListStyle())
                     .onChange(of: viewModel.messages.count) { _ in
                         value.scrollTo(viewModel.messages.last?.id)
                     }
            }
            HStack(spacing: 10, content: {
                TextField("input text",
                          text: $input)
                .textFieldStyle(.roundedBorder)
                Button {
                    viewModel.sendMessage(withText: input)
                    input = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .tint(.black)
                }
            })
            .padding()
            .background(Color(UIColor.yellow))
        }
        .alert("Error",
               isPresented: $viewModel.isError) {
            Button("OK") {
                viewModel.onDismissError()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
