//
//  CategoryPickerOutput.swift
//  MyLocationsST
//
//  Created by khamzaev on 20.02.2026.
//

import Foundation

protocol CategoryPickerOutput: AnyObject {
    func categoryPickerDidSelect(_ category: LocationCategory)
}
