//
//  PropertyRequest.swift
//  TaxAppeal
//
//  Created by Sangmin  Kim on 2/1/20.
//  Copyright © 2020 BRS. All rights reserved.
//

import Foundation

class PropertyRequest: Decodable {
    var requestUrl: String = "https://data.lacounty.gov/resource/mk7y-hq5p.json?"
    
    func getSimilarHomes(zip: String, bedrooms: Int = 0, bathrooms: Int = 0, completionHandler: @escaping(Result<[Property], PropertyError>) -> Void)
    {
        let requestUrl1 = "\(requestUrl)situszip5=\(zip)&bedrooms=\(bedrooms)&bathrooms=\(bathrooms)&usecodedescchar1=Residential"
        URLSession.shared.dataTask(with: URL(string: requestUrl1)!) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.dataUnavailable))
                return
            }
            do {
                let results = try JSONDecoder().decode(PropertyResponse.self, from: data)
                completionHandler(.success(results.properties))
            }catch {
//                completionHandler(.failure(.cannotProcessData))
            }
        }.resume()
    }
    
    func getDetailsOfAddress(addressString: String, completionHandler: @escaping(Result<[Property], PropertyError>) -> Void)
    {
        let requestUrl1 = "\(requestUrl)&propertylocation=\(addressString)"
        URLSession.shared.dataTask(with: URL(string: requestUrl1)!) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.dataUnavailable))
                return
            }
            do {
                let results = try JSONDecoder().decode(PropertyResponse.self, from: data)
                completionHandler(.success(results.properties))
            }catch {
//                completionHandler(.failure(.cannotProcessData))
            }
        }.resume()
    }
    
    func  getProperties(myHouse: Property, completionHandler: @escaping(Result<[Property], PropertyError>) -> Void)
    {
        let requestUrl2 = requestUrl + "situszip5=" + myHouse.situszip5 + "&bedrooms=" + myHouse.bedrooms + "&bathrooms" + myHouse.bathrooms
        URLSession.shared.dataTask(with: URL(string: requestUrl2)!) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.dataUnavailable))
                return
            }
            do {
                let results = try JSONDecoder().decode(PropertyResponse.self, from: data)
                completionHandler(.success(results.properties))
            }catch {
                completionHandler(.failure(.cannotProcessData))
            }
        }.resume()
    }
}

