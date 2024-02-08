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
        GeometryReader { geometry in
            let columnGridItems = [GridItem(.flexible())]
            
            NavigationStack {
                ScrollView([.vertical]) {
                    LazyVGrid(columns: columnGridItems, alignment: .center, spacing: 5) {
                        ForEach(viewModel.objInfoList) { objInfo in
                            NavigationLink {
                                ObjContainerView(objInfo: objInfo)
                            } label: {
                                ObjInfoView(objInfo: objInfo)
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Recon Models")
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    ObjPresentationPlatformView()
}
