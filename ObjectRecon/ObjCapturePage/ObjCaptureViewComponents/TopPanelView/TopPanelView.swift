//
//  TopPanelView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import SwiftUI

struct TopPanelView: View {
    @ObservedObject var viewModel: ObjCaptureViewModel
    
    var width: CGFloat
    private var frameWidth: CGFloat { width / 6 }
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                UploadButton(objCaptureViewModel: viewModel)
                    .scaleEffect(2)
                    .frame(width: frameWidth)
                    .padding()
                Spacer()
            }
            HStack {
                Spacer()
                TopInfoPanelView(lensPos: viewModel.lensPos)
                    .padding()
                Spacer()
            }
            HStack {
                Spacer()
                CaptureModeMenu(objCaptureViewModel: viewModel)
                    .scaleEffect(2)
                    .frame(width: frameWidth)
                    .padding()
            }
        }
    }
}

