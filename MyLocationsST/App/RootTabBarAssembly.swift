//
//  RootTabBarAssembly.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import UIKit

enum RootTabBarAssembly {
    static func build() -> UITabBarController {
        let store = CoreDataLocationsStore()
        
        let currentLocation = CurrentLocationAssebmly.build(store: store)
        currentLocation.tabBarItem = UITabBarItem(title: "Current", image: nil, selectedImage: nil)
        
        let locations = LocationsAssembly.build(store: store)
        locations.tabBarItem = UITabBarItem(title: "Locations", image: nil, selectedImage: nil)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [currentLocation, locations]
        return tabBar
    }
}
