//
//  IntroController.swift
//  TripPlanner3
//
//  Created by stlp on 9/7/24.
//

import Foundation
import UIKit

class IntroController: UIViewController {

    var onTapCompletion: (() -> Void)?  // Closure to be executed when the image is tapped

    private let introImageView: UIImageView = {  // Image view to display the provided intro image
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splashImage")  // Replace "introImage" with your image name
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true  // Enable interaction to detect taps
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        // Add tap gesture recognizer to the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        introImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        self.view.addSubview(introImageView)
        NSLayoutConstraint.activate([
            introImageView.topAnchor.constraint(equalTo: view.topAnchor),
            introImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            introImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            introImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didTapImage() {
        // Navigate to SplashController without animation when the image is tapped
        let splashController = SplashController()
        self.navigationController?.pushViewController(splashController, animated: false)  // No animation
    }
}
