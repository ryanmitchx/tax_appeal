//
//  ViewController.swift
//  TaxAppeal
//
//  Created by Ryan on 31/01/2020.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit

class ActionController: UIViewController {
    
    private let actionHeader = UILabel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        actionHeader.frame = CGRect(x: 10, y: 0, width: 300, height: 120.0)
        actionHeader.text = "\n    Take Action"
        actionHeader.font = UIFont(name: "Futura-CondensedMedium", size: 40)!
        actionHeader.textColor = .black
        
        actionHeader.numberOfLines = 0
        actionHeader.lineBreakMode = .byWordWrapping
//        actionHeader.layer.shadowColor = UIColor.black.cgColor
//        actionHeader.layer.shadowRadius = 3.0
//        actionHeader.layer.shadowOpacity = 0.8
//        actionHeader.layer.shadowOffset = CGSize(width: 2, height: /2)
        actionHeader.layer.masksToBounds = false
        self.view.addSubview(actionHeader)
        let title = UITextView()
        
        //                var example: String = "-How to Appeal the Reassessment? \nWebsites to visit: http://bos.lacounty.gov/Services/Assessment-Appeals\n\n-Online Application\nhttps://lacaab.lacounty.gov/Home.aspx\n\n-Form: http://bos.lacounty.gov/LinkClick.aspx?fileticket=rbWMgcSxraE%3d&portalid=1"
        
        let attributedString = NSMutableAttributedString(string: "How to Appeal the Reassessment?\nClick Here")
        attributedString.addAttribute(.link, value: "http://bos.lacounty.gov/Services/Assessment-Appeals", range: NSRange(location: 32, length: 10))
        
        
        
        
        
        
        
        
        
        
        title.attributedText = attributedString
        title.font = UIFont(name: "Avenir-Light", size: 16)
        title.frame = CGRect(x: 20,y: 150,width: self.view.bounds.size.width, height: self.view.bounds.size.height) // x , y, width , height
        
        
        self.view.addSubview(title)
    }
    
    
}

