//
//  HouseDetailAPIController.swift
//  TaxAppeal
//
//  Created by Sangmin  Kim on 2/1/20.
//  Copyright © 2020 BRS. All rights reserved.
//

import UIKit

class HouseDetailAPIController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PropertyRequest().getProperties { result in
           switch result {
               case .failure(let error):
                   print(error)
               case .success(let properties):
                   let first = properties[0]
                   print(first.propertylocation, first.nettaxablevalue, first.bedrooms)
           }
        }
    }
}
