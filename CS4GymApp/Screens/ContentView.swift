//
//  ContentView.swift
//  CS4GymApp
//
//  Created by Minh Tran  on 8/28/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isSignedIn: Bool = false
    var body: some View {
        Group {
            if isSignedIn {
                MainTabView()
            } else {
                SignInView()
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("didSignIn"))) { _ in
                        isSignedIn = true
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
