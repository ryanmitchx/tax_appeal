//
//  MyHomeViewController.swift
//  TaxAppeal
//
//  Created by Ryan on 01/02/2020.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit
import KeychainAccess

class MyHomeViewController: UIViewController {

    var setAddressButton: UIButton!
    var addressTF: UITextField!
    var keychain: Keychain!
    
    override func viewDidLoad() {
        keychain = Keychain(service: "com.brs.TaxAppeal")
        super.viewDidLoad()
        view.backgroundColor = .white
        setAddressButton = UIButton(type: .system)
        setAddressButton.setTitle("Set Address", for: .normal)
        setAddressButton.layer.cornerRadius = 5
        setAddressButton.layer.borderWidth = 1
        setAddressButton.layer.borderColor = UIColor(red: 255/255, green: 151/255, blue: 164/255, alpha: 1).cgColor
        setAddressButton.setTitleColor(.black, for: .normal)
        setAddressButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(setAddressButton)
        setAddressButton.addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
        
        addressTF = UITextField(frame: .zero)
        var addressTFPlaceholder = NSMutableAttributedString()
        addressTFPlaceholder = NSMutableAttributedString(attributedString: NSAttributedString(string: "address", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), ]))
        addressTF.attributedPlaceholder = addressTFPlaceholder
        addressTF.borderStyle = .roundedRect
        addressTF.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2)
        addressTF.translatesAutoresizingMaskIntoConstraints = false
        addressTF.returnKeyType = UIReturnKeyType.next
        addressTF.autocorrectionType = .no
        addressTF.autocapitalizationType = .none
        self.addressTF.delegate = self
        view.addSubview(addressTF)
        
        
        // Do any additional setup after loading the view.
        constraintsInit()
    }
    
    func constraintsInit(){
        NSLayoutConstraint.activate([
            setAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setAddressButton.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            setAddressButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            setAddressButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            addressTF.bottomAnchor.constraint(equalTo: setAddressButton.topAnchor, constant: -20),
            addressTF.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            addressTF.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
        ])
        setAddressButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/14).isActive = true
    }
    

    @objc func handleTouchUpInside(sender: UIButton!) {
        if sender == setAddressButton{
            keychain["address"] = addressTF.text
        }
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

extension MyHomeViewController: UITextFieldDelegate{
    
    
}
