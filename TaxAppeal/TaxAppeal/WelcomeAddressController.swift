//
//  EditHomeViewController.swift
//  TaxAppeal
//
//  Created by Ryan on 01/02/2020.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit
import KeychainAccess
import CBFlashyTabBarController

class WelcomeAddressController: UIViewController {
    
    private var setAddressButton: UIButton!
    private var addressTF: UITextField!
    private var keychain = Keychain(service: "com.brs.TaxAppeal")
    var toolBar: UIToolbar!
    var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar = UIToolbar()
        toolBar.isTranslucent = true
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
        addressTFPlaceholder = NSMutableAttributedString(attributedString: NSAttributedString(string: "2618 Ellendale Pl, Los Angeles CA, 90007", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), ]))
        addressTF.attributedPlaceholder = addressTFPlaceholder
        addressTF.borderStyle = .roundedRect
        addressTF.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2)
        addressTF.translatesAutoresizingMaskIntoConstraints = false
        addressTF.returnKeyType = UIReturnKeyType.done
        addressTF.autocorrectionType = .no
        self.addressTF.delegate = self
        view.addSubview(addressTF)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(handleTouchUpInside))
        var items = [UIBarButtonItem]()
        items.append(flexibleSpace)
        items.append(doneButton)
        toolBar.setItems(items, animated: true)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        view.addSubview(toolBar)
        constraintsInit()
        // Do any additional setup after loading the view.
    }
    
    func constraintsInit(){
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            toolBar.topAnchor.constraint(equalTo: guide.topAnchor),
            
            setAddressButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            setAddressButton.topAnchor.constraint(equalTo: addressTF.bottomAnchor, constant: 20),
            setAddressButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            setAddressButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            addressTF.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            addressTF.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            addressTF.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20)
            ]
        )
        setAddressButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/14).isActive = true

    }
    
    @objc func handleTouchUpInside(sender: UIButton!) {
        print("handle touch")
        if sender == setAddressButton{
            keychain["address"] = addressTF.text
            let addressTest = addressTF.text
            if(addressTest != ""){
                print("in if")
                let addrSplit = addressTest?.split(separator: " ")
                let zip: String = String(addrSplit?[(addrSplit?.count ?? 8)-1] ?? "null")
                keychain["zip"] = zip
            }
        }
        else if sender == doneButton{
            let tbc = self.presentingViewController as! CBFlashyTabBarController
            let hvc = tbc.viewControllers![0] as! HouseViewController
            hvc.updateCards()
//            let mhc = tbc.viewControllers![1] as! MyHomeViewController
            let propertyAddress = try? keychain.get("address")
//            PropertyRequest().getDetailsOfAddress(addressString: propertyAddress ?? "5448%206TH%20AVE%20%20LOS%20ANGELES%20CA%20%2090043"){ result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let properties):
//                if(properties.count < 1){
//                    print("there is an error")
//                }
//                else{
//                    let myProperty: Property = properties[0]
//                    DispatchQueue.main.sync{
//                        self.keychain["beds"] = myProperty.bedrooms
//                        self.keychain["baths"] = myProperty.bathrooms
//                    }
//                }
//                }
//            }
            
//            mhc.updateView()
            self.dismiss(animated: true, completion: nil)
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

extension EditHomeViewController: UITextFieldDelegate{
    
    
}


