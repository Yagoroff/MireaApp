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
                      
        vc1.tabBarItem.image = UIImage(systemName: "newspaper")
        vc2.tabBarItem.image = UIImage(systemName: "map")
        vc3.tabBarItem.image = UIImage(systemName: "calendar")
        
        vc1.title = "Новости"
        vc2.title = "Карта"
        vc3.title = "Расписание"
        
//        tabBar.tintColor = UIColor(rgb: 0x10c092)
//        tabBar.barTintColor = UIColor(rgb: 0x223649)

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
