//
//  AddPostViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 08.04.2022.
//

import UIKit

class AddPostViewController: ScrollViewController {
    
    var profile: Profile!
    
    private var bottomConstraint = NSLayoutConstraint()
    
//MARK: - Views
    
    lazy var titleTextField: TitelTextField = {
        let textField = TitelTextField()
        return textField
    }()
    
    private lazy var postTextView: UITextView = {
        let postView = UITextView()
        postView.backgroundColor = .white
        postView.textColor = .black
        postView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        postView.layer.borderColor = ColorSet.colorPurp.cgColor
//        postView.layer.borderWidth = 1
        postView.translatesAutoresizingMaskIntoConstraints = false
        return postView
    }()
    
    private lazy var photoImageView: FrameImageView = {
        let imageView = FrameImageView(frame: .zero)
        imageView.imageViewTapDelegate = self
        return imageView
    }()
    
    private lazy var addPhotoLabel: AddPhotoLable = {
        let label = AddPhotoLable()
        return label
    }()
    
//MARK: - ViewSetup

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorSet.colorLight
        self.navigationItem.title = "NewPost"

        setupView()
        activateConstraints()
    }
    
    private func setupView() {
        
        self.addCustomSubview(subView: titleTextField)
        self.addCustomSubview(subView: postTextView)
        self.addCustomSubview(subView: addPhotoLabel)
        self.addCustomSubview(subView: photoImageView)
        
        bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        let addPostButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addNewPost))
        self.navigationItem.setRightBarButton(addPostButton, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollView.backView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            scrollView.backView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollView.backView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollView.backView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollView.backView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: self.scrollView.backView.leadingAnchor, constant: ViewConstants.inset),
            titleTextField.topAnchor.constraint(equalTo: self.scrollView.backView.topAnchor, constant: ViewConstants.inset),
            titleTextField.trailingAnchor.constraint(equalTo: self.scrollView.backView.trailingAnchor, constant: -ViewConstants.inset),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            postTextView.leadingAnchor.constraint(equalTo: self.scrollView.backView.leadingAnchor, constant: ViewConstants.inset),
            postTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: ViewConstants.inset),
            postTextView.trailingAnchor.constraint(equalTo: self.scrollView.backView.trailingAnchor, constant: -ViewConstants.inset),
            postTextView.heightAnchor.constraint(equalTo: postTextView.widthAnchor, multiplier: 1/4),
            
            photoImageView.leadingAnchor.constraint(equalTo: self.scrollView.backView.leadingAnchor, constant: ViewConstants.inset),
            photoImageView.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: ViewConstants.inset),
            photoImageView.trailingAnchor.constraint(equalTo: self.scrollView.backView.trailingAnchor, constant: -ViewConstants.inset),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            
            addPhotoLabel.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
//            addPhotoLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            addPhotoLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            
            photoImageView.bottomAnchor.constraint(equalTo: scrollView.backView.bottomAnchor, constant: -ViewConstants.inset)
        ])
    }
    
   
//MARK: - Functions
    
    override func hideKayboard() {        
        self.titleTextField.endEditing(true)
        self.postTextView.endEditing(true)
    }
    
    override func showKeyboard(height: CGFloat) {
        
        let heightOffset = addPhotoLabel.frame.maxY - height + ViewConstants.inset
        
        if heightOffset > 0 {
            self.scrollView.contentOffset = CGPoint(x: 0, y: heightOffset)
        }
    }
    
    func checkButtonState() {
        
        if photoImageView.isValid && titleTextField.isValid {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func imageDidLoad() {
        self.photoImageView.image = self.photoImage
        self.checkButtonState()
    }
    
    @objc private func addNewPost() {
        
        let text = self.postTextView.text ?? ""
        
        profileDataHandler.addPostToProfile(
            postTitle: titleTextField.validText,
            postText: text,
            postPhoto: self.photoImageView.validImage,
            profile: self.profile)
        
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - Extensions

extension AddPostViewController: ImageViewTap {
    
    func imageViewTap() {
        self.titleTextField.endEditing(true)
        self.postTextView.endEditing(true)
        showSourceList()
    }
    
}
