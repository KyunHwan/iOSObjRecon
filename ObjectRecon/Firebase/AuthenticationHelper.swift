//
//  AuthenticationHelper.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/13/24.
//

import Foundation
import FirebaseAuth

class AuthenticationHelper: ObservableObject {
    
    private var auth: FirebaseAuth.Auth
    private(set) var errorPopup: Bool
    private(set) var signedIn: Bool
    private(set) var errorMessage: String?
    private(set) var currentUser: User?
    
    init() {
        auth = Auth.auth()
        errorPopup = false
        signedIn = false
        errorMessage = nil
        checkSignedIn()
    }
    
    private func checkSignedIn() {
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
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            currentUser = User(userID: result.user.uid,
                        displayName: result.user.displayName,
                        email: result.user.email)
        }
        catch {
            errorMessage = "Sign in failed. Email does not exist."
            errorPopup = true
        }
    }
    
    func signUp(withEmail email: String, password: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            currentUser = User(userID: result.user.uid,
                        displayName: result.user.displayName,
                        email: result.user.email)
        }
        catch {
            errorMessage = "Sign up failed."
            errorPopup = true
        }
    }
    
}
