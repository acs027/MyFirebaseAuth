//
//  AuthenticatedView.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 19.11.2024.
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        switch viewModel.authenticationState {
        case .unauthenticated:
            UnauthenticatedView()
                .environmentObject(viewModel)
        case .authenticated:
            ContentView()
                .environmentObject(viewModel)
        case .authenticating:
            ProgressView()
        }
    }
}

#Preview {
    AuthenticatedView()
}
