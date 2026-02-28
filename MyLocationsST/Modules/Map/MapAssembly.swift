//
//  MapAssembly.swift
//  MyLocationsST
//
//  Created by khamzaev on 24.02.2026.
//

import UIKit

enum MapAssembly {
    
    static func build(store: LocationsStoreProtocol) -> UIViewController {
        let vc = MapViewController()
        let presenter = MapPresenter(view: vc, store: store)
        vc.presenter = presenter
        vc.store = store
        return vc
    }
}

