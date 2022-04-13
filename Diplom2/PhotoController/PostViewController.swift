//
//  PostViewController.swift
//  Diplom2
//
//  Created by Андрей Кузнецов on 09.04.2022.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post!
    
    private lazy var tableView: CustomTableView = {
        let table = CustomTableView()
    
        table.delegate = self
        table.dataSource = self
        
        table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
 
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorSet.colorLight
        
        setupNavigation()
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = post.title
    }
    
    private func setupNavigation() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let exitButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(exitButtonTapped))
        let shareButton = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(shareButtonTaped))
        
        self.navigationItem.setLeftBarButton(exitButton, animated: true)
        self.navigationItem.setRightBarButton(shareButton, animated: true)
    }
    
    @objc private func shareButtonTaped() {
        let shareControler = UIActivityViewController(activityItems: [UIImage(data: (post.photo?.imageData)!)], applicationActivities: nil)
        present(shareControler, animated: true, completion: nil)
    }
    
    @objc private func exitButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.post = post
        cell.setCell()
        return cell
    }
    
}
