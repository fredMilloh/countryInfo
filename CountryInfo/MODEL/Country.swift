//
//  Country.swift
//  CountryInfo
//
//  Created by fred on 30/04/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import Foundation
import UIKit

struct CountryData: Decodable {
    var name: String
    var capital: String
    var region: String
    var subregion: String
    var population: Int
    var currencies: [CurrencyData]
    var languages: [LanguageData]
    var flag: String
    }

struct LanguageData: Decodable {
    var name: String
}

struct CurrencyData: Decodable {
        var name: String
        var symbol: String?
    }

enum CountryError: Error {
    case missingData
    case cannotProcessData
}

