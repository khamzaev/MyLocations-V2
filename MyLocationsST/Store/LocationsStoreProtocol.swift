//
//  LocationsStoreProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 07.02.2026.
//

import Foundation

protocol LocationsStoreProtocol: AnyObject {
    func fetchAll() -> [LocationItem]
    func save(_ item: LocationItem)
    func delete(id: UUID)
}
