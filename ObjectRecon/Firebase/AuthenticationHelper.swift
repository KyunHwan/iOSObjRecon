//
//  AuthenticationHelper.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/13/24.
//

import Foundation
import FirebaseAuth

class AuthenticationHelper: ObservableObject {
    @Published var signedIn: Bool
    @Published var signInErrorPopup: Bool
    @Published var signUpErrorPopup: Bool
    private var auth: FirebaseAuth.Auth
    private(set) var errorMessage: String
    private(set) var currentUser: User?
    
    init() {
        auth = Auth.auth()
        signInErrorPopup = false
        signUpErrorPopup = false
        signedIn = false
        errorMessage = ""
    }
    
    @MainActor
    func checkSignedIn() {
        if let user = auth.currentUser {
            currentUser = User(userID: user.uid,
                               displayName: user.displayName,
                               email: user.email)
            signedIn = true
        }
    }
    
    struct User {
        let userID: String?
        let displayName: String?
        var email: String?
    }
}


// MARK: Email Authentication
extension AuthenticationHelper {
    @MainActor
    func signOut() {
        guard let user = currentUser else { fatalError("User is NOT signed in but bypassed sign-in procedure") }
        do {
            try auth.signOut()
            signedIn = false
        } catch {
            print("Sign out failed")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            currentUser = User(userID: result.user.uid,
                        displayName: result.user.displayName,
                        email: result.user.email)
            await MainActor.run {
                signedIn = true
            }
        }
        catch {
            errorMessage = "Email/Password does not exist"
            await MainActor.run {
                signInErrorPopup = true
            }
        }
    }
    
    func signUp(withEmail email: String, password: String, confirmPasswordWith passwordCheck: String) async throws {
        if !password.isEmpty, !passwordCheck.isEmpty, !email.isEmpty {
            if password == passwordCheck {
                do {
                    let result = try await auth.createUser(withEmail: email, password: password)
                    currentUser = User(userID: result.user.uid,
                                       displayName: result.user.displayName,
                                       email: result.user.email)
                }
                catch {
                    errorMessage = "Sign up failed"
                    await MainActor.run {
                        signUpErrorPopup = true
                    }
                }
            }
            else {
                errorMessage = "Passwords do not match"
                await MainActor.run {
                    signUpErrorPopup = true
                }
            }
        }
        else {
            errorMessage = "One of the Sign-up fields is empty"
            await MainActor.run {
                signUpErrorPopup = true
            }
        }
    }
    
}
