//
//  AuthenticationView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/14/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct AuthenticationView: View {
    @EnvironmentObject var auth: AuthenticationHelper
    let page: AppPage
    
    @State private var email: String = ""
    @State private var password: String = ""
    
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
                
                emailSignInButton
                
                googleSignInButton
                
                HStack {
                    Spacer()
                    signUpView
                    Spacer()
                }
                
                Spacer()
                
            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture { }
        .alert(auth.errorMessage, isPresented: $auth.signInErrorPopup) {
            Button("OK", role: .cancel) {
            }
        }
    }
}

// MARK: Email Authentication Button Layout
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
            .padding(.horizontal)
    }
    
    private var emailSignUpText: some View { Text("Join now") }
    
    private var emailSignInButton: some View { 
        Button {
            Task {
                try await auth.signInEmail(withEmail: email, password: password)
            }
        } label: {
            emailSignInButtonLayout
        }
    }
    
    @ViewBuilder
    private var signUpView: some View {
        Text("New to Richeeze? ")
            .font(.headline)
            .foregroundStyle(.black)
        NavigationLink {
            EmailSignUpView()
        } label: {
            emailSignUpText
        }
    }
}

// MARK: Google Authentication Button Layout
extension AuthenticationView {
    private var googleSignInText: some View { Text(Image("google")) + Text("  Sign in with Google") }
    private var googleSignInButtonLayout: some View {
        googleSignInText
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.white)
            .foregroundStyle(.black)
            .cornerRadius(10)
            .padding(.horizontal)
    }
    
    private var googleSignInButton: some View {
        Button {
            Task {
                do {
                    try await auth.signInGoogle()
                } catch {
                    print(error)
                }
            }
        } label: {
            googleSignInButtonLayout
        }
    }
}
