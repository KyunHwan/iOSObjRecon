//
//  ObjectReconApp.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/22/24.
//

import SwiftUI
import AVFoundation
import Firebase

@main
struct ObjectReconApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
