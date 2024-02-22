//
//  GoToModelPlatformButton.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

struct GoToModelPlatformButton: View {
    
    var body: some View {
        VStack {
            NavigationLink(value: AppPage.reconPresentation) {
                Text("Gallery ") + Text(Image(systemName: "chevron.forward"))
            }
        }
    }
}
