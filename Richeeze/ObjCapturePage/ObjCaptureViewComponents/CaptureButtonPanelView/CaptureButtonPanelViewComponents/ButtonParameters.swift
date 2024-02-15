//
//  ButtonViewParameters.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/5/24.
//

import Foundation

struct ButtonParameters {
    static let outerDiameter: CGFloat = 80
    static let strokeWidth: CGFloat = 4
    static let innerPadding: CGFloat = 10
    static let rootTwoOverTwo: CGFloat = CGFloat(2.0.squareRoot() / 2.0)
    static let buttonBackingOpacity: Double = 0.15
    static let innerDiameter: CGFloat = ButtonParameters.outerDiameter - ButtonParameters.strokeWidth - ButtonParameters.innerPadding
    static let squareDiameter: CGFloat = ButtonParameters.innerDiameter * ButtonParameters.rootTwoOverTwo - ButtonParameters.innerPadding
    static let toggleDiameter = ButtonParameters.outerDiameter / 3.0
    static let backingDiameter = ButtonParameters.toggleDiameter * 2.0
}
