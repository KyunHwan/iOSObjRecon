//
//  RootView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

struct RootView: View {
    //@State private var navigationPath: [AppPage] = [.instruction]
    @StateObject var auth = AuthenticationHelper()
    
    var body: some View {
        ZStack {
            NavigationStack {
                PageNavigationControllerView(page: .authentication)
            }
            .environmentObject(auth)
        }
        .task {
            // TODO: Check for log in
            auth.checkSignedIn()
        }
        .fullScreenCover(isPresented: $auth.signedIn) {
            NavigationStack{
                PageNavigationControllerView(page: .instruction)
            }
            .environmentObject(auth)
        }
    }
}
