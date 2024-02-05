//
//  ObjCaptureView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

import SwiftUI

struct ObjCaptureView: View {
    @StateObject var objCaptureViewModel = ObjCaptureViewModel()
    @StateObject var arModelManager = ARModelManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    TopInfoPanelView()
                    
                    Spacer()
                    
                    ZStack {
                        cameraPreviewSection(geometry: geometry)
                        VStack { blurViewWithARSection(geometry: geometry) }
                        VStack { progressBarViewSection(geometry: geometry) }
                    }
                    .clipped()
                    
                    Spacer()
                    
                    captureButtonPanelSection(geometry: geometry)
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
}

// MARK: Capture Button Panel Section
extension ObjCaptureView {
    private func captureButtonPanelSection(geometry: GeometryProxy) -> some View {
        CaptureButtonPanelView(objCaptureViewModel: objCaptureViewModel,
                               arModelManager: arModelManager,
                               width: geometry.size.width)
    }
}

// MARK: Camera Preview Section
extension ObjCaptureView {
    private func cameraPreviewSection(geometry: GeometryProxy) -> some View {
        fitToPage(CameraPreviewView(objCaptureViewModel: objCaptureViewModel),
                  geometry: geometry,
                  aspectRatio: ViewParameter.aspectRatio,
                  alignment: .center,
                  priority: 3.0)
    }
}

// MARK: Progress Bar View Section
extension ObjCaptureView {
    private func progressBar(geometry: GeometryProxy, 
                             location: ProgressBarViewModel.ProgressBarLocation) -> some View {
        ProgressBarView(objCaptureViewModel: objCaptureViewModel, arModelManager: arModelManager,
                        width: geometry.size.width / 2,
                        height: geometry.size.width * (ViewParameter.aspectRatio/4),
                        progressBarLocation: location)
    }
    
    @ViewBuilder
    private func progressBarViewSection(geometry: GeometryProxy) -> some View {
        Spacer(minLength: geometry.size.width * ViewParameter.aspectRatio/4)
        progressBar(geometry: geometry, location: .top)
        Spacer()
        progressBar(geometry: geometry, location: .center)
        Spacer()
        progressBar(geometry: geometry, location: .bottom)
        Spacer(minLength: geometry.size.width * ViewParameter.aspectRatio/4)
    }
}

// MARK: Blur View Section
extension ObjCaptureView {
    private func blurView(geometry: GeometryProxy) -> some View {
        fitToPage(BlurView(),
                  geometry: geometry, aspectRatio: ViewParameter.aspectRatio/4,
                  alignment: .top, priority: 2.0)
    }
    
    @ViewBuilder
    private func blurViewWithARSection(geometry: GeometryProxy) -> some View {
        ZStack {
            blurView(geometry: geometry)
        }
        Spacer()
        ZStack {
            blurView(geometry: geometry)
            fitToPage(ARModelPresentationView(arModelManager: arModelManager, objCaptureViewModel: objCaptureViewModel),
                      geometry: geometry, aspectRatio: ViewParameter.aspectRatio/4, alignment: .bottom, priority: 1.0)
        }
    }
}

// MARK: Helpers
extension ObjCaptureView {
    @ViewBuilder
    private func fitToPage(_ someView: some View, geometry: GeometryProxy, aspectRatio: CGFloat, alignment: Alignment, priority: Double) -> some View {
        someView
            .frame(width: geometry.size.width,
                   height: geometry.size.width * aspectRatio,
                   alignment: alignment)
            .layoutPriority(priority)
    }
    
    private struct ViewParameter {
        static let aspectRatio: CGFloat = 4.0 / 3.0
    }
}

#Preview {
    ObjCaptureView()
}


