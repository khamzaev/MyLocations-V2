//
//  TagLocationEditorPresenter.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import Foundation

final class TagLocationEditorPresenter: TagLocationEditorPresenterProtocol {
    
    private weak var view: TagLocationEditorViewProtocol?
    private weak var output: TagLocationEditorOutput?
    private let store: LocationsStoreProtocol
    private var item: LocationItem
    
    init(
        view: TagLocationEditorViewProtocol,
        item: LocationItem,
        store: LocationsStoreProtocol,
        output: TagLocationEditorOutput
    ) {
        self.view = view
        self.item = item
        self.store = store
        self.output = output
    }
    
    func viewDidLoad() {
        view?.showTitle("Tag Location")
        
        let latitude = String(format: "%.6f", item.latitude)
        let longitude = String(format: "%.6f", item.longitude)
        
        view?.showLocationInfo(latitude: latitude, longitude: longitude, city: item.city)
    }
    
    func onSaveTapped(name: String, category: LocationCategory) {
        item.name = name
        item.category = category
        
        store.save(item)
        view?.close { [weak self] in
            self?.output?.tagLocationEditorDidSave()
        }
    }
}
