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
    @FocusState private var focusedField: SignUpField?
    
    var body: some View {
        ZStack { GeometryReader { geometry in
            Color(red: 1.0, green: 153.0/255.0, blue: 0.0).edgesIgnoringSafeArea(.all)
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
                    
                    SecureField("  Confirm Password", text: $passwordConfirm)
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
                        .focused($focusedField, equals: .confirmPassword)
                    
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
                .frame(minHeight: geometry.size.height)
            }
        }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture { focusedField = nil }
        .alert(auth.errorMessage, isPresented: $auth.signUpErrorPopup) {
            Button("OK", role: .cancel) {
            }
        }
        .onDisappear {
            email = ""
            password = ""
            passwordConfirm = ""
        }
    }
    enum SignUpField: Hashable {
        case email
        case password
        case confirmPassword
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
