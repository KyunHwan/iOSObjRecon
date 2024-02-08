//
//  ObjPresentationPlatformViewModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import Foundation

class ObjPresentationPlatformViewModel: ObservableObject {
    private var platformModel: InfoModel
    
    // TODO: Delete after testing
    let mouse: URL
    let rock: URL
    let cup: URL
    //
    
    var objInfoList: Array<InfoModel.ObjInfo> { platformModel.objModelPaths }
    
    init() {
        platformModel = InfoModel()
        // TODO: Delete after testing
        mouse = URL(fileURLWithPath: Bundle.main.path(forResource: "mouse_preview", ofType: "usdz")!)
        rock = URL(fileURLWithPath: Bundle.main.path(forResource: "Rock36_reduced", ofType: "usdz")!)
        cup = URL(fileURLWithPath: Bundle.main.path(forResource: "cup_preview", ofType: "usdz")!)
        //
        updateList()
    }
    
    func addToArray(element: InfoModel.ObjInfo) {
        platformModel.addToArray(element: element)
    }
    
    // TODO: Delete after testing
    private func updateList(){
        addToArray(element: InfoModel.ObjInfo(id: 1, 
                                              filePath: mouse,
                                              name: "mouse"))
        addToArray(element: InfoModel.ObjInfo(id: 2, 
                                              filePath: rock,
                                              name: "rock"))
        addToArray(element: InfoModel.ObjInfo(id: 3,
                                              filePath: cup,
                                              name: "cup"))
    }
    //
}

// MARK: Typealias
extension ObjPresentationPlatformViewModel {
    typealias ObjPathType = URL
    typealias InfoModel = ObjPresentationPlatformModel<ObjPathType>
}
