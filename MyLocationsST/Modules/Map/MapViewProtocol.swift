//
//  MapViewProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import Foundation
import CoreLocation

protocol MapViewProtocol: AnyObject {
    func showTitle(_ text: String)
    func showLocations(_ locations: [LocationItem])
    func openEditor(for item: LocationItem)
    func setUserLocationVisible(_ isVisible: Bool)
    func setUserTrackingEnabled(_ enabled: Bool)
    func centerOnUser()
}
