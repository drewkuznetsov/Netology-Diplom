//
//  FeedViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    var postArray: [Post] = []

//MARK:- Views
    
    private lazy var tableView: CustomTableView = {
        let table = CustomTableView()
        table.dataSource = self
        table.delegate = self
        table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        return table
    }()
    
//MARK: - ViewSetup

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postArray = profileDataHandler.loadPosts().reversed()

        self.view.backgroundColor = ColorSet.colorLight
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Feed View"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupView()
    
    }
    
    private func setupView() {
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Extensions

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.post = postArray[indexPath.row]
        cell.setCell()
        cell.showProfileDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = postArray[indexPath.row]
        post.views += 1
        profileDataHandler.saveManagedContext()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        
        let postVC = PostViewController()
        postVC.post = post
        self.present(UINavigationController(rootViewController: postVC), animated: true, completion: nil)
        
    }
}

protocol ShowProfileDelegate {
    func showProfile(profile: Profile)
}

extension FeedViewController: ShowProfileDelegate {
    func showProfile(profile: Profile) {
        let profileVC = ProfileViewController()
        profileVC.profile = profile
        profileVC.isEdit = false
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}
