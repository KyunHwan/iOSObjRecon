//
//  ObjPresentationPlatformViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import Foundation

class ObjPresentationPlatformViewModel: ObservableObject {
    private var platformModel: ObjPresentationPlatformModel<URL>
    init() {
        platformModel = ObjPresentationPlatformModel()
    }
}
