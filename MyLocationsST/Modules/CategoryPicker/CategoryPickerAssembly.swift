//
//  CategoryPickerAssembly.swift
//  MyLocationsST
//
//  Created by khamzaev on 19.02.2026.
//

import UIKit

enum CategoryPickerAssembly {
    static func build(
        selected: LocationCategory,
        output: CategoryPickerOutput
    ) -> UIViewController {
        let vc = CategoryPickerViewController()
        let presenter = CategoryPickerPresenter(view: vc, selected: selected, output: output)
        
        vc.presenter = presenter
        return vc
    }
}
