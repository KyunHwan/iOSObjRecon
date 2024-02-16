//
//  TopPanelView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import SwiftUI

struct TopPanelView: View {
    @ObservedObject var viewModel: ObjCaptureViewModel
    //@Binding var path: [AppPage]
    var page: AppPage
    
    var width: CGFloat
    private var frameWidth: CGFloat { width / 6 }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                Spacer()
                HStack {
                    UploadButton(objCaptureViewModel: viewModel)
                        .scaleEffect(1.5)
                        .frame(width: frameWidth)
                        .padding(.horizontal)
                    Spacer()
                    CaptureModeMenu(objCaptureViewModel: viewModel)
                        .scaleEffect(1.5)
                        .frame(width: frameWidth)
                        .padding(.horizontal)
                }
            }
            HStack {
                Spacer()
                VStack {
                    TopInfoPanelView()
                    Spacer()
                }
                Spacer()
            }
        }
        .toolbar {
            GoToModelPlatformButton(page: page)
        }
    }
}

