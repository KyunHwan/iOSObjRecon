//
//  ObjCaptureInstructionView.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 2/1/24.
//

import SwiftUI
import AVKit

struct ObjCaptureInstructionView: View {
    @EnvironmentObject var auth: AuthenticationHelper
    @StateObject private var objCaptureInstVid = ObjCaptureInstructionViewModel()
    
    @State var animate: Bool = false
    let primaryAccentColor = Color("BluePurpleColor")
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    var body: some View {
        ZStack {
            Color("CheezeColor").edgesIgnoringSafeArea(.all)
            VideoPlayer(player: objCaptureInstVid.avPlayerQueue)
                .onAppear {
                    objCaptureInstVid.playInstructionVidInLoop()
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                }
                .onDisappear {
                    objCaptureInstVid.pauseInstructionVidInLoop()
                }
            VStack {
                Spacer()
                NavigationLink(value: AppPage.photoCapture) {
                    bottomButton
                        .onAppear(perform: addAnimation)
                        .padding(.horizontal, animate ? 30 : 50)
                        .shadow(
                            //color: animate ? secondaryAccentColor.opacity(0.7) : primaryAccentColor.opacity(0.7),
                            color: Color.black.opacity(0.5),
                            radius: animate ? 30 : 10,
                            x: 0,
                            y: animate ? 50 : 30)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .offset(y: animate ? -7 : 0)
                    
//                    Text("Start Capture")
//                        .frame(maxWidth: ButtonConstants.infoWindowMaxWidth)
//                        .frame(height: ButtonConstants.infoWindowHeight)
//                        .background(ButtonConstants.backgroundColor)
//                        .foregroundStyle(ButtonConstants.fontColor)
//                        .cornerRadius(ButtonConstants.cornerRadius)
//                        .padding()
//                        .padding(.horizontal, 20)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                signOutButton
            }
        }        
    }
    
    private var signOutButtonLabel: Text { Text(Image(systemName: "chevron.backward")) + Text(" Sign Out") }
    
    private var signOutButton: some View {
        Button {
            auth.signOut()
        } label: {
            signOutButtonLabel
                .foregroundStyle(.blue)
        }
    }
    
}


// MARK: COMPONENTS
extension ObjCaptureInstructionView {
    
    private var bottomButton: some View {
        Text("Start Capture 🥳")
            .foregroundColor(.white)
            .font(.headline)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(animate ? secondaryAccentColor : primaryAccentColor)
            .cornerRadius(10)
            .padding(8)
            .padding(.horizontal)
    }
    
    func addAnimation() {
        guard !animate else { return } // 이미 애니메이션 중이면 바로 리턴하도록!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

// MARK: Constants {
extension ObjCaptureInstructionView {
    private struct ButtonConstants {
        static let infoWindowMaxWidth: CGFloat = .infinity
        static let infoWindowHeight: CGFloat = 70
        static let backgroundColor: Color = .blue
        static let fontColor: Color = .white
        static let cornerRadius: CGFloat = 10
    }
}

#Preview {
    NavigationStack {
        ObjCaptureInstructionView()
    }
}
