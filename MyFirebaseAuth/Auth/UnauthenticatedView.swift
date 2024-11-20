//
//  UnauthenticatedView.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 19.11.2024.
//

import SwiftUI

struct UnauthenticatedView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    var body: some View {
        switch viewModel.flow {
        case .login:
            LoginView()
        case .signup:
            SignUpView()
        }
    }
}

#Preview {
    UnauthenticatedView()
}
