//
//  PropertyResponse.swift
//  TaxAppeal
//
//  Created by Sangmin  Kim on 2/1/20.
//  Copyright © 2020 BRS. All rights reserved.
//

import Foundation


struct PropertyResponse: Decodable {
    let properties: [Property]
    init(from decoder: Decoder) throws {
        var properties = [Property]()
        var container = try decoder.unkeyedContainer()
        print(container)
        while !container.isAtEnd {
            //print("hello")
            if let house = try? container.decode(Property.self) {
                properties.append(house)
            }else {
                print("else")
            }
        }
        self.properties = properties
    }
}

struct Property: Decodable {
    var propertylocation: String
    var effectiveyearbuilt: String
    var situszip5: String
    var nettaxablevalue: String
    var bedrooms: String
    var bathrooms: String
    var sqftmain: String
    var situsstreet: String
    var situshouseno: String
    var usecodedescchar1: String
    var usecodedescchar2: String
    var usecodedescchar3: String
}

enum PropertyError: Error {
    case dataUnavailable
    case cannotProcessData
}


