//
//  UploadButton.swift
//  ObjectRecon
//
//  Created by jhyoon on 2/7/24.
//

import SwiftUI

struct UploadButton: View {
    @ObservedObject var objCaptureViewModel: ObjCaptureViewModel
    
    var body: some View {
        Button(action: {
            objCaptureViewModel.uploadButtonPressed()
        }, label: {
            Label("Record", systemImage: objCaptureViewModel.isUploading ? "square.and.arrow.up.fill" : "square.and.arrow.up")
                .labelStyle(.iconOnly)
                .foregroundColor(objCaptureViewModel.isUploading ? .red : .yellow)
        })
    }
}
