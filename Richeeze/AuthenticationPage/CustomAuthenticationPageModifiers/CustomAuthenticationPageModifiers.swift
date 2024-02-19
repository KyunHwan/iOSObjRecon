//
//  CustomAuthenticationPageModifiers.swift
//  Richeeze
//
//  Created by Kyun Hwan  Kim on 2/19/24.
//

import SwiftUI

// MARK: Custom Button Modifier
struct DefaultButtonModifier: ViewModifier {
    var backgroundColor: Color
    var fontColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(backgroundColor)
            .foregroundStyle(fontColor)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

extension View {
    func withDefaultButtonFormat(backgroundColor: Color, fontColor: Color) -> some View {
        modifier(DefaultButtonModifier(backgroundColor: backgroundColor, fontColor: fontColor))
    }
}


// MARK: Custom TextField Modifier
struct DefaultTextFieldModifier<FocusField>: ViewModifier where FocusField: Hashable {
    var backgroundColor: Color
    var fontColor: Color
    var focusField: FocusField
    var focusedField: FocusState<FocusField?>.Binding
    
    
    func body(content: Content) -> some View {
        content
            .scenePadding(.leading)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(backgroundColor)
            .foregroundStyle(fontColor)
            .cornerRadius(10)
            .padding(.horizontal)
            .focused(focusedField, equals: focusField)
    }
}
extension View  {
    func withDefaultTextFieldFormat<FocusField>(backgroundColor: Color,
                                                fontColor: Color,
                                                focusField: FocusField,
                                                focusedField: FocusState<FocusField?>.Binding) -> some View {
        modifier(DefaultTextFieldModifier(backgroundColor: backgroundColor,
                                          fontColor: fontColor,
                                          focusField: focusField,
                                          focusedField: focusedField))
    }
}
