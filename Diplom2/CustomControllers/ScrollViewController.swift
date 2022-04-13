//
//  ScrollViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

class ScrollViewController: UIViewController {

//MARK: - Views
    
    var photoImage = UIImage()
    
    lazy var scrollView: CustomScrollView = {
        let scroll = CustomScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    
//MARK: - Setup View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorSet.colorLight
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupView() {
        self.view.addSubview(scrollView)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.forcedHideKeyboard)))
    }
    
//MARK: - Functions
    
    func addCustomSubview(subView: UIView) {
        self.scrollView.addCustomSubview(subView: subView)
    }
    
    @objc private func forcedHideKeyboard() {
        hideKayboard()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue
        else {
            return
        }
       
        showKeyboard(height: keyboardFrame.cgRectValue.minY)
        
    }
    
    @objc private func keyboardWillHide() {
       self.scrollView.contentOffset = .zero
   //     hideKeyboard(height: 0)
    }
    
    func showKeyboard(height: CGFloat) {
        
    }
    
    func hideKayboard() {
        
    }
    
    func imageDidLoad() {
        
    }
    
    func showErrorAlert(titel: String, subTitel: String) {
        
        let alert = UIAlertController(title: titel, message: subTitel, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

//MARK: - Extensions

extension ScrollViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showSourceList() {
        let alert = UIAlertController(title: "Choose photo source", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in self.showImagePickerController(sourceType: .photoLibrary ) }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.showImagePickerController(sourceType: .camera) }))
        alert.addAction(UIAlertAction(title: "Cansel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoImage = editedImage
        } else {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.photoImage = originalImage
            }
        }
        
        dismiss(animated: true, completion: nil)
        imageDidLoad()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



