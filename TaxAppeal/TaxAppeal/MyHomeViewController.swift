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
    
    var toolBar: UIToolbar!
    var editButton: UIBarButtonItem!
    private var myHomeHeader = UILabel.init()
    private var infoLabel = UILabel.init()
    private var addressLabel = UILabel.init()
    private var avgValueLabel = UILabel.init()
    private var minLabel = UILabel.init()
    private var maxLabel = UILabel.init()
    private var gaugeLabel = UILabel.init()
    private var assessedValue: Int = 0
    private var keychain: Keychain!
    private var attributedText = NSMutableAttributedString(string: ("Assessed Value: $"), attributes: NSAttributedString.Key.assessValue)
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
        
        
        //        avgValueLabel.text = String(HouseViewController.HomeValues.totalValue / HouseViewController.HomeValues.numHomes)
        //        avgValueLabel.frame = CGRect(x: 50, y: 115, width: 300, height: 40.0)
        
        //        view.addSubview(avgValueLabel)
        
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
        
        let gaugeLabelString = NSMutableAttributedString(string: "Your Assessed Value, Compared:\n", attributes: NSAttributedString.Key.assessValue)
        gaugeLabelString.append(NSMutableAttributedString(string: "Are you above or below the average?", attributes: NSAttributedString.Key.subtitle))
        gaugeLabel.attributedText = gaugeLabelString
        gaugeLabel.numberOfLines = 0
        
        view.addSubview(gaugeLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gauge.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.setBackgroundImage(UIImage(),
                                   forToolbarPosition: .any,
                                   barMetrics: .default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(handleTouchUpInside))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var items = [UIBarButtonItem]()
        items.append(flexibleSpace)
        items.append(self.editButton)
        self.toolBar.setItems(items, animated: true)
        
        view.addSubview(toolBar)
        
        //        var address: String = "pleasesir"
        
        var propertyAddress = keychain["address"]?.uppercased() ?? "5448%206TH%20AVE%20%20LOS%20ANGELES%20CA%20%2090043"
        if(propertyAddress == ""){
            propertyAddress = "5448%206TH%20AVE%20%20LOS%20ANGELES%20CA%20%2090043"
        }
        else{
            propertyAddress = propertyAddress.trimmingCharacters(in: .whitespacesAndNewlines)
            propertyAddress = propertyAddress.replacingOccurrences(of: ",", with: "%20")
            propertyAddress = propertyAddress.replacingOccurrences(of: " ", with: "%20")
        }
        print(propertyAddress)
        PropertyRequest().getDetailsOfAddress(addressString: propertyAddress){ result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let properties):
                if(properties.count < 1){
                    print("there is an error")
                }
                else{
                    let myProperty: Property = properties[0]
                    DispatchQueue.main.sync{
                        self.keychain["beds"] = myProperty.bedrooms
                        self.keychain["baths"] = myProperty.bathrooms
                        self.assessedValue = Int(myProperty.nettaxablevalue)!
                        self.attributedText.append(NSMutableAttributedString(string: "\(myProperty.nettaxablevalue).00", attributes: NSAttributedString.Key.assessValue))
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 1.5
                        paragraphStyle.lineBreakMode = .byTruncatingTail
                        self.attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.attributedText.length))
                        self.attributedText.append(NSMutableAttributedString(string: "\n\(myProperty.bedrooms) bedrooms, \(myProperty.bathrooms) bathrooms", attributes: NSAttributedString.Key.assessValue))
                        let attribAddr = NSMutableAttributedString(string: "\(myProperty.situshouseno) \(myProperty.situsstreet.upperCamelCase), \(myProperty.taxratearea_city.upperCamelCase), CA \(myProperty.situszip5)", attributes: NSAttributedString.Key.addr)
                        self.addressLabel.attributedText = attribAddr
                        self.infoLabel.attributedText = self.attributedText
                        print(HouseViewController.HomeValues.numHomes)
                        if(HouseViewController.HomeValues.numHomes>1){
                            self.gauge.maxValue = CGFloat(HouseViewController.HomeValues.totalValue/HouseViewController.HomeValues.numHomes*2)
                            var newRate = CGFloat(self.assessedValue)
                            if(newRate < 0){
                                HouseViewController.HomeValues.minValue = self.assessedValue
                                newRate = 0
                            }
                            self.gauge.animateRate(0.5, newValue: newRate) { (finished) in
                                print("Gauge animation completed !")
                            }
                        }
                        else{
                            self.gauge.rate = 0
                            self.gauge.maxValue = 1
                            
                        }
                    }
                }
                
            }
        }
        
        view.addSubview(addressLabel)
        infoLabel.attributedText = attributedText
        
        minLabel.textAlignment = .center
        maxLabel.textAlignment = .center
        
        view.addSubview(infoLabel)
        view.addSubview(minLabel)
        view.addSubview(maxLabel)
        
        gauge.type = .left
        gauge.rotate = 5
        gauge.lineWidth = 25
        gauge.alpha = 1
        gauge.colorsArray = [UIColor.green, UIColor.yellow, UIColor.red]
        view.addSubview(gauge)
        
        gaugeLabel.translatesAutoresizingMaskIntoConstraints = false
        gaugeLabel.textAlignment = .center
        
        constraintsInit()
    }
    
    func updateView(){
        attributedText = NSMutableAttributedString(string: ("Assessed Value: $"), attributes: NSAttributedString.Key.assessValue)
        var propertyAddress = try? keychain.get("address")
        if(propertyAddress == nil || propertyAddress == ""){
            propertyAddress = "5448%206TH%20AVE%20%20LOS%20ANGELES%20CA%20%2090043"
        }
        else{
            propertyAddress = propertyAddress?.uppercased()
            propertyAddress = propertyAddress?.trimmingCharacters(in: .whitespacesAndNewlines)
            propertyAddress = propertyAddress?.replacingOccurrences(of: ",", with: "%20")
            propertyAddress = propertyAddress?.replacingOccurrences(of: " ", with: "%20")
        }
//        print(propertyAddress)
        PropertyRequest().getDetailsOfAddress(addressString: propertyAddress ?? "5448%206TH%20AVE%20%20LOS%20ANGELES%20CA%20%2090043"){ result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let properties):
                if(properties.count < 1){
                    print("there is an error")
                }
                else{
                    let myProperty: Property = properties[0]
                    DispatchQueue.main.sync{
                        self.keychain["beds"] = myProperty.bedrooms
                        self.keychain["baths"] = myProperty.bathrooms
                        self.assessedValue = Int(myProperty.nettaxablevalue)!
                        self.attributedText.append(NSMutableAttributedString(string: "\(myProperty.nettaxablevalue).00", attributes: NSAttributedString.Key.assessValue))
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 1.5
                        paragraphStyle.lineBreakMode = .byTruncatingTail
                        self.attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.attributedText.length))
                        self.attributedText.append(NSMutableAttributedString(string: "\n\(myProperty.bedrooms) bedrooms, \(myProperty.bathrooms) bathrooms", attributes: NSAttributedString.Key.assessValue))
                        let attribAddr = NSMutableAttributedString(string: "\(myProperty.situshouseno) \(myProperty.situsstreet.upperCamelCase), \(myProperty.taxratearea_city.upperCamelCase), CA \(myProperty.situszip5)", attributes: NSAttributedString.Key.addr)
                        self.addressLabel.attributedText = attribAddr
                        self.infoLabel.attributedText = self.attributedText
                        print(HouseViewController.HomeValues.numHomes)
                        if(HouseViewController.HomeValues.numHomes>1){
                            self.gauge.maxValue = CGFloat(HouseViewController.HomeValues.totalValue/HouseViewController.HomeValues.numHomes*2)
                            var newRate = CGFloat(self.assessedValue)
                            if(newRate < 0){
                                HouseViewController.HomeValues.minValue = self.assessedValue
                                newRate = 0
                            }
                            else if(newRate > self.gauge.maxValue){
                                newRate = self.gauge.maxValue
                            }
                            self.gauge.animateRate(0.5, newValue: newRate) { (finished) in
                                print("Gauge animation completed !")
                            }
                        }
                        else{
                            self.gauge.rate = 0
                            self.gauge.maxValue = 1
                        }
                    }
                }
                
            }
        }
    }
    
    func constraintsInit(){
        NSLayoutConstraint.activate([
            
            infoLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 15),
            
            addressLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            addressLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 5),
            
            gauge.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            gauge.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 120),
            
            minLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            minLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            maxLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            maxLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            gaugeLabel.bottomAnchor.constraint(equalTo: gauge.topAnchor, constant: 40),
            gaugeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            gaugeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),

        ])
        let guide = self.view.safeAreaLayoutGuide
        toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        toolBar.topAnchor.constraint(equalTo: guide.topAnchor, constant: 15).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        gauge.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 3/4).isActive = true
        gauge.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/5).isActive = true
        
        backgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 7/18).isActive = true
    }
    
    @objc func handleTouchUpInside(sender: UIButton!) {
        print("handle touch")
        if sender == editButton{
            let editVC = EditHomeViewController()
            self.present(editVC, animated: true, completion: nil)
        }
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL){
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if(HouseViewController.HomeValues.minValue == Int.max){
            minLabel.isHidden = true
        }else{
            minLabel.isHidden = false
            minLabel.text = String("$\(HouseViewController.HomeValues.minValue)")
        }
        if(HouseViewController.HomeValues.maxValue == 0){
            maxLabel.isHidden = true
        }else{
            maxLabel.isHidden = false
            maxLabel.text = String("$\(HouseViewController.HomeValues.maxValue)")
        }
        
        
        print(HouseViewController.HomeValues.numHomes)
        if(HouseViewController.HomeValues.numHomes>1){
            gauge.maxValue = CGFloat(HouseViewController.HomeValues.totalValue/HouseViewController.HomeValues.numHomes*2)
            var newRate = CGFloat(self.assessedValue)
            print("The new rate is1: \(newRate)")
            if(newRate < 0){
                HouseViewController.HomeValues.minValue = self.assessedValue
                newRate = 0
            }
            else if(newRate > gauge.maxValue){
                newRate = gauge.maxValue
            }
            self.gauge.animateRate(0.5, newValue: newRate) { (finished) in
                print("Gauge animation completed !")
            }
        }
        else{
            gauge.maxValue = 1
            gauge.rate = 0
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
    
    static var subtitle: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Baskerville-Italic", size: 16)!,
        NSAttributedString.Key.foregroundColor: UIColor.black,
    ]
    
    
    
}
