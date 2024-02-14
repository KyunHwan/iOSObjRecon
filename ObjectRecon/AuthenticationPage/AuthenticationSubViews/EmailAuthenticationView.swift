//
//  EmailAuthenticationView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/14/24.
//

import SwiftUI

struct EmailAuthenticationView: View {
    @EnvironmentObject var auth: AuthenticationHelper
    
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            TextField("  Email", text: $email)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.gray)
                .foregroundStyle(.white)
                .cornerRadius(10)
            
            SecureField("  Password", text: $password)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.gray)
                .foregroundStyle(.white)
                .cornerRadius(10)
            
            SecureField("  Confirm Password", text: $passwordConfirm)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.gray)
                .foregroundStyle(.white)
                .cornerRadius(10)
            
            Button {
                Task {
                    try await auth.signUp(withEmail: email, password: password, confirmPasswordWith: passwordConfirm)
                    if !auth.signUpErrorPopup { dismiss() }
                }
            } label: {
                emailSignUpButtonLayout
            }
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {  }
        .alert(auth.errorMessage, isPresented: $auth.signUpErrorPopup) {
            Button("OK", role: .cancel) {
            }
        }
    }
}


extension EmailAuthenticationView {
    private var emailSignUpText: some View { Text(Image(systemName: "envelope.fill")) + Text("  Sign up with email") }
    private var emailSignUpButtonLayout: some View {
        emailSignUpText
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.red)
            .foregroundStyle(.white)
            .cornerRadius(10)
    }
}
