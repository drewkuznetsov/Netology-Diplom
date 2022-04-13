//
//  HeaderCell.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 08.04.2022.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    var profile: Profile!
    
    var isEdit = false
    
    var animatePhotoDelegate: ImageViewTap?
    
//MARK: - Views
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.colorGreen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.textEditEnd)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var photoImageView: RoundImageView = {
        let imageView = RoundImageView(frame: .zero)
        imageView.image =  UIImage(data: (profile.avatar?.imageData)!) ?? UIImage()
        imageView.imageViewTapDelegate = self
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private lazy var nameLabel: TitelLable = {
        let label = TitelLable()
        label.text = profile.name
        return label
    }()
    
    private lazy var statusButton: SimpleButton = {
        let button = SimpleButton()
        button.setTitle(profile.status, for: .normal)
        button.simpleButtonTapDelegate = self
        return button
    }()
    
    private lazy var statusTextField: StatusTextField = {
        let textField = StatusTextField()
        textField.addTarget(self, action: #selector(textEditEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textEditExit), for: .editingDidEndOnExit)
        textField.isHidden = true
        return textField
    }()
    

//MARK: - View Setup

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        self.setupView()
        self.activateConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.contentView.addSubview(backView)
        self.backView.addSubview(photoImageView)
        self.backView.addSubview(nameLabel)
        self.backView.addSubview(statusButton)
        self.backView.addSubview(statusTextField)
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            
            backView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            photoImageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: ViewConstants.inset),
            photoImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: ViewConstants.inset),
            photoImageView.widthAnchor.constraint(equalToConstant: ViewConstants.imageSize),
            photoImageView.heightAnchor.constraint(equalToConstant: ViewConstants.imageSize),
            
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: ViewConstants.inset),
            nameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: ViewConstants.inset),
            nameLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -ViewConstants.inset),
            
            statusButton.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: ViewConstants.inset),
            statusButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -ViewConstants.inset),
            
            statusTextField.leadingAnchor.constraint(equalTo: statusButton.leadingAnchor),
            statusTextField.topAnchor.constraint(equalTo: statusButton.topAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -ViewConstants.inset),
            statusTextField.heightAnchor.constraint(equalToConstant: ViewConstants.textFieldHeight),
            
            photoImageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -ViewConstants.inset)
        ])
    }
    
//MARK: - Functions
    
    @objc private func textEditEnd() {
        self.statusTextField.endEditing(true)
        self.statusTextField.isHidden = true
    }
    
    @objc private func textEditExit() {
        
        if self.statusTextField.isValid {
            profile.status = statusTextField.validText
            profileDataHandler.saveManagedContext()
            self.statusButton.setTitle(statusTextField.validText, for: .normal)
        }
        self.statusTextField.endEditing(true)
        self.statusTextField.isHidden = true
    }

}

//MARK: - Extensions

extension HeaderCell: ImageViewTap {
    
    func imageViewTap() {
        self.animatePhotoDelegate?.imageViewTap()
    }
}

extension HeaderCell: SimpleButtonTap {
    
    func simpleButtonTap() {
        
        if self.isEdit {
            self.statusTextField.isHidden = false
            self.statusTextField.text = profile.status
        }
    }
}
