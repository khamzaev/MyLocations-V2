//
//  CurrentLocationAssembly.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import UIKit

enum CurrentLocationAssebmly {
    
    static func build(store: LocationsStoreProtocol) -> UIViewController {
        let vc = CurrentLocationViewController()
        let presenter = CurrentLocationPresenter(view: vc, store: store)
        vc.presenter = presenter
        return UINavigationController(rootViewController: vc)
    }
}
