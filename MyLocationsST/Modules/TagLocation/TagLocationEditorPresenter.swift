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
        
        view?.showCategory(title: item.category.rawValue)
        
        let lat = String(format: "%.6f", item.latitude)
        let lon = String(format: "%.6f", item.longitude)
        let address = item.address ?? ""
        let date = DateFormatter.localizedString(from: item.createdAt, dateStyle: .medium, timeStyle: .short)
        
        view?.showInfo(latitude: lat, longitude: lon, address: address, date: date)
        view?.showPhoto(fileName: item.photoFileName)
    }

    func onSaveTapped(name: String, category: LocationCategory) {
        item.name = name
        item.category = category
        
        store.save(item)
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
