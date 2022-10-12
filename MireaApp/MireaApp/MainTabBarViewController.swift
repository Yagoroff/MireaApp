//
//  MainTabBarViewController.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: NewsfeedViewController())
        let vc2 = UINavigationController(rootViewController: CampusMapViewController())
        let vc3 = UINavigationController(rootViewController: ScheduleViewController())
                              
        vc1.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(systemName: "newspaper"), tag: 1)
        vc2.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), tag: 2)
        vc3.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(systemName: "calendar"), tag: 3)
        
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
        
        tabBar.tintColor = UIColor.init(rgb: 0x574af9)
        tabBar.barTintColor = .white

        setViewControllers([vc1, vc2, vc3], animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
