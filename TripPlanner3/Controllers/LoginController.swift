
//
//  LoginController.swift
//  TripPlanner3
//
//  Created by stlp on 8/7/24.
//

//import UIKit
//import SwiftUI  // Import SwiftUI to use UIHostingController
//
//class LoginController: UIViewController {
//    
//    // MARK: - UI Components
//    private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
//    
//    private let emailField = CustomTextField(fieldType: .email)
//    private let passwordField = CustomTextField(fieldType: .password)
//    
//    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
//    private let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
//    private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
//    
//    // MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupUI()
//        
//        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
//        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
//        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    
//    // MARK: - UI Setup
//    private func setupUI() {
//        self.view.backgroundColor = .systemBackground
//        
//        self.view.addSubview(headerView)
//        self.view.addSubview(emailField)
//        self.view.addSubview(passwordField)
//        self.view.addSubview(signInButton)
//        self.view.addSubview(newUserButton)
//        self.view.addSubview(forgotPasswordButton)
//        
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        emailField.translatesAutoresizingMaskIntoConstraints = false
//        passwordField.translatesAutoresizingMaskIntoConstraints = false
//        signInButton.translatesAutoresizingMaskIntoConstraints = false
//        newUserButton.translatesAutoresizingMaskIntoConstraints = false
//        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
//            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            self.headerView.heightAnchor.constraint(equalToConstant: 222),
//            
//            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
//            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            self.emailField.heightAnchor.constraint(equalToConstant: 55),
//            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
//            
//            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
//            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
//            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
//            
//            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
//            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
//            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
//            
//            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
//            self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
//            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
//            
//            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
//            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
//            self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
//        ])
//    }
//    
//    // MARK: - Selectors
//    @objc private func didTapSignIn() {
//        let loginRequest = LoginUserRequest(
//            email: self.emailField.text ?? "",
//            password: self.passwordField.text ?? ""
//        )
//        
//        // Email check
//        if !Validator.isValidEmail(for: loginRequest.email) {
//            AlertManager.showInvalidEmailAlert(on: self)
//            return
//        }
//        
//        // Password check
//        if !Validator.isPasswordValid(for: loginRequest.password) {
//            AlertManager.showInvalidPasswordAlert(on: self)
//            return
//        }
//        
//        AuthService.shared.signIn(with: loginRequest) { error in
//            if let error = error {
//                AlertManager.showSignInErrorAlert(on: self, with: error)
//                return
//            }
//            
//            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//                sceneDelegate.checkAuthentication()
//            }
//        }
//    }
//    
//    @objc private func didTapNewUser() {
//        let vc = RegisterController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @objc private func goToSecondView() {
//        // Wrap SecondView in a UIHostingController
//        let secondView = SecondView() // Your SwiftUI view
//        let hostingController = UIHostingController(rootView: secondView) // Wrap in UIHostingController
//        self.navigationController?.pushViewController(hostingController, animated: true) // Push the hosting controller
//    }
//    
//    @objc private func didTapForgotPassword() {
//        let vc = ForgotPasswordController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}

