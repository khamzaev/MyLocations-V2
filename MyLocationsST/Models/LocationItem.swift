//
//  LocationItem.swift
//  MyLocationsST
//
//  Created by khamzaev on 07.02.2026.
//

import Foundation

struct LocationItem: Identifiable, Equatable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let city: String?
    let address: String?
    let createdAt: Date
    
    var name: String
    var category: LocationCategory
    var photoFileName: String?
    
    init(
        id: UUID = UUID(),
        latitude: Double,
        longitude: Double,
        city: String? = nil,
        address: String? = nil,
        createdAt: Date = Date(),
        name: String = "",
        category: LocationCategory = .noCategory,
        photoFileName: String? = nil
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.address = address
        self.createdAt = createdAt
        self.name = name
        self.category = category
        self.photoFileName = photoFileName
    }
    
}

enum LocationCategory: String, CaseIterable, Equatable {
    case noCategory = "No Category"
    case house = "House"
    case work = "Work"
    case park = "Park"
    case store = "Store"
    case bar = "Bar"
}
