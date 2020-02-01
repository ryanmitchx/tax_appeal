//
//  TabBarController.swift
//  TaxAppeal
//
//  Created by Ryan on 31/01/2020.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit
import CBFlashyTabBarController
import Koloda

class TabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tb1 = BATabBarItem(image: UIImage(named: "houses")!, selectedImage: UIImage(named: "houses-selected")!)
//        let baTabBarController = BATabBarController()
//        baTabBarController.viewControllers = [vc1]
//        baTabBarController.tabBarItems = [tb1]
//        baTabBarController.delegate = self
//        print("hello")
//        self.view.addSubview(baTabBarController.view)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let neighborhood = ViewController()
        neighborhood.tabBarItem = UITabBarItem()
        neighborhood.tabBarItem.title = "Neighborhood"
        neighborhood.tabBarItem.image = UIImage(named: "houses") as UIImage?
        let myHome = ViewController1()
        myHome.tabBarItem = UITabBarItem()
        myHome.tabBarItem.title = "My Home"
        myHome.tabBarItem.image = UIImage(named: "my-house") as UIImage?
        let settings = ViewController()
        settings.tabBarItem = UITabBarItem()
        settings.tabBarItem.title = "Settings"
        settings.tabBarItem.image = UIImage(systemName: "gear")
        let tbc = CBFlashyTabBarController()
        tbc.viewControllers = [neighborhood, myHome, settings]
        print("hello")
        tbc.modalPresentationStyle = .fullScreen
        self.present(tbc, animated: false, completion: nil)
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
