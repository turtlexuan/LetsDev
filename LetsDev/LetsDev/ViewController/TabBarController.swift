//
//  TabBarController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/1.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // swiftlint:disable force_cast
        // Do any additional setup after loading the view.
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let itemIndex = 2
        let bgColor = UIColor.black

        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let bgView = UIView(frame: CGRect(x: CGFloat(itemIndex) * itemWidth, y: 0, width: itemWidth, height: tabBar.frame.height))
        bgView.backgroundColor = bgColor
        tabBar.insertSubview(bgView, at: 2)

        let personalVC = self.viewControllers?[0] as! PersonalNavigationController
        personalVC.initTabBarItem()

        let newDevVc = self.viewControllers?[2] as! NewDevNavigationController
        newDevVc.initTabBarItem()

        let favoriteVC = self.viewControllers?[1] as! FavoriteNavigationController
        favoriteVC.initTabBarItem()

        let alertVC = self.viewControllers?[3] as! AlertNavigationController
        alertVC.initTabBarItem()

        let homeVC = self.viewControllers?[4] as! HomeNavigationController
        homeVC.initTabBarItem()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            let newDevNavigation = self.storyboard?.instantiateViewController(withIdentifier: "NewDevNavigationController")
            self.present(newDevNavigation!, animated: true, completion: nil)
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            return false
        } else {
            return true
        }

    }
}
