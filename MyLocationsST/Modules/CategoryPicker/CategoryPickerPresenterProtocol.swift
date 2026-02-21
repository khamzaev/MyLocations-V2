//
//  CategoryPickerPresenterProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 20.02.2026.
//

import Foundation

protocol CategoryPickerPresenterProtocol: AnyObject {
    var numberOfCategories: Int { get }
    func category(at index: Int) -> LocationCategory
    func isSelected(_ category: LocationCategory) -> Bool
    func didSelectCategory(at index: Int)
}
