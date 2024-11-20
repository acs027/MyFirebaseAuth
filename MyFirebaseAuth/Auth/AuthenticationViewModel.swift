//
//  Authentication.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 19.11.2024.
//

import Foundation
//import FirebaseCore
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticated
    case authenticating
}

enum AuthenticationFlow {
    case login
    case signup
}


final class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var  flow: AuthenticationFlow = .login
    
    @Published var isValid = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User?
    
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.email = user?.email ?? ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signup : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        }
        catch { }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

extension AuthenticationViewModel {
    
    func signInWithEmailPassword() async -> Bool {
        DispatchQueue.main.async {
            self.authenticationState = .authenticating
        }
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            return true
        }
        catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.authenticationState = .unauthenticated
            }
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        DispatchQueue.main.async {
            self.authenticationState = .authenticating
        }
        do {
            try await Auth.auth().createUser(withEmail: self.email, password: self.password)
            return true
        }
        catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.authenticationState = .unauthenticated
            }
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            reset()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    enum AuthenticationError: Error {
        case tokenError(message: String)
    }
}
