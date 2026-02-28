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
    private let mode: TagLocationEditorMode
    
    init(
        view: TagLocationEditorViewProtocol,
        item: LocationItem,
        store: LocationsStoreProtocol,
        output: TagLocationEditorOutput,
        mode: TagLocationEditorMode
    ) {
        self.view = view
        self.item = item
        self.store = store
        self.output = output
        self.mode = mode
    }
    
    func viewDidLoad() {
        view?.showTitle("Tag Location")
        
        view?.showCategory(title: item.category.rawValue)
        
        let lat = String(format: "%.6f", item.latitude)
        let lon = String(format: "%.6f", item.longitude)
        let address = item.address ?? ""
        let date = DateFormatter.localizedString(from: item.createdAt, dateStyle: .medium, timeStyle: .short)
        
        view?.showInfo(latitude: lat, longitude: lon, address: address, date: date)
        view?.showPhoto(fileName: item.photoFileName)
        view?.showDescription(item.name)
    }

    func onSaveTapped(name: String, category: LocationCategory) {
        item.name = name
        item.category = category
        
        switch mode {
        case .create:
            store.save(item)
        case .edit:
            store.update(item)
        }
        view?.close { [weak self] in
            self?.output?.tagLocationEditorDidSave()
        }
    }
    
    func onAddPhotoTapped() {
        view?.showPhotoActionSheet()
    }
    
    func onPhotoSourceSelected(_ source: ImageSource) {
        view?.showImagePicker(source: source)
    }
    
    func onCategoryTapped() {
        view?.showCategoryPicker(selected: item.category)
    }
    
    func onCategorySelected(_ category: LocationCategory) {
        item.category = category
        view?.showCategory(title: category.rawValue)
    }
    
    func onPhotoPicked(photoFileName: String) {
        item.photoFileName = photoFileName
        view?.showPhoto(fileName: photoFileName)
    }
    
}


extension TagLocationEditorPresenter: CategoryPickerOutput {
    func categoryPickerDidSelect(_ category: LocationCategory) {
        item.category = category
        view?.showCategory(title: category.rawValue)
    }
}
