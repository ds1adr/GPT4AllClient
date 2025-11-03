//
//  SettingsView.swift
//  GPT4AllClient
//
//  Created by Wontai Ki on 11/2/25.
//

import SwiftUI

struct SettingsView: View {
    @State var viewModel: ChatViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(viewModel.models) { model in
                HStack {
                    Text(model.id)
                    Spacer()
                    if model.id == viewModel.selectedModel?.id {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }

            }
        }
    }
}

#Preview {
    SettingsView(viewModel: ChatViewModel())
}

