//
//  AppTabBarController.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import UIKit

final class AppTabBarController: UITabBarController {
    static func make() -> UITabBarController {
        let store = CoreDataLocationsStore()
        let tabBar = AppTabBarController()
        
        let currentNav = CurrentLocationAssebmly.build(store: store)
        currentNav.tabBarItem = UITabBarItem(title: "Tag", image: UIImage(systemName: "tag"), tag: 0)
        
        let locationsNav = LocationsAssembly.build(store: store )
        locationsNav.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let map = MapViewController.make()
        let mapNav = UINavigationController(rootViewController: map)
        mapNav.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 2)
        
        tabBar.viewControllers = [currentNav, locationsNav, mapNav]
        return tabBar
    }
}
