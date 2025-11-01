//
//  ContentView.swift
//  GPT4AllClient
//
//  Created by Wontai Ki on 10/29/25.
//

import SwiftUI

enum Constants {
    static let singleSpace: CGFloat = 8
    static let doubleSpace: CGFloat = 16
}

struct ChatView: View {
    @State var viewModel: ChatViewModel
    @State private var text: String = ""
    @State private var scrollToID: String? = nil
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                VStack {
                    if !viewModel.choices.isEmpty {
                        List(viewModel.choices) { choice in
                            HStack {
                                let isUser = choice.message.role == "user"
                                if isUser {
                                    Spacer()
                                }
                                Text(choice.message.content)
                                    .id(choice.id)
                                    .containerRelativeFrame(.horizontal) { length, _ in
                                        length * 0.7
                                    }
                                    .padding()
                                    .background(
                                        isUser ?
                                        Image("chat_bg_right").resizable(
                                            capInsets: EdgeInsets(
                                                top: Constants.doubleSpace,
                                                leading: Constants.doubleSpace,
                                                bottom: Constants.doubleSpace,
                                                trailing: Constants.doubleSpace
                                            ),
                                            resizingMode: .stretch
                                        ) :
                                        Image("chat_bg_left").resizable(
                                            capInsets: EdgeInsets(
                                                top: Constants.doubleSpace,
                                                leading: Constants.doubleSpace,
                                                bottom: Constants.doubleSpace,
                                                trailing: Constants.doubleSpace
                                            ),
                                            resizingMode: .stretch
                                        )
                                    )
                                if !isUser {
                                    Spacer()
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .onChange(of: viewModel.choices.count) { _, _ in
                            if let lastID = viewModel.choices.last?.id {
                                withAnimation {
                                    proxy.scrollTo(lastID, anchor: .bottom)
                                }
                            }
                        }
                    } else {
                        Spacer()
                    }
                    TextField("Ask something", text: $text) {
                        viewModel.chat(input: text)
                        text = "" // TODO: textfield is not cleared :(
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
                .navigationTitle(Text(viewModel.selectedModel?.id ?? ""))
            }
        }
        .task {
            viewModel.getModels()
        }
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}
