//
//  FireStorageHelper.swift
//  ObjectRecon
//
//  Created by jhyoon on 2/7/24.
//

import Foundation
import FirebaseStorage

class FireStorageHelper {
            
    static func writeFileToFireStorage(to fileUrl: URL, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (String) -> Void) {
        
        let storageRef = Storage.storage().reference()
        
        let spaceRef = storageRef.child(fileUrl.lastPathComponent)
        
        let uploadTask = spaceRef.putFile(from: fileUrl)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let progress = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            progressHandler(progress)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            completionHandler(fileUrl.lastPathComponent)
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
}
