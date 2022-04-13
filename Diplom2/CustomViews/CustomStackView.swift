//
//  CustomStackView.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

class CustomStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.distribution = .fillEqually
        
        self.clipsToBounds = true
        self.backgroundColor = .none
        self.spacing = 3
        
        self.layer.borderColor = UIColor.gray.cgColor

}
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
class VerticalStackView: CustomStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HorizontalStackView: CustomStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

