//
//  ContentView.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 19.11.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onTapGesture {
            viewModel.signOut()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
