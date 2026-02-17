//
//  LocationPresenterProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import Foundation

protocol LocationsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func deleteItem(at index: Int)
}
