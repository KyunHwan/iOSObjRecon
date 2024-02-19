//
//  ProgressCircleView.swift
//  ObjectRecon
//
//  Created by jhyoon on 2/7/24.
//

import SwiftUI

struct UploadProgressCircleView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Constants.circleColor.opacity(Constants.opacity),
                    lineWidth: Constants.lineWidth
                )
            Circle()
                .trim(from: Constants.trimStart, to: progress)
                .stroke(
                    Constants.circleColor,
                    style: StrokeStyle(
                        lineWidth: Constants.lineWidth,
                        lineCap: Constants.lineCap
                    )
                )
                .rotationEffect(Constants.angle)
                // 1
                .animation(Constants.animationStyle, value: progress)

        }
    }
}

extension UploadProgressCircleView {
    struct Constants {
        static let circleColor: Color = Color.pink
        static let opacity: Double = 0.5
        static let lineWidth: CGFloat = 30
        static let trimStart: CGFloat = 0.0
        static let lineCap: CGLineCap = .round
        static let angle: Angle = .degrees(-90)
        static let animationStyle: Animation = .easeOut
    }
}

#Preview {
    UploadProgressCircleView(progress: 0.5)
}
