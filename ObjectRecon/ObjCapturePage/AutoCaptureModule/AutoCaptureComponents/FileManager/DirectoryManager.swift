//
//  DirectoryManager.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

/*
 Keeps track of information 
 */

import Foundation

class DirectoryManager {
    @Published var numPhotos: UInt32
    var dirPath: URL?
    let filePrefix: String
    let fileSuffix: String
    var nextImagePath: URL? { dirPath?.appendingPathComponent(String(format: "%@%04d", filePrefix, numPhotos).appending(fileSuffix)) }
    
    init(filePrefixInDirectory: String = "IMG_",
         fileSuffixInDirectory: String = ".JPG") {
        filePrefix = filePrefixInDirectory
        fileSuffix = fileSuffixInDirectory
        numPhotos = 0
        dirPath = nil
    }

    /// This should be done atomically
    static func createFile(at imageURL: URL?, contents data: Data?) {
        if let imageURL = imageURL, let data = data {
            do {
                try data.write(to: URL(fileURLWithPath: imageURL.path), options: .atomic)
            }
            catch { print("Couldn't write image data to file") }
        }
        else { print("Image path (or data) was nil") }
    }
    
    static func createNewDirectory() -> URL? {
        if let appCapturesFolder = DirectoryManager.appCapturesFolder() {
            let directoryPath = appCapturesFolder.appendingPathComponent(DirectoryManager.returnTimeStamp(), isDirectory: true)
            do {
                try FileManager.default.createDirectory(atPath: directoryPath.path, withIntermediateDirectories: true)
                return directoryPath
            } catch {
                print("Error \(error.localizedDescription) occurred")
                fatalError("Image directory could not be created")
            }
        } else {
            return nil
        }
    }
    
    func checkCreateNewDirectory() {
        if let _ = self.dirPath { return }
        else { self.createNewDirectory() }
    }
    
    func createNewDirectory() {
        numPhotos = 0
        dirPath = DirectoryManager.createNewDirectory()
    }
    
    @MainActor
    func incrementNumPhotos() { numPhotos += 1 }
}

// MARK: Function Helpers
extension DirectoryManager {
    /// The method returns a URL to the app's documents folder, where it stores all captures.
    private static func appCapturesFolder() -> URL? {
        guard let documentsFolder = try? FileManager.default.url(for: .documentDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil, create: false)
        else {
            fatalError("App's default folder could not be located")
        }
        return documentsFolder.appendingPathComponent("ObjReconCaptures/", isDirectory: true)
    }
    
    private static func returnTimeStamp() -> String {
        var timestamp = ""
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy_MMdd_"
        timestamp += dateFormat.string(from: Date())
        timestamp += String(Int64(Date().timeIntervalSince1970))
        return timestamp
    }
}
