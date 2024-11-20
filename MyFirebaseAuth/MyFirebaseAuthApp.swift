//
//  MyFirebaseAuthApp.swift
//  MyFirebaseAuth
//
//  Created by ali cihan on 19.11.2024.
//

import SwiftUI

@main
struct MyFirebaseAuthApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AuthenticatedView()
            }
        }
    }
}
