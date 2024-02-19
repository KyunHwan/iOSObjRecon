//
//  ObjCaptureView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/24/24.
//

import SwiftUI

struct ObjCaptureView: View {
    @StateObject private var viewModel = ObjCaptureViewModel()
    @StateObject private var arModelManager = ARModelManager()
    var page: AppPage
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                /*
                background
                    .background(viewModel.captureConditionsMet(
                        lensPos: viewModel.lensPos,
                        accelMag: viewModel.accelMag,
                        box: viewModel.detectionBox,
                        confidence: viewModel.detectionConfidence) ?
                                Color(uiColor: backgroundColor(with: 1)) :
                                    Color(uiColor: backgroundColor(with: 0)))
                    .opacity(0.65)
                 */
                Color(red: 1.0, green: 153.0/255.0, blue: 0.0).edgesIgnoringSafeArea(.all)
                VStack {
                    TopPanelView(viewModel: viewModel, 
                                 page: page,
                                 width: geometry.size.width)
                    
                    Spacer()
                    
                    ZStack {
                        cameraPreviewSection(geometry: geometry)
                        blurViewWithARSection(geometry: geometry)
                        captureProgressBarViewSection(geometry: geometry)
                    }
                    .clipped()
                    
                    Spacer()
                    
                    captureButtonPanelSection(geometry: geometry)
                }
                
                if viewModel.isUploading { uploadProgressViewSection() }
            }
            .sensoryFeedback(.impact(flexibility: .rigid, intensity: 1.0), trigger: viewModel.numPhotosTaken)
            .task {
                viewModel.startAutoSession()
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                viewModel.stopAutoSession()
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }

}

// MARK: Upload Progress View
extension ObjCaptureView {
    @ViewBuilder
    private func uploadProgressViewSection() -> some View {
        ZStack {
            UploadProgressCircleView(progress: viewModel.uploadProgress)
            Text("\(viewModel.uploadProgress * 100, specifier: "%.0f")")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 200)
        
    }
}

// MARK: View Color Modifier
extension ObjCaptureView {
    private var background: some View {
        Color.init(UIColor(red: 255.0/255.0, green: 15.0/255.0, blue: 133.0/255.0, alpha: 0.0)).edgesIgnoringSafeArea(.all)
    }
    
    private func backgroundColor(with val: CGFloat) -> UIColor {
        UIColor(hue: val / 3,
                saturation: 1.0,
                brightness: 1.0,
                alpha: 1.0)
    }
}

// MARK: Capture Button Panel Section
extension ObjCaptureView {
    private func captureButtonPanelSection(geometry: GeometryProxy) -> some View {
        CaptureButtonPanelView(objCaptureViewModel: viewModel,
                               arModelManager: arModelManager,
                               width: geometry.size.width)
    }
}

// MARK: Camera Preview Section
extension ObjCaptureView {
    private func cameraPreviewSection(geometry: GeometryProxy) -> some View {
        fitToPage(CameraPreviewView(objCaptureViewModel: viewModel),
                  geometry: geometry,
                  aspectRatio: ViewParameter.aspectRatio,
                  alignment: .center,
                  priority: 3.0)
    }
}

// MARK: Progress Bar View Section
extension ObjCaptureView {
    private func captureProgressBar(geometry: GeometryProxy,
                             location: CaptureProgressBarViewModel.ProgressBarLocation) -> some View {
        CaptureProgressBarView(objCaptureViewModel: viewModel, arModelManager: arModelManager,
                        width: geometry.size.width / 2,
                        height: geometry.size.width * (ViewParameter.aspectRatio/4),
                        progressBarLocation: location)
    }
    
    @ViewBuilder
    private func captureProgressBarViewSection(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer(minLength: geometry.size.width * ViewParameter.aspectRatio/4)
            captureProgressBar(geometry: geometry, location: .top)
            Spacer()
            captureProgressBar(geometry: geometry, location: .bottom)
            Spacer(minLength: geometry.size.width * ViewParameter.aspectRatio/4)
        }
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
    private func captureConditionIndicator() -> some View {
        VStack {
            Spacer()
            Text("Camera too far")
                .foregroundStyle(.red)
                .opacity(viewModel.lensPosConditionMet(for: viewModel.lensPos) ? 0 : 1)
            Text("Moving too fast")
                .foregroundStyle(.red)
                .opacity(viewModel.accelMagConditionMet(for: viewModel.accelMag) ? 0 : 1)
            Text("Object not detected")
                .foregroundStyle(.red)
                .opacity(viewModel.detectionConditionsMet(box: viewModel.detectionBox, confidence: viewModel.detectionConfidence) ? 0 : 1)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func blurViewWithARSection(geometry: GeometryProxy) -> some View {
        VStack {
            ZStack {
                blurView(geometry: geometry)
                Text(viewModel.capturing ? "Capturing" : "Ready to Capture")
                    .foregroundColor(viewModel.capturing ? .red : .green)
            }
            Spacer()
            ZStack {
                blurView(geometry: geometry)
                fitToPage(ARModelPresentationView(arModelManager: arModelManager, objCaptureViewModel: viewModel),
                          geometry: geometry, aspectRatio: ViewParameter.aspectRatio/4, alignment: .bottom, priority: 1.0)
            }
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
