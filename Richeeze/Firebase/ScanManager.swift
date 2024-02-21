//
//  ScanManager.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by JunHyuk Yoon on 2/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Scan: Codable, Hashable {
    let scanId: String
    let userId: String
    let projectName: String?
    let scanCreated: Date?
    let thumbnailPath: String?
    let thumbnailPathUrl: String?
    let scanDataPath: String?
    let scanResultPath: String?
}

final class ScanManager {
    
    static let shared = ScanManager()
    private init() { }
    
    private let scanCollection = Firestore.firestore().collection("scans")
    
    private func scanDocument(scanId: String) -> DocumentReference {
        scanCollection.document(scanId)
    }
    
    func uploadScan(scan: Scan) async throws {
        try scanDocument(scanId: String(scan.scanId)).setData(from: scan, merge: false)
    }
    
    func getScan(scanId: String) async throws -> Scan {
        try await scanDocument(scanId: scanId).getDocument(as: Scan.self)
    }
    
    func getAllScans() async throws -> [Scan] {
        try await scanCollection.getDocuments(as: Scan.self) // watch out for charging !
    }
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
    
}
