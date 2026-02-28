//
//  LocationsAssembly.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import UIKit

enum LocationsAssembly {
     
    static func build(store: LocationsStoreProtocol) -> UIViewController {
        let vc = LocationsViewController()
        let presenter = LocationsPresenter(view: vc, store: store)
        vc.presenter = presenter
        vc.store = store
        return UINavigationController(rootViewController: vc)
    }
}
