//
//  ContentView.swift
//  GPT4AllClient
//
//  Created by Wontai Ki on 10/29/25.
//

import SwiftUI

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
                            Text(choice.message.content)
                                .id(choice.id)
                        }
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
