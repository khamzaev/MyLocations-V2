//
//  MapPresenter.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import Foundation

final class MapPresenter: BasePresenterProtocol {
    private weak var view: MapViewProtocol?
    
    init(view: MapViewProtocol? = nil) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showTitle("Map")
    }
    
}
