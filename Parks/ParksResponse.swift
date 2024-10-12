//
//  ParksResponse.swift
//  Parks
//
//  Created by Lou-Michael Salvant on 10/12/24.
//

import Foundation

struct ParksResponse: Codable {
    let data: [Park]
}

struct Park: Codable, Identifiable {
    let id: String
    let fullName: String
    let description: String
    let latitude: String
    let longitude: String
    let images: [ParkImage]
    let name: String
}

struct ParkImage: Codable {
    let title: String
    let caption: String
    let url: String
}

extension Park {
    static var mocked: Park {
        let jsonUrl = Bundle.main.url(forResource: "park_mock", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        let park = try! JSONDecoder().decode(Park.self, from: data)
        return park
    }
} 
