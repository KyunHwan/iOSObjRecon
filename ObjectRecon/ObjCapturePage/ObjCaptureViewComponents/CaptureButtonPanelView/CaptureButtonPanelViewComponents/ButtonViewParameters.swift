//
//  ButtonViewParameters.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/5/24.
//

import Foundation

struct ButtonViewParameters {
    static let outerDiameter: CGFloat = 80
    static let strokeWidth: CGFloat = 4
    static let innerPadding: CGFloat = 10
    static let rootTwoOverTwo: CGFloat = CGFloat(2.0.squareRoot() / 2.0)
    static let buttonBackingOpacity: Double = 0.15
    static let innerDiameter: CGFloat = ButtonViewParameters.outerDiameter - ButtonViewParameters.strokeWidth - ButtonViewParameters.innerPadding
    static let squareDiameter: CGFloat = ButtonViewParameters.innerDiameter * ButtonViewParameters.rootTwoOverTwo - ButtonViewParameters.innerPadding
    static let toggleDiameter = ButtonViewParameters.outerDiameter / 3.0
    static let backingDiameter = ButtonViewParameters.toggleDiameter * 2.0
}
