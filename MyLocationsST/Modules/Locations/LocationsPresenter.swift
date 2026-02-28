//
//  LocationsPresenter.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import Foundation

final class LocationsPresenter: LocationsPresenterProtocol {
    
    private weak var view: LocationsViewProtocol?
    private let store: LocationsStoreProtocol
    private var items: [LocationItem] = []
    
    init(
        view: LocationsViewProtocol,
        store: LocationsStoreProtocol
    ) {
        self.view = view
        self.store = store
    }
    
    func viewDidLoad() {
        view?.showTitle("Locations")
        reload()
    }
    
    func viewWillAppear() {
        reload()
    }
    
    func deleteItem(id: UUID) {
        store.delete(id: id)
        reload()
    }
    
    func onLocationSelected(_ item: LocationItem) {
        view?.openEditor(for: item)
    }
    
    
    private func reload() {
        items = store.fetchAll()
        if self.items.isEmpty {
            view?.showEmptyState()
        } else {
            view?.showItems(self.items)
        }
    }
}
