//
//  EmailAuthenticationView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/14/24.
//

import SwiftUI

struct EmailSignUpView: View {
    @EnvironmentObject var auth: AuthenticationHelper
    
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 153.0/255.0, blue: 0.0)
            VStack {
                Spacer()
                Image("Richeeze")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                TextField("  Email", text: $email)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                SecureField("  Password", text: $password)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                SecureField("  Confirm Password", text: $passwordConfirm)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button {
                    Task {
                        try await auth.signUpEmail(withEmail: email, password: password, confirmPasswordWith: passwordConfirm)
                        if !auth.signUpErrorPopup { dismiss() }
                    }
                } label: {
                    emailSignUpButtonLayout
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {  }
        .alert(auth.errorMessage, isPresented: $auth.signUpErrorPopup) {
            Button("OK", role: .cancel) {
            }
        }
    }
}


extension EmailSignUpView {
    private var emailSignUpText: some View { Text(Image(systemName: "envelope.fill")) + Text("  Sign up with email") }
    private var emailSignUpButtonLayout: some View {
        emailSignUpText
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.red)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
