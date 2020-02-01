//
//  TabBarController.swift
//  TaxAppeal
//
//  Created by Ryan on 31/01/2020.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit
import CBFlashyTabBarController

class TabBarController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let myHome = ViewController()
        myHome.tabBarItem = UITabBarItem()
        myHome.tabBarItem.title = "My Home"
        myHome.tabBarItem.image = UIImage(named: "my-house") as UIImage?
        let neighborhood = ViewController1()
        neighborhood.tabBarItem = UITabBarItem()
        neighborhood.tabBarItem.title = "Other Homes"
        neighborhood.tabBarItem.image = UIImage(named: "houses") as UIImage?
        let settings = ViewController()
        
        let tbc = CBFlashyTabBarController()
        tbc.viewControllers = [neighborhood, myHome]
        self.view.addSubview(tbc.view)
        print("hello")
//        self.present(tbc, animated: true, completion: nil)
//        let tb1 = BATabBarItem(image: UIImage(named: "houses")!, selectedImage: UIImage(named: "houses-selected")!)
//        let baTabBarController = BATabBarController()
//        baTabBarController.viewControllers = [vc1]
//        baTabBarController.tabBarItems = [tb1]
//        baTabBarController.delegate = self
//        print("hello")
//        self.view.addSubview(baTabBarController.view)
        // Do any additional setup after loading the view.
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
