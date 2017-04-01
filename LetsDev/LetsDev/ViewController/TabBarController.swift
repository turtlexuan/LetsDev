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

        let itemIndex = 1
        let bgColor = UIColor.black

        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let bgView = UIView(frame: CGRect(x: CGFloat(itemIndex) * itemWidth, y: 0, width: itemWidth, height: tabBar.frame.height))
        bgView.backgroundColor = bgColor
        tabBar.insertSubview(bgView, at: 1)

        let newDevVc = self.viewControllers?[1] as! NewDevNavigationController
        newDevVc.initTabBarItem()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let newDevNavigation = self.storyboard?.instantiateViewController(withIdentifier: "NewDevNavigationController")
            self.present(newDevNavigation!, animated: true, completion: nil)
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            return false
        } else {
            return true
        }

    }
}
