//
//  PhotoPreviewViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 09.04.2022.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

//MARK: - Views
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var imageName: String = ""
    
//MARK: - SetupViewa bv

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .purple
        
        setupNavigation()
        
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -16),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
    }
    
    private func setupNavigation() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = ColorSet.colorLight
        
        let exitButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(exitButtonTapped))
        let shareButton = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(shareButtonTaped))
        
        self.navigationItem.setLeftBarButton(exitButton, animated: true)
        self.navigationItem.setRightBarButton(shareButton, animated: true)
    }
    
//MARK: - Functions
    
    @objc private func exitButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func shareButtonTaped() {
        let image = imageView.image ?? UIImage()
        let shareControler = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareControler, animated: true, completion: nil)
    }
    
    func setImage(photo: Photo) {
        self.imageName = photo.name ?? ""
        self.imageView.image = UIImage(data: photo.imageData!)
        self.navigationItem.title = imageName
    }
}
