//
//  ObjPresentationCardView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import SwiftUI

struct ObjContainerView: View {
    let objInfo: ObjDataModel<ObjPathDataType>.ObjInfo
    
    var body: some View {
        ObjARModelView(modelPath: objInfo.filePath)
            .background(ObjContainerViewConstants.arModelViewWindowBackground)
            .cornerRadius(ObjContainerViewConstants.cornerRadius)
            .padding()
    }
}

// MARK: Constants
extension ObjContainerView {
    private struct ObjContainerViewConstants {
        static let arModelViewWindowBackground: Color = .white
        static let cornerRadius: CGFloat = 10
    }
}

// MARK: Typealias
extension ObjContainerView {
    typealias ObjPathDataType = ObjPresentationPlatformViewModel.ObjPathType
    typealias ObjDataModel = ObjPresentationPlatformModel
}
