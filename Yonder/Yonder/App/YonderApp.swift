//
//  YonderApp.swift
//  Yonder
//
//  Created by Felix Wong on 2023-05-30.
//

import SwiftUI
import Firebase

@main
struct YonderApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

