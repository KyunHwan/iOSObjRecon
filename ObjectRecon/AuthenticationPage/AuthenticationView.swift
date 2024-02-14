//
//  AuthenticationView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/14/24.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var auth: AuthenticationHelper
    let page: AppPage
    
    @State private var email: String = ""
    @State private var password: String = ""
    
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
            
            Button {
                Task {
                    try await auth.signIn(withEmail: email, password: password)
                }
            } label: {
                emailSignInButtonLayout
            }
            
            HStack {
                Spacer()
                Text("New to Juvee? ")
                NavigationLink {
                    EmailAuthenticationView()
                } label: {
                    emailSignUpText
                }
                Spacer()
            }
            
            Spacer()
            
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture { }
        .alert(auth.errorMessage, isPresented: $auth.signInErrorPopup) {
            Button("OK", role: .cancel) {
            }
        }
    }
}

// Email Authentication Button Layout
extension AuthenticationView {
    private var emailSignInText: some View { Text(Image(systemName: "envelope.fill")) + Text("  Sign in with email") }
    private var emailSignInButtonLayout: some View {
        emailSignInText
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.red)
            .foregroundStyle(.white)
            .cornerRadius(10)
    }
    
    private var emailSignUpText: some View { Text("Join now") }
}
