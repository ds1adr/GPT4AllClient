//
//  ContentView.swift
//  GPT4AllClient
//
//  Created by Wontai Ki on 10/29/25.
//

import SwiftUI

struct ChatView: View {
    @State var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            viewModel.getModels()
        }
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}
