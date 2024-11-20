//
//  LoginView.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 19.11.2024.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
}

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @FocusState private var focus: FocusableField?
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                viewModel.authenticationState = .authenticated
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.largeTitle)
            emailField
            passwordField
            HStack {
                forgotPasswordButton
                Spacer()
            }
            loginButton
            createAccountButton
            errorMessage
        }
        .padding()
    }
    
    private var emailField: some View {
        CustomTextField(placeholder: "Email", text: $viewModel.email)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($focus, equals: .email)
            .submitLabel(.next)
            .onSubmit {
                self.focus = .password
            }
    }
    
    @State var revealPassword: Bool = false
    private var passwordField: some View {
        ZStack(alignment: .trailing) {
            if revealPassword {
                CustomTextField(placeholder: "Password", text: $viewModel.password)
            } else {
                CustomSecureField(placeholder: "Password", text: $viewModel.password)
            }
            Button {
                revealPassword.toggle()
            } label: {
                revealPassword ? Image(systemName: "eye.slash") : Image(systemName: "eye")
            }
            .foregroundStyle(.gray)
            .padding()
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused($focus, equals: .password)
        .submitLabel(.go)
        .onSubmit {
            signInWithEmailPassword()
        }
    }
    
    private var forgotPasswordButton: some View {
        Button("Forgot your password?") {
            
        }
    }
    
    private var createAccountButton: some View {
        Button("Create an account") {
            viewModel.flow = .signup
        }
    }
    
    private var loginButton: some View {
        Button {
            signInWithEmailPassword()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 50)
                .overlay {
                    Text("Login")
                        .foregroundStyle(.white)
                }
        }
    }
    
    @ViewBuilder
    private var errorMessage: some View {
        if !viewModel.errorMessage.isEmpty {
            Text(viewModel.errorMessage)
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = AuthenticationViewModel()
    LoginView()
        .environmentObject(viewModel)
}
