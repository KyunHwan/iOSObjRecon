//
//  ObjCaptureView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

import SwiftUI

struct ObjCaptureView: View {
    @StateObject var objCaptureViewModel = ObjCaptureViewModel()

    var body: some View {
        ZStack {
            CameraPreviewView(with: objCaptureViewModel)
            VStack {
                Button(action: { objCaptureViewModel.captureFrame() }, label: {
                    Text("Capture!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                })
                .frame(height: 55)
                
                Spacer()
                
                Text("Accel: 0")
            }
        }
        .task {
            objCaptureViewModel.startAutoSession()
        }
        .onDisappear {
            objCaptureViewModel.stopAutoSession()
        }
    }
    
}

#Preview {
    ObjCaptureView()
}
