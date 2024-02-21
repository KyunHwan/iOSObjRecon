//
//  File.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by JunHyuk Yoon on 2/14/24.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
   
    private func scanReference(userId: String) -> StorageReference {
        storage.child("scans").child(userId)
    }
    
    func getLocalCachePath(fireStoragePath: String) -> URL {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docDirectory.appendingPathComponent(fireStoragePath)
    }
    
    // firebase storage path 값 받아서, 실제 로컬 파일 경로 리턴 (필요하다면 다시 다운로드 받는다.)
    func downloadToCacheFile(fireStoragePath: String) async throws -> URL {
        let localCachePath = getLocalCachePath(fireStoragePath: fireStoragePath)
        
        // 1. doc 폴더에 이미 메시 파일 있는지 확인 (나중에 날짜/시간 체크도 해야한다.)
        if(!FileManager.default.fileExists(atPath: localCachePath.path)) {
                            
            // 2. 없으면, doc 폴더 새로 생성하고 firebase storage 에서 다운로드한다.
            let localCacheDirectory = localCachePath.deletingLastPathComponent().path
            if(!FileManager.default.fileExists(atPath: localCacheDirectory)) {
                try FileManager.default.createDirectory(atPath: localCacheDirectory, withIntermediateDirectories: true)
            }
            
            let downUrl = try await getPath(path: fireStoragePath).writeAsync(toFile: localCachePath)
            print("downUrl = \(downUrl.absoluteString)")
        }
        
        return localCachePath
    }
        
    func getPath(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    func getUrl(path: String) async throws -> URL {
        try await getPath(path: path).downloadURL()
    }
    
    func getData(path: String) async throws -> Data {
        //try await userReference(userId: userId).child(path).data(maxSize: 3 * 1024 * 1024)
        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    func getImage(path: String) async throws -> UIImage {
        let data = try await getData(path: path)
        
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        
        return image
    }
    
}
