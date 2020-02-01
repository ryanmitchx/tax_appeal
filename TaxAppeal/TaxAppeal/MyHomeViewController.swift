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

    private var myHomeHeader = UILabel.init()
    private var setAddressButton: UIButton!
    private var addressTF: UITextField!
    private var avgValueLabel = UILabel.init()
    private var keychain: Keychain!
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        return background
        
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor,
                           UIColor.black.withAlphaComponent(0.01).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        return gradient
    }()
    
    override func viewDidLoad() {
        keychain = Keychain(service: "com.brs.TaxAppeal")
        super.viewDidLoad()
        
        myHomeHeader.frame = CGRect(x: 10, y: 0, width: 300, height: 120.0)
        myHomeHeader.text = "\n    My Home's Value"
        myHomeHeader.font = UIFont(name: "Futura-CondensedMedium", size: 40)!
        myHomeHeader.textColor = .white
        
        myHomeHeader.numberOfLines = 0
        myHomeHeader.lineBreakMode = .byWordWrapping
        myHomeHeader.layer.shadowColor = UIColor.black.cgColor
        myHomeHeader.layer.shadowRadius = 3.0
        myHomeHeader.layer.shadowOpacity = 0.8
        myHomeHeader.layer.shadowOffset = CGSize(width: 2, height: 2)
        myHomeHeader.layer.masksToBounds = false
//        self.view.addSubvriew(myHomeHeader)
        
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
        addressTF.returnKeyType = UIReturnKeyType.done
        addressTF.autocorrectionType = .no
        self.addressTF.delegate = self
        view.addSubview(addressTF)
        
        avgValueLabel.text = String(HouseViewController.HomeValues.totalValue / HouseViewController.HomeValues.numHomes)
        avgValueLabel.frame = CGRect(x: 50, y: 115, width: 300, height: 40.0)
        
        view.addSubview(avgValueLabel)
        
        imageView.image = UIImage()
        
        downloadImage(from: URL(string: "https://specials-images.forbesimg.com/imageserve/1026205392/960x0.jpg")!)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        backgroundView.anchorToSuperview()
        backgroundView.addSubview(imageView)
        
        imageView.anchorToSuperview()
        
        backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
        
        imageView.addSubview(myHomeHeader)
        
        // Do any additional setup after loading the view.
        constraintsInit()
        
    }
    
    func constraintsInit(){
        NSLayoutConstraint.activate([
            setAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setAddressButton.topAnchor.constraint(equalTo: addressTF.bottomAnchor, constant: 20),
            setAddressButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            setAddressButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            addressTF.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 50),
            addressTF.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            addressTF.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
//            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        ])
        
        setAddressButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/14).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 4/9).isActive = true
    }
    

    @objc func handleTouchUpInside(sender: UIButton!) {
        if sender == setAddressButton{
            keychain["zip"] = addressTF.text

        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
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
