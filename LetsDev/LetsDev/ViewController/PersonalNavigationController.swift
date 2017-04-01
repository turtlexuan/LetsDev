//
//  PersonalNavigationController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/4/1.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class PersonalNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initTabBarItem() {
        
//        self.tabBarItem = UITabBarItem(title: nil, image: self.tabBarItem.image?.withRenderingMode(.alwaysOriginal), tag: self.tabBarItem.tag)
        self.tabBarItem = UITabBarItem(title: nil, image: self.tabBarItem.image?.withRenderingMode(.alwaysOriginal), selectedImage: self.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal))
//        self.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
