//
//  ObjInfoView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/8/24.
//

import SwiftUI

struct ObjInfoView: View {
    let objInfo: ObjDataModel<ObjPathDataType>.ObjInfo
    
    var body: some View {
        
        Text("\(objInfo.name)")
            .frame(maxWidth: ObjInfoViewConstants.infoWindowMaxWidth)
            .frame(height: ObjInfoViewConstants.infoWindowHeight)
            .background(ObjInfoViewConstants.backgroundColor)
            .foregroundStyle(ObjInfoViewConstants.fontColor)
            .cornerRadius(ObjInfoViewConstants.cornerRadius)
            .padding(ObjInfoViewConstants.paddingDir)
    }
}

// MARK: Constants {
extension ObjInfoView {
    private struct ObjInfoViewConstants {
        static let infoWindowMaxWidth: CGFloat = .infinity
        static let infoWindowHeight: CGFloat = 55
        static let backgroundColor: Color = .white
        static let fontColor: Color = .black
        static let cornerRadius: CGFloat = 5
        static let paddingDir: Edge.Set = [.horizontal]
    }
}

// MARK: Typealias
extension ObjInfoView {
    typealias ObjPathDataType = ObjPresentationPlatformViewModel.ObjPathType
    typealias ObjDataModel = ObjPresentationPlatformModel
}
