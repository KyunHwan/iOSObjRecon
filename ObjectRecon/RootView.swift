//
//  RootView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

struct RootView: View {
    //@State private var navigationPath: [AppPage] = []
    
    var body: some View {
        NavigationStack() {//path: $navigationPath) {
            PageNavigationControllerView(page: .instruction)
        }
        
    }
}
