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
    
    @FocusState private var focusedField: LoginField?
    
    var body: some View {
        ZStack { GeometryReader { geometry in
            Color(red: 1.0, green: 153.0/255.0, blue: 0.0)
            ScrollView {
                VStack {
                    Spacer()
                    Image("Richeeze")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    TextField("  Email", text: $email)
                        .scenePadding(.leading)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.brown)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .email)
                        
                    
                    SecureField("  Password", text: $password)
                        .scenePadding(.leading)
                        .safeAreaPadding(.leading, 1)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.brown)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .password)
                        
                    
                    emailSignInButton
                    
                    googleSignInButton
                    
                    HStack {
                        Spacer()
                        signUpView
                        Spacer()
                    }
                    
                    Spacer()
                    
                }
                .frame(minHeight: geometry.size.height)
            }
        }
            
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture { 
            focusedField = nil
        }
        .alert(auth.errorMessage, isPresented: $auth.signInErrorPopup) {
            Button("OK", role: .cancel) {
            }
        }
        .onDisappear {
            email = ""
            password = ""
        }
    }
    
    enum LoginField: Hashable {
        case email
        case password
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
