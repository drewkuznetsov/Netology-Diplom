//
//  PhotoViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 08.04.2022.
//

import UIKit

class PhotoViewController: UIViewController {
    
    private enum Constant {
        static let numberOfItems: CGFloat = 3
        static let minimumSpacing: CGFloat = 8
    }
    
    var profile: Profile!
    
    var isEdit: Bool = false
    
    //MARK: - Views
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constant.minimumSpacing
        layout.minimumLineSpacing = Constant.minimumSpacing
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .none
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefoltCell")
        collection.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    //MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorSet.colorLight
        self.navigationItem.title = "Photo Gallery"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let addPhotoButton = UIBarButtonItem(title: "NewPhoto", style: .done, target: self, action: #selector(addNewPhoto))
        self.navigationItem.setRightBarButton(addPhotoButton, animated: true)
        
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: Constant.minimumSpacing),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constant.minimumSpacing),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.minimumSpacing),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Constant.minimumSpacing)
        ])
    }
    
    private func countSize(width: CGFloat) -> CGSize {
        
        let size: CGFloat = floor((width - Constant.minimumSpacing * (Constant.numberOfItems - 1)) / Constant.numberOfItems)
        return CGSize(width: size, height: size)
    }
    
    @objc private func addNewPhoto() {
        showImagePickerController()
    }
    
}

//MARK: - Extensions

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionCell
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefoltCell", for: indexPath)
            let image = UIImageView(frame: cell.bounds)
            image.image = UIImage(data: profile.photos!.reversed()[indexPath.item].imageData!) ?? UIImage()
            cell.contentView.addSubview(image)
            return cell
        }
        let image = UIImage(data: profile.photos!.reversed() [indexPath.item].imageData!) ?? UIImage()
        cell.setImage(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return countSize(width: collectionView.frame.width)
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let preview = PhotoPreviewViewController()
        preview.setImage(photo: profile.photos!.reversed()[indexPath.item])
        self.navigationController?.present(UINavigationController(rootViewController: preview), animated: true, completion: nil)
    }
 
}

//MARK: - Image Picker

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var photoImage = UIImage()
        var photoName = ""
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoImage = editedImage
        } else {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                photoImage = originalImage
            }
        }
        
        dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Photo Name", message: "Enter the name", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Photo Name"
            field.returnKeyType = .done
        }
        
        alert.addAction(UIAlertAction(title: "Cansel", style: .cancel, handler: {_ in return }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            
            if let field = alert.textFields?.first {
                photoName = field.text ?? ""
                profileDataHandler.addPhotoToProfile(photoImage: photoImage, photoName: photoName, profile: self.profile)
                self.collectionView.reloadData()

            } else {return}
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

