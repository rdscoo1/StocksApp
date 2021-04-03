//
//  Company.swift
//  StocksApp
//
//  Created by Roman Khodukin on 4/2/21.
//

import Foundation

struct Company: Decodable {
    let symbol: String
    let companyName: String
    let exchange: String
    let industry: String
    let website: String
    let description: String
    let ceo: String
    let sector: String
    let employees: Int?
    let address: String
    let state: String
    let city: String
    let zip: String
    let country: String
    let phone: String

    enum CodingKeys: String, CodingKey {
        case symbol, companyName, exchange, industry, website, description, sector, employees, address, state, city, zip, country, phone
        case ceo = "CEO"
    }
}
