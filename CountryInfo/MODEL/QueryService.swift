//
//  QueryService.swift
//  CountryInfo
//
//  Created by fred on 30/04/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import Foundation
import UIKit

class QueryService {

    static var shared = QueryService()
    private init()
    {}

    func getCountryDetails(domain: String, callback: @escaping(Result<[CountryData], CountryError>) -> Void) {
        let firstUrl = "https://restcountries.eu/rest/v2/name/"
        let pathName = String(firstUrl + domain)
        let Url = pathName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: Url)!

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {

                guard let data = data, error == nil else {
                    callback(.failure(.missingData))
                    return
                    }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(.missingData))
                    return
                    }
                do {
                    let countryData = try JSONDecoder().decode([CountryData].self, from: data)
                    callback(.success(countryData))
print("[countryData]", countryData)
                } catch {
                    callback(.failure(.cannotProcessData))
                }
            }
        } .resume()
    }
}
