//
//  LocationAnnotation.swift
//  MyLocationsST
//
//  Created by khamzaev on 26.02.2026.
//

import MapKit

final class LocationAnnotation: MKPointAnnotation {
    let id: UUID
    
    init(id: UUID) {
        self.id = id
        super.init()
    }
}
