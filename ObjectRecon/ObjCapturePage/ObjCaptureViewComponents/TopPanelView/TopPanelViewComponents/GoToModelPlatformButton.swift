//
//  GoToModelPlatformButton.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

struct GoToModelPlatformButton: View {
    var page: AppPage
    var body: some View {
        VStack {
            NavigationLink {
                PageNavigationControllerView(page: PageNavigationControllerView.pageTransition(from: page))//path: $path, page: .reconPresentation)
            } label: {
                Text("View 3D Models")
            }
        }
    }
}
