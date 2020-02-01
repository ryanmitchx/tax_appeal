//
//  PropertyRequest.swift
//  TaxAppeal
//
//  Created by Sangmin  Kim on 2/1/20.
//  Copyright © 2020 BRS. All rights reserved.
//

import Foundation

struct PropertyRequest {
    let requestUrl: URL
    
    init() {
        self.requestUrl = URL(string: "https://data.lacounty.gov/resource/mk7y-hq5p.json?situszip=90007")!
        
    }
    
    func getProperties(completionHandler: @escaping(Result<[Property], PropertyError>) -> Void)
    {
        URLSession.shared.dataTask(with: self.requestUrl) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.dataUnavailable))
                return
            }
            do {
                print("hi")
                let results = try JSONDecoder().decode(Results.self, from: data)
                completionHandler(.success(results.properties))
            }catch {
                completionHandler(.failure(.cannotProcessData))
            }
        }.resume()
    }
}

