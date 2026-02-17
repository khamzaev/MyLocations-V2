//
//  TagLocationEditorAssembly.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import UIKit

enum TagLocationEditorAssembly {
    
    static func build(
        item: LocationItem,
        store: LocationsStoreProtocol,
        output: TagLocationEditorOutput
    ) -> UIViewController {
        
        let viewController = TagLocationEditorViewController()
        
        let presenter = TagLocationEditorPresenter (
            view: viewController,
            item: item,
            store: store,
            output: output
        )
        
        viewController.presenter = presenter
        
        let nav = UINavigationController(rootViewController: viewController)
        
        return nav
    }
}
