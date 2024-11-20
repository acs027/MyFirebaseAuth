//
//  SignUpView.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 19.11.2024.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @FocusState private var focus: FocusableField?
    
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() == true {
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
            confirmPasswordField
            HStack {
                forgotPasswordButton
                Spacer()
            }
            signupButton
            haveAccountButton
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
        .submitLabel(.next)
        .onSubmit {
            self.focus = .confirmPassword
        }
    }
    
    private var confirmPasswordField: some View {
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
        .focused($focus, equals: .confirmPassword)
        .submitLabel(.go)
        .onSubmit {
            signUpWithEmailPassword()
        }
    }
    
    private var forgotPasswordButton: some View {
        Button("Forgot your password?") {
            
        }
    }
    
    private var signupButton: some View {
        Button {
            signUpWithEmailPassword()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 50)
                .overlay {
                    Text("Sign Up")
                        .foregroundStyle(.white)
                }
        }
    }
    
    private var haveAccountButton: some View {
        Button("Do you already have an account ?") {
            viewModel.flow = .login
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
    SignUpView()
        .environmentObject(viewModel)
}
