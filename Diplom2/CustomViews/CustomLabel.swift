//
//  CustomLabel.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TitelLable: CustomLabel {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SubTitelLabel: CustomLabel {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.textColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddPhotoLable: SubTitelLabel {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.text = "Add Photo"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

