//
//  SliderCollectionViewCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 28.06.24.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    var images = UIImageView()
    static var identifier = "SliderCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        images = configureImageView()
        setupUi()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUi() {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }
    
    
    func configureSliderCell(imageURL: String) {
        guard let imageURL = URL(string: imageURL) else { return }
        images.setImage(with: imageURL)
    }
}
