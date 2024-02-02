//
//  CaptureButtonView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/2/24.
//

import SwiftUI

struct CaptureButtonView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/// This capture button view is modeled after the Camera app button. The view changes shape when the
/// user starts shooting in automatic mode.
struct CaptureButton: View {
    static let outerDiameter: CGFloat = 80
    static let strokeWidth: CGFloat = 4
    static let innerPadding: CGFloat = 10
    static let innerDiameter: CGFloat = CaptureButton.outerDiameter -
        CaptureButton.strokeWidth - CaptureButton.innerPadding
    static let rootTwoOverTwo: CGFloat = CGFloat(2.0.squareRoot() / 2.0)
    static let squareDiameter: CGFloat = CaptureButton.innerDiameter * CaptureButton.rootTwoOverTwo -
        CaptureButton.innerPadding
    
    @EnvironmentObject var objCaptureViewModel: ObjCaptureViewModel
    var body: some View {
        Button(action: {
            model.captureButtonPressed()
            model.deviceState.resetInitialOrientation()
            model.shouldAnimate.toggle()
        }, label: {
            if model.isAutoCaptureActive {
                AutoCaptureButtonView(model: model)
            } else {
                ManualCaptureButtonView()
            }
        }).disabled(!model.isCameraAvailable || !model.readyToCapture)
    }
}

/// This is a helper view for the `CaptureButton`. It implements the shape for automatic capture mode.
struct AutoCaptureButtonView: View {
    @ObservedObject var model: CameraViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.yellow)
                .frame(width: CaptureButton.squareDiameter,
                       height: CaptureButton.squareDiameter,
                       alignment: .center)
                .cornerRadius(5)
            if !CameraViewModel.autoGuideOn {
                TimerView(model: model, diameter: CaptureButton.outerDiameter)
            }
        }
    }
}

/// This view displays a darkened circle that fills with a brighter arc based on the time remaining on a `Timer`.
struct TimerView: View {
    @ObservedObject var model: CameraViewModel

    private let fillColor: Color = Color.clear
    private let unprogressedColor: Color = Color(red: 0.5, green: 0.5, blue: 0.5)
    private let progressedColor: Color = .white

    private var timerDiameter: CGFloat = 50
    private var timerBarWidth: CGFloat = 5

    init(model: CameraViewModel, diameter: CGFloat = 50, barWidth: CGFloat = 5) {
        self.model = model
        self.timerDiameter = diameter
        self.timerBarWidth = barWidth
    }

    var body: some View {
        ZStack {

            Circle()
                .fill(fillColor)
                .frame(width: timerDiameter, height: timerDiameter)
                .overlay(
                    Circle().stroke(unprogressedColor, lineWidth: timerBarWidth)
                )
            Circle()
                .fill(Color.clear)
                .frame(width: timerDiameter, height: timerDiameter)
                .overlay(
                    Circle()
                        .trim(from: 0,
                              to: CGFloat(1.0 -
                                            (model.timeUntilCaptureSecs / model.autoCaptureIntervalSecs)))
                        .stroke(style: StrokeStyle(lineWidth: timerBarWidth,
                                                   lineCap: .round,
                                                   lineJoin: .round))
                        .foregroundColor(progressedColor))
        }
    }
}


#Preview {
    CaptureButtonView()
}
