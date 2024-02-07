//
//  ObjPresentationPlatformView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import SwiftUI

struct ObjPresentationPlatformView: View {
    @StateObject private var viewModel = ObjPresentationPlatformViewModel()
    
    var body: some View {
        GeometryReader { geoemtry in
            let columnGridItems = [GridItem(.flexible()), GridItem(.flexible())]
            
            ScrollView([.vertical]) {
                LazyVGrid(columns: columnGridItems, alignment: .center) {
                    ForEach(viewModel.objModelPaths) { path in
                        ObjContainerView(objModelPath: path)
                    }
                }
            }
        }
    }
}

#Preview {
    ObjPresentationPlatformView()
}
