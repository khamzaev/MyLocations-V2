//
//  TagLocationEditorPresenterProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 07.02.2026.
//

import Foundation

protocol TagLocationEditorPresenterProtocol: AnyObject {
    func viewDidLoad()
    func onSaveTapped(name: String, category: LocationCategory)
}
