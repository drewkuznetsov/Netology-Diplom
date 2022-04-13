//
//  MainTabBarController.swift
//  Diplom
//
//  Created by Андрей Кузнецов on 29.03.2022.
//

import UIKit
import CoreData

class MainTabBarController: UITabBarController {
    
    var managedContex: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.tabBar.tintColor = .purple

        viewControllers = [
            generateViewController(rootViewController: LogInViewController(), imageVC: "person", titelVC: "Profile"),
            generateViewController(rootViewController: FeedViewController(), imageVC: "house.fill", titelVC: "Feed")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, imageVC: String, titelVC: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(systemName: imageVC)
        navigationVC.tabBarItem.title = titelVC
        navigationVC.navigationBar.prefersLargeTitles = true
                
        return navigationVC
    }
}
