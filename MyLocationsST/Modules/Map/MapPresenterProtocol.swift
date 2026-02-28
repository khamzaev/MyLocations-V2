//
//  MapPresenterProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 24.02.2026.
//

import Foundation
import CoreLocation

protocol MapPresenterProtocol: AnyObject {
    func viewDidLoad()
    func onAnnotationSelected(id: UUID)
    func reload()
    func onCenterOnUserTapped()
}
