//
//  PhotoCollectionCell.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 08.04.2022.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 6
        return photo
    }()

//MARK: - View Setup

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.contentView.addSubview(backView)
        backView.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            photoImageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: backView.topAnchor),
            photoImageView.trailingAnchor.constraint(equalTo:backView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.photoImageView.image = nil
    }
    
    func setImage(image: UIImage) {
        self.photoImageView.image = image
    }

}
