//
//  CustomImageView.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

class CustomImageView: UIImageView {
    
    var imageViewTapDelegate: ImageViewTap?
    var isValid: Bool { return self.image != nil }
    var validImage: UIImage { return self.isValid ? self.image! : UIImage()}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        
        self.isUserInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
    
    
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTap)))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc private func imageViewTap() {
//        imageViewTapDelegate?.imageViewTap()
//    }
    
}

class TapImageView: CustomImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func imageViewTap() {
        imageViewTapDelegate?.imageViewTap()
    }
}

class RoundImageView: TapImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = ViewConstants.imageSize / 2
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor // ColorSet.colorPurp.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class SmallRoundImageView: TapImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = ViewConstants.smallImageSize / 2
        self.layer.borderWidth = 0
        self.contentMode = .scaleAspectFill
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FrameImageView: TapImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.layer.borderWidth = 1
//        self.layer.borderColor = ColorSet.colorPurp.cgColor
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
