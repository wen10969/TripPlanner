//
//  SceneDelegate.swift
//  TripPlanner3
//
//  Created by stlp on 8/5/24.
//

//import UIKit
//import SwiftUI
//import FirebaseAuth
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        self.setupWindow(with: scene)
//        self.checkAuthentication()  
//    }
//    
//    private func setupWindow(with scene: UIScene) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        let window = UIWindow(windowScene: windowScene)
//        self.window = window
//        self.window?.makeKeyAndVisible()
//    }
//    
//    public func checkAuthentication() {
//        if Auth.auth().currentUser == nil {
//            // If the user is not authenticated, show the LoginController
//            self.goToController(with: LoginController())
//        } else {
//            // If the user is authenticated, show the SecondView
//            self.showSecondView()
//        }
//    }
//    
//    private func goToController(with viewController: UIViewController) {
//        DispatchQueue.main.async { [weak self] in
//            UIView.animate(withDuration: 0.25) {
//                self?.window?.layer.opacity = 0
//            } completion: { [weak self] _ in
//                let nav = UINavigationController(rootViewController: viewController)
//                nav.modalPresentationStyle = .fullScreen
//                self?.window?.rootViewController = nav
//                
//                UIView.animate(withDuration: 0.25) { [weak self] in
//                    self?.window?.layer.opacity = 1
//                }
//            }
//        }
//    }
//    
//    private func showSecondView() {
//        DispatchQueue.main.async { [weak self] in
//            UIView.animate(withDuration: 0.1) {
//                self?.window?.layer.opacity = 0
//            } completion: { [weak self] _ in
//                let hostingController = UIHostingController(rootView: SecondView())
//                hostingController.modalPresentationStyle = .fullScreen
//                self?.window?.rootViewController = hostingController
//                
//                UIView.animate(withDuration: 0.1) { [weak self] in
//                    self?.window?.layer.opacity = 1
//                }
//            }
//        }
//    }
//}
//


import UIKit
import SwiftUI
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.showIntroScreen()  // Start with the intro screen
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }

    // Show Intro Screen first
    private func showIntroScreen() {
        let introController = IntroController()
        self.goToController(with: introController)
    }
    
    // Checks authentication and decides which screen to show next
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            // If the user is not authenticated, show the LoginController
            self.goToController(with: LoginController())
        } else {
            // If the user is authenticated, show the SecondView
            self.showSecondView()
        }
    }
    
    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.0) {  // Set duration to 0.0 to remove animation
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                let nav = UINavigationController(rootViewController: viewController)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.0) {  // Set duration to 0.0 to remove animation
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
    
    private func showSecondView() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.0) {  // Set duration to 0.0 to remove animation
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                let hostingController = UIHostingController(rootView: SecondView())
                hostingController.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = hostingController
                
                UIView.animate(withDuration: 0.0) {  // Set duration to 0.0 to remove animation
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
}
