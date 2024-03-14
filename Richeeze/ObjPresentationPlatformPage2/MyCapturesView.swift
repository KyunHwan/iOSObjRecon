//
//  ReconResultsView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by JunHyuk Yoon on 2/15/24.
//

import SwiftUI

@MainActor
final class MyCapturesViewModel: ObservableObject {
    
    @Published private(set) var scans: [Scan] = []
            
    func getAllScans() async throws {
        self.scans = try await ScanManager.shared.getAllScans()
        print("scans.count = \(scans.count)")
    }
}

struct MyCapturesView: View {
    @StateObject private var viewModel = MyCapturesViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
     
    var body: some View {
        ZStack {
            Color("CheezeColor").edgesIgnoringSafeArea(.all)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.scans.sorted(by: { lhs, rhs in
                        lhs.scanId > rhs.scanId
                    }), id: \.self) { scan in
                        if let thumbUrl = scan.thumbnailPathUrl {
                            NavigationLink(value: scan) {
                                MyCapturesCellView(thumbnailPath: thumbUrl)
                            }
                        }
                    }
                }
                .padding(10) // !!!!!
            }
            .navigationTitle("Captures")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gear")
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                try? await viewModel.getAllScans()
            }
        }
    }

}

#Preview {
    NavigationStack {
        MyCapturesView()
    }
}
