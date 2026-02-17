//
//  LocationsViewProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import Foundation

protocol LocationsViewProtocol: BaseViewProtocol {
    func showTitle(_ text: String)
    func showItems(_ items: [LocationItem])
    func showEmptyState()
}
