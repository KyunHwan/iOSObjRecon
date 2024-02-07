//
//  ObjPresentationPlatformModel.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/7/24.
//

import Foundation

/// ObjModelPath, which will be used to fetch object model from a remote storage,
/// should be Identifiable since it will be used inside a ForEach
struct ObjPresentationPlatformModel<ObjModelPath> where ObjModelPath: Identifiable  {
    private(set) var objModelPaths: Array<ObjModelPath>
    
    mutating func addToArray(element: ObjModelPath) {
        objModelPaths.append(element)
    }
    
    mutating private func removeFromArray(element: ObjModelPath) {}
}
