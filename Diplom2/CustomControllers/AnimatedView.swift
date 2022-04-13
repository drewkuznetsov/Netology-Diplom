//
//  AnimatedView.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 09.04.2022.
//

import UIKit

class AnimatedView: UIView {
    
    private var width: CGFloat
    private var height: CGFloat
    
    private var multiplyer: CGFloat = 1
    
    private var widthConstraint = NSLayoutConstraint()
    private var heightConstraint = NSLayoutConstraint()
    
    var photoImage = UIImage() {
        didSet {
            self.photoImageView.image = photoImage
            self.multiplyer = photoImage.size.height / photoImage.size.width
        }
    }
    
//MARK: - Views
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.alpha = 0.1
        view.backgroundColor = ColorSet.colorLight
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var photoImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        
        self.width = frame.width
        self.height = frame.height
        super.init(frame: frame)
        
        viewSetup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewSetup() {
        
        self.addSubview(backView)
        self.addSubview(photoImageView)
        
        self.widthConstraint = photoImageView.widthAnchor.constraint(equalToConstant: ViewConstants.imageSize)
        self.heightConstraint = photoImageView.heightAnchor.constraint(equalToConstant: ViewConstants.imageSize * multiplyer)
        
        NSLayoutConstraint.activate([
            backView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backView.widthAnchor.constraint(equalToConstant: width),
            backView.heightAnchor.constraint(equalToConstant: height),
            photoImageView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            widthConstraint, heightConstraint,
        ])
    }
    
    func animate() {
        
        self.widthConstraint.constant = self.width - 2 * ViewConstants.inset
        self.heightConstraint.constant = self.width * multiplyer

        UIView.animate(withDuration: 0.5) {
            self.backView.alpha = 0.9
            self.photoImageView.alpha = 1
            self.photoImageView.layer.cornerRadius = 0
            self.layoutIfNeeded()
        } completion: { _ in
//            self.showCloseButton()
        }
    }
    
    @objc private func hideView() {
        
        self.widthConstraint.constant = ViewConstants.imageSize
        self.heightConstraint.constant = ViewConstants.imageSize 

        UIView.animate(withDuration: 0.5) {
            self.backView.alpha = 0.1
            self.photoImageView.alpha = 0.1
            self.photoImageView.layer.cornerRadius = ViewConstants.imageSize / 2
            self.layoutIfNeeded()
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    
}
