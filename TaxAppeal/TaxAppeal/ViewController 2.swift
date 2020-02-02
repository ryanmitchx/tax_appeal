//
//  ViewController.swift
//  TaxAppeal
//
//  Created by Ryan on 31/01/2020.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit

weak var button: UIButton!
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.s
//        button.frame = CGRect(x:3, y:318, width: view.bounds.width-5, height: 30)
        let title = UITextView()
        
        var example: String = "-How to Appeal the Reassessment? \nWebsites to visit: http://bos.lacounty.gov/Services/Assessment-Appeals\n\n-Online Application\nhttps://lacaab.lacounty.gov/Home.aspx\n\n-Form: http://bos.lacounty.gov/LinkClick.aspx?fileticket=rbWMgcSxraE%3d&portalid=1"
        
        let attributedString = NSMutableAttributedString(string: "-How to Appeal the Reassessment?\n Click Here")
               attributedString.addAttribute(.link, value: "http://bos.lacounty.gov/Services/Assessment-Appeals", range: NSRange(location: 32, length: 12))
        
  
       

              
        
        
        
        
        
        title.attributedText = attributedString
        title.font = UIFont(name: "Avenir-Light", size: 16)
        title.frame = CGRect(x: 20,y: 50,width: self.view.bounds.size.width, height: self.view.bounds.size.height) // x , y, width , height
        
       
        self.view.addSubview(title)
        
        
    }
    

}
