//
//  MyHomeViewController.swift
//  TaxAppeal
//
//  Created by Ryan on 01/02/2020.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit
import KeychainAccess
import GaugeKit

class MyHomeViewController: UIViewController {
    
    private var myHomeHeader = UILabel.init()
    private var setAddressButton: UIButton!
    private var addressTF: UITextField!
    private var infoLabel = UILabel.init()
    private var addressLabel = UILabel.init()
    private var avgValueLabel = UILabel.init()
    private var keychain: Keychain!
    private let attributedText = NSMutableAttributedString(string: ("Assessed Value: $"), attributes: NSAttributedString.Key.assessValue)
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
    private let gauge = Gauge()

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
        backgroundView.applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
        backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
        
        gradientLayer.frame = CGRect(x: 0, y: 0,
                                     width: view.frame.size.width,
                                     height: view.frame.size.height * 0.4)
        
        view.addSubview(myHomeHeader)
        
        // Do any additional setup after loading the view.
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 0
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        gauge.type = .right
        gauge.colorsArray = [UIColor.red, UIColor.orange, UIColor.yellow ,UIColor.green]
        gauge.rate = 2
        gauge.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gauge)
        
//        var address: String = "pleasesir"
        PropertyRequest().getDetailsOfAddress(addressString: "5448%206TH%20AVE%20%20LOS%20ANGELES%20CA%20%2090043"){ result in
          switch result {
            case .failure(let error):
                print(error)
            case .success(let properties):
                let myProperty: Property = properties[0]
                DispatchQueue.main.async{
                    self.attributedText.append(NSMutableAttributedString(string: "\(myProperty.nettaxablevalue).00", attributes: NSAttributedString.Key.assessValue))
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 1.5
                    paragraphStyle.lineBreakMode = .byTruncatingTail
                    self.attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.attributedText.length))
                    self.attributedText.append(NSMutableAttributedString(string: "\n\(myProperty.bedrooms) bedrooms, \(myProperty.bathrooms) bathrooms", attributes: NSAttributedString.Key.assessValue))
                    let attribAddr = NSMutableAttributedString(string: "\(myProperty.situshouseno) \(myProperty.situsstreet.upperCamelCase), \(myProperty.taxratearea_city.upperCamelCase), CA \(myProperty.situszip5)", attributes: NSAttributedString.Key.addr)
                    self.addressLabel.attributedText = attribAddr
                    self.infoLabel.attributedText = self.attributedText
                }
//                address = myProperty.propertylocation.upperCamelCase
            }
        }
        
        view.addSubview(addressLabel)
        infoLabel.attributedText = attributedText
        
        view.addSubview(infoLabel)
        constraintsInit()
        
    }
    
    func constraintsInit(){
        NSLayoutConstraint.activate([
            setAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setAddressButton.topAnchor.constraint(equalTo: addressTF.bottomAnchor, constant: 20),
            setAddressButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            setAddressButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            addressTF.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 150),
            addressTF.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            addressTF.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),

            infoLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 15),
            
            addressLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            addressLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 5),
            
            gauge.topAnchor.constraint(equalTo: setAddressButton.bottomAnchor, constant: -20)
        ])
        gauge.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/4).isActive = true
        setAddressButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/14).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 7/18).isActive = true
    }
    
    
    @objc func handleTouchUpInside(sender: UIButton!) {
        if sender == setAddressButton{
            keychain["address"] = addressTF.text
            
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

extension String {
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    var upperCamelCase: String {
        return self.lowercased()
            .split(separator: " ")
            .map { return $0.lowercased().capitalizeFirstLetter() }
            .joined(separator: " ")
    }
    
    var lowerCamelCase: String {
        let upperCased = self.upperCamelCase
        return upperCased.prefix(1).lowercased() + upperCased.dropFirst()
    }
}

extension NSAttributedString.Key {
    
    static var assessValue: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 18)!,
        NSAttributedString.Key.foregroundColor: UIColor.black,
    ]
    
    static var addr: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 16)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
    ]
    
}
