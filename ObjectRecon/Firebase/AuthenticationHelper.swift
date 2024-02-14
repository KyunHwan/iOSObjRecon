//
//  AuthenticationHelper.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/13/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore

class AuthenticationHelper: ObservableObject {
    @Published var signedIn: Bool
    @Published var signInErrorPopup: Bool
    @Published var signUpErrorPopup: Bool
    
    private var auth: FirebaseAuth.Auth
    private(set) var errorMessage: String
    private(set) var currentUser: UserInfo?
    
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
            currentUser = UserInfo(user: user)
            signedIn = true
        }
    }
    
    @MainActor
    func signOut() {
        guard let _ = currentUser else { fatalError("User is NOT signed in but bypassed sign-in procedure") }
        do {
            try auth.signOut()
            signedIn = false
        } catch {
            print("Sign out failed")
        }
    }
    
    struct UserInfo {
        let userID: String?
        let displayName: String?
        var email: String?
        
        init(user: User?) {
            userID = user?.uid
            displayName = user?.displayName
            email = user?.email
        }
    }
}


// MARK: Email Authentication
extension AuthenticationHelper {
    func signInEmail(withEmail email: String, password: String) async throws {
        do {
            let authDataResult = try await auth.signIn(withEmail: email, password: password)
            currentUser = UserInfo(user: authDataResult.user)
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
    
    func signUpEmail(withEmail email: String, password: String, confirmPasswordWith passwordCheck: String) async throws {
        if !password.isEmpty, !passwordCheck.isEmpty, !email.isEmpty {
            if password == passwordCheck {
                do {
                    let authDataResult = try await auth.createUser(withEmail: email, password: password)
                    currentUser = UserInfo(user: authDataResult.user)
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


// MARK: Google Authentication
extension AuthenticationHelper {
    struct GoogleSignInResultModel {
        let idToken: String
        let accessToken: String
        let name: String?
        let email: String?
    }
    
    @MainActor
    private func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    @MainActor
    private func googleSignInTokens() async throws -> GoogleSignInResultModel? {
        guard let topVC = topViewController() else {
            throw URLError(.cannotFindHost)
        }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return nil }
        
        // Create Google Sign In configureation object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
    
    private func signIn(credential: AuthCredential) async throws -> UserInfo {
        let authDataResult = try await auth.signIn(with: credential)
        return UserInfo(user: authDataResult.user)
    }
    
    @discardableResult
    private func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> UserInfo {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signInGoogle() async throws {
        let tokens = try await googleSignInTokens()
        currentUser = try await signInWithGoogle(tokens: tokens!)
        await MainActor.run {
            signedIn = true
        }
    }
}
