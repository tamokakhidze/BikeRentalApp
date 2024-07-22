//
//  LaunchScreenViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 22.07.24.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    private let bikeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bike_body"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let frontWheelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "front_wheel"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rearWheelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rear_wheel"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBikeAndWheels()
        startBikeAnimation()
        transitionToHomeScreen()
    }
    
    private func setupBikeAndWheels() {
        view.addSubview(bikeImageView)
        view.addSubview(frontWheelImageView)
        view.addSubview(rearWheelImageView)
        
        NSLayoutConstraint.activate([
            bikeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bikeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bikeImageView.widthAnchor.constraint(equalToConstant: 110),
            bikeImageView.heightAnchor.constraint(equalToConstant: 100),
            
            frontWheelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -55),
            frontWheelImageView.bottomAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: 20),
            frontWheelImageView.widthAnchor.constraint(equalToConstant: 100),
            frontWheelImageView.heightAnchor.constraint(equalToConstant: 100),
            
            rearWheelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 55),
            rearWheelImageView.bottomAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: 20),
            rearWheelImageView.widthAnchor.constraint(equalToConstant: 100),
            rearWheelImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func startBikeAnimation() {
        let wheelRotation = CABasicAnimation(keyPath: "transform.rotation")
        wheelRotation.toValue = NSNumber(value: Double.pi * 2)
        wheelRotation.duration = 1
        wheelRotation.isCumulative = true
        wheelRotation.repeatCount = .infinity
        
        frontWheelImageView.layer.add(wheelRotation, forKey: "frontWheelRotation")
        rearWheelImageView.layer.add(wheelRotation, forKey: "rearWheelRotation")
        
        let bikeAnimation = CABasicAnimation(keyPath: "transform.scale")
        bikeAnimation.fromValue = NSNumber(value: 1.0)
        bikeAnimation.toValue = NSNumber(value: 1.1)
        bikeAnimation.duration = 0.5
        bikeAnimation.autoreverses = true
        bikeAnimation.repeatCount = .infinity
        bikeImageView.layer.add(bikeAnimation, forKey: "bikeAnimation")
    }
    
    private func transitionToHomeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            NotificationCenter.default.post(name: NSNotification.Name("LaunchScreenAnimationEnded"), object: nil)
        }
    }
}


#Preview {
    LaunchScreenViewController()
}
