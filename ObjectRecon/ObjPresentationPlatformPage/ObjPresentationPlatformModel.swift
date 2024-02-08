//
//  ObjPresentationPlatformModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import Foundation

/// ObjModelPath, which will be used to fetch object model from a remote storage,
/// should be Identifiable since it will be used inside a ForEach
struct ObjPresentationPlatformModel<ObjModelPath>  {
    private(set) var objModelPaths: Array<ObjInfo>
    
    init() {
        objModelPaths = Array<ObjInfo>()
    }
    
    mutating func addToArray(element: ObjInfo) {
        objModelPaths.append(element)
    }
    
    mutating func removeFromArray(element: ObjInfo) {}
    
    /// Where the path to the reconstructed model will be stored
    struct ObjInfo: Identifiable {
        let id: Int
        let filePath: ObjModelPath
        let name: String
    }
}