//import UIKit
//import SwiftUI  // Import SwiftUI to use UIHostingController
//
//class LoginController: UIViewController {
//    
//    // MARK: - UI Components
//    private let backgroundImageView: UIImageView = {  // Background image view
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "background")  // Replace with your image name
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    private let containerView: UIView = {  // Semi-transparent container view
//        let view = UIView()
//        view.backgroundColor = UIColor(white: 1, alpha: 0.45)  // White color with 45% opacity
//        view.layer.cornerRadius = 20
//        view.layer.masksToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    
//    private let emailField = CustomTextField(fieldType: .email)
//    private let passwordField = CustomTextField(fieldType: .password)
//    
//    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
//    
//    private let newUserButton: UIButton = {  // Styled button for "New User? Create Account."
//        let button = UIButton(type: .system)
//        let fullText = "New user? Create Account."
//        let attributedString = NSMutableAttributedString(string: fullText)
//        
//        // Exact colors based on the extracted image
//        let softBlueColor = UIColor(red: 97/255, green: 156/255, blue: 203/255, alpha: 1)  // Soft blue for "New user?"
//        let tealColor = UIColor(red: 45/255, green: 85/255, blue: 93/255, alpha: 1)  // Teal color for "Create Account"
//        
//        // Apply the colors and font attributes
//        attributedString.addAttribute(.foregroundColor, value: softBlueColor, range: NSRange(location: 0, length: 9))
//        attributedString.addAttribute(.foregroundColor, value: tealColor, range: NSRange(location: 10, length: 14))
//        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: NSRange(location: 0, length: fullText.count))  // Larger size and bold
//        button.setAttributedTitle(attributedString, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private let forgotPasswordButton: UIButton = {  // Styled button for "Forgot Password?"
//        let button = UIButton(type: .system)
//        
//        // New complementary color for "Forgot Password?"
//        let complementaryColor = UIColor(red: 125/255, green: 98/255, blue: 176/255, alpha: 1)  // Soft purple shade
//        
//        button.setTitle("Forgot Password?", for: .normal)
//        button.setTitleColor(complementaryColor, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)  // Larger size and bold
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    // MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupUI()
//        
//        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
//        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
//        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    
//    // MARK: - UI Setup
//    private func setupUI() {
//        // Set up the background image
//        self.view.addSubview(backgroundImageView)
//        NSLayoutConstraint.activate([
//            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        self.view.backgroundColor = .systemBackground
//        
//        // Set up the container view (faded white box)
//        self.view.addSubview(containerView)
//        NSLayoutConstraint.activate([
//            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
//            containerView.heightAnchor.constraint(equalToConstant: 300)
//        ])
//        
//        // Add other UI components inside the containerView
//        containerView.addSubview(emailField)
//        containerView.addSubview(passwordField)
//        containerView.addSubview(signInButton)
//        containerView.addSubview(newUserButton)
//        containerView.addSubview(forgotPasswordButton)
//        
//        emailField.translatesAutoresizingMaskIntoConstraints = false
//        passwordField.translatesAutoresizingMaskIntoConstraints = false
//        signInButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            self.emailField.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30),
//            self.emailField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            self.emailField.heightAnchor.constraint(equalToConstant: 50),
//            self.emailField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85),
//            
//            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
//            self.passwordField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            self.passwordField.heightAnchor.constraint(equalToConstant: 50),
//            self.passwordField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85),
//            
//            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
//            self.signInButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            self.signInButton.heightAnchor.constraint(equalToConstant: 50),
//            self.signInButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85),
//            
//            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
//            self.newUserButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            
//            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 5),
//            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//        ])
//    }
//    
//    // MARK: - Selectors
//    @objc private func didTapSignIn() {
//        let loginRequest = LoginUserRequest(
//            email: self.emailField.text ?? "",
//            password: self.passwordField.text ?? ""
//        )
//        
//        // Email check
//        if !Validator.isValidEmail(for: loginRequest.email) {
//            AlertManager.showInvalidEmailAlert(on: self)
//            return
//        }
//        
//        // Password check
//        if !Validator.isPasswordValid(for: loginRequest.password) {
//            AlertManager.showInvalidPasswordAlert(on: self)
//            return
//        }
//        
//        AuthService.shared.signIn(with: loginRequest) { error in
//            if let error = error {
//                AlertManager.showSignInErrorAlert(on: self, with: error)
//                return
//            }
//            
//            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//                sceneDelegate.checkAuthentication()
//            }
//        }
//    }
//    
//    @objc private func didTapNewUser() {
//        let vc = RegisterController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @objc private func goToSecondView() {
//        // Wrap SecondView in a UIHostingController
//        let secondView = SecondView() // Your SwiftUI view
//        let hostingController = UIHostingController(rootView: secondView) // Wrap in UIHostingController
//        self.navigationController?.pushViewController(hostingController, animated: true) // Push the hosting controller
//    }
//    
//    @objc private func didTapForgotPassword() {
//        let vc = ForgotPasswordController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}


import UIKit
import SwiftUI  // Import SwiftUI to use UIHostingController

class LoginController: UIViewController {
    
    // MARK: - UI Components
    private let backgroundImageView: UIImageView = {  // Background image view
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")  // Replace with your image name
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {  // Semi-transparent container view
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.35)  // White color with 45% opacity
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let signInLabel: UILabel = {  // "Sign In" heading
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = UIColor(white: 1, alpha: 0.95)  // Dark white color
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)  // Adjust font size and weight as needed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
    
    private let newUserButton: UIButton = {  // Styled button for "New User? Create Account."
        let button = UIButton(type: .system)
        let fullText = "New user? Create Account"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Exact colors based on the extracted image
        let softBlueColor = UIColor(red: 97/255, green: 156/255, blue: 203/255, alpha: 1)  // Soft blue for "New user?"
        let tealColor = UIColor(red: 45/255, green: 85/255, blue: 93/255, alpha: 1)  // Teal color for "Create Account"
        
        // Apply the colors and font attributes
        attributedString.addAttribute(.foregroundColor, value: softBlueColor, range: NSRange(location: 0, length: 9))
        attributedString.addAttribute(.foregroundColor, value: tealColor, range: NSRange(location: 10, length: 14))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: NSRange(location: 0, length: fullText.count))  // Larger size and bold
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {  // Styled button for "Forgot Password?"
        let button = UIButton(type: .system)
        
        // New complementary color for "Forgot Password?"
        let complementaryColor = UIColor(red: 125/255, green: 98/255, blue: 176/255, alpha: 1)  // Soft purple shade
        
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(complementaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)  // Larger size and bold
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Set up the background image
        self.view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.view.backgroundColor = .systemBackground
        
        // Set up the container view (faded white box)
        self.view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalToConstant: 350)  // Increase height to accommodate the heading
        ])
        
        // Add UI components inside the containerView
        containerView.addSubview(signInLabel)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(signInButton)
        containerView.addSubview(newUserButton)
        containerView.addSubview(forgotPasswordButton)
        
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Sign In Label
            signInLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            signInLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            // Email Field
            self.emailField.topAnchor.constraint(equalTo: self.signInLabel.bottomAnchor, constant: 15),
            self.emailField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 50),
            self.emailField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85),
            
            // Password Field
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            self.passwordField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 50),
            self.passwordField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85),
            
            // Sign In Button
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            self.signInButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 50),
            self.signInButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85),
            
            // New User Button
            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            self.newUserButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            // Forgot Password Button
            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 5),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        let loginRequest = LoginUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Email check
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.signIn(with: loginRequest) { error in
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    @objc private func didTapNewUser() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func goToSecondView() {
        // Wrap SecondView in a UIHostingController
        let secondView = SecondView() 
        let hostingController = UIHostingController(rootView: secondView) // Wrap in UIHostingController
        self.navigationController?.pushViewController(hostingController, animated: true) // Push the hosting controller
    }
    
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
