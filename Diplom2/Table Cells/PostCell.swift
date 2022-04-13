//
//  PostCell.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 08.04.2022.
//

import UIKit

class PostCell: UITableViewCell {
    
    var post: Post!
    
//MARK: - Views
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profilePhotoView: SmallRoundImageView = {
        let imageView = SmallRoundImageView(frame: .zero)
        imageView.imageViewTapDelegate = self
        return imageView
    }()
    
    private lazy var profileButton: TitelButton = {
        let button = TitelButton()
        button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var titelLabel: TitelLable = {
        let label = TitelLable()
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var photoView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var postText: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor =  .systemGray //.purple
        textView.numberOfLines = 0
        return textView
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var imageMultiplier: CGFloat = 1
    
    private var heightConstraint = NSLayoutConstraint()
    private var constraintArray = [NSLayoutConstraint]()
    
    var showProfileDelegate: ShowProfileDelegate?

//MARK: - Setup Views
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorSet.colorLight
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profilePhotoView.image = nil
        self.titelLabel.text = nil
        self.photoView.image = nil
        self.postText.text = nil
        self.likesLabel.text = nil
        self.viewLabel.text = nil
    }

    private func setupView() {
        
        self.contentView.addSubview(backView)
        constraintArray.append(backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewConstants.inset))
        constraintArray.append(backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0))
        constraintArray.append(backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewConstants.inset))
        constraintArray.append(backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0))
        
        backView.addSubview(profilePhotoView)
        constraintArray.append(profilePhotoView.leadingAnchor.constraint(equalTo: backView.leadingAnchor))
        constraintArray.append(profilePhotoView.topAnchor.constraint(equalTo: backView.topAnchor, constant: ViewConstants.inset))
        constraintArray.append(profilePhotoView.widthAnchor.constraint(equalToConstant: ViewConstants.smallImageSize))
        constraintArray.append(profilePhotoView.heightAnchor.constraint(equalToConstant: ViewConstants.smallImageSize))
        
        backView.addSubview(profileButton)
        constraintArray.append(profileButton.leadingAnchor.constraint(equalTo: profilePhotoView.trailingAnchor, constant: ViewConstants.inset))
        constraintArray.append(profileButton.topAnchor.constraint(equalTo: profilePhotoView.topAnchor))
        constraintArray.append(profileButton.heightAnchor.constraint(equalToConstant: ViewConstants.smallImageSize))
        
        backView.addSubview(stackView)
        constraintArray.append(stackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor))
        constraintArray.append(stackView.topAnchor.constraint(equalTo: profilePhotoView.bottomAnchor,constant: ViewConstants.inset))
        constraintArray.append(stackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor))

        stackView.addArrangedSubview(titelLabel)
        stackView.addArrangedSubview(photoView)
        constraintArray.append(photoView.widthAnchor.constraint(equalTo: backView.widthAnchor))
        heightConstraint = photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: imageMultiplier)
        
        stackView.addArrangedSubview(postText)
        
        backView.addSubview(likesLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateLikes))
        likesLabel.addGestureRecognizer(tapGesture)
        constraintArray.append(likesLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor))
        constraintArray.append(likesLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: ViewConstants.inset))
        constraintArray.append(likesLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor,constant: -ViewConstants.inset))
        
        backView.addSubview(viewLabel)
        constraintArray.append(viewLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ViewConstants.inset))
        constraintArray.append(viewLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor))
        constraintArray.append(viewLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor,constant: -ViewConstants.inset))
        
        NSLayoutConstraint.activate(constraintArray)
        heightConstraint.isActive = true
    }
    
    func setCell() {
        
        self.profilePhotoView.image = UIImage(data: (post.profile?.avatar?.imageData)!)
        self.profileButton.setTitle(post.profile?.name!, for: .normal)
        self.titelLabel.text = post.title
        self.photoView.image = UIImage(data: (post.photo?.imageData)!)
        self.postText.text = post.postText
        self.likesLabel.text = "Likes: \(post.likes)"
        self.viewLabel.text = "Views: \(post.views)"
        
        imageMultiplier = (photoView.image!.size.height / photoView.image!.size.width)
        heightConstraint.isActive = false
        heightConstraint = photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: imageMultiplier)
        heightConstraint.isActive = true
      
    }
    
//MARK: - Funcs
    
    @objc private func updateLikes() {
       
        post.likes += 1
        profileDataHandler.saveManagedContext()
        self.likesLabel.text = "Likes: \(post.likes)"
    }
    
    
    @objc private func showProfile() {
        
        self.showProfileDelegate?.showProfile(profile: post.profile!)
    }
}

// MARK: - Extensions

extension PostCell: ImageViewTap {
    func imageViewTap() {
        
        self.showProfileDelegate?.showProfile(profile: post.profile!)
    }
    
    
}
