//
//  ProfileViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 08.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profile: Profile! = profileDataHandler.loadProfile(by: "tmp@tmp.ru")
    var isEdit: Bool = true

//MARK: - Views
    
    private lazy var tableView: CustomTableView = {
        let table = CustomTableView()
    
        table.delegate = self
        table.dataSource = self
        
        table.register(HeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        table.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
        table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
 
        return table
    }()
    
    private lazy var animatedView: AnimatedView = {
        let view = AnimatedView(frame: self.view.frame)
        view.isHidden = true
        return view
    }()

//MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorSet.colorLight
        
        setupNavigation()
        setupView()
        activateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    private func setupNavigation() {
        
        self.navigationItem.title = "Profile Page"//profileDataArray[profileIndex].name
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = .purple
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.backButtonTitle = "Profile View"
        
        if self.isEdit {
            let addPostButton = UIBarButtonItem(title: "NewPost", style: .done, target: self, action: #selector(addNewPost))
            self.navigationItem.setRightBarButton(addPostButton, animated: true)
        }
        
    }
    
    private func setupView() {
        self.view.addSubview(tableView)
        self.view.addSubview(animatedView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
//MARK: - Functions
    
    @objc private func addNewPost(){
        let addPostVC = AddPostViewController()
        addPostVC.profile = self.profile
        self.navigationController?.pushViewController(addPostVC, animated: true)
   }

}

//MARK: - Extensions

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        
        case 0 : return 1
        case 1 : return 1
        case 2 : return profile.posts!.count
        default: return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.profile = profile
            cell.isEdit = self.isEdit
            cell.animatePhotoDelegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            cell.profile = self.profile
            cell.photoDelegate = self
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.post = profile.posts!.reversed()[indexPath.row]
            cell.setCell()
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            self.showPhotoController()
        }
        
        if indexPath.section == 2 {
            
            let post = profile.posts!.reversed()[indexPath.row]
            post.views += 1
            profileDataHandler.saveManagedContext()
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            
            let postVC = PostViewController()
            postVC.post = post
            self.present(UINavigationController(rootViewController: postVC), animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 2{
            return self.isEdit ? .delete : .none
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let post = profile.posts?.reversed()[indexPath.row]
        else {return}
        
        profileDataHandler.deletePost(post: post, profile: post.profile!)
        self.tableView.reloadData()
    }
}

extension ProfileViewController: ShowPhoto {
    
    func showSelectedPhoto(number: Int) {
//        let preview = PhotoPreviewViewController()
//        preview.setImage(photo: profile.photos!.reversed()[number])
//        self.navigationController?.present(UINavigationController(rootViewController: preview), animated: true, completion: nil)
        
        animatedView.photoImage = UIImage(data: (profile.photos?.reversed()[number].imageData)!) ?? UIImage()
        animatedView.isHidden = false
        animatedView.animate()
    }
    
    func showPhotoController() {
        let photoViewController = PhotoViewController()
        photoViewController.profile = self.profile    
        self.navigationController?.pushViewController(photoViewController, animated: true)
    }
}

extension ProfileViewController: ImageViewTap {
    
    func imageViewTap() {
        
        animatedView.photoImage = UIImage(data: (profile.avatar?.imageData)!) ?? UIImage()
        animatedView.isHidden = false
        animatedView.animate()
        
        
    }
    
}
