//
//  TagLocationEditorViewProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 07.02.2026.
//

import Foundation

protocol TagLocationEditorViewProtocol: AnyObject {
    func showTitle(_ title: String)
    func close(completion: (() -> Void)?)
    func showCategory(title: String)
    func showPhotoActionSheet()
    func showCategories(selected: LocationCategory)
    func showInfo(latitude: String, longitude: String, address: String, date: String)
    func showImagePicker(source: ImageSource)
    func showCategoryPicker(selected: LocationCategory)
    func showPhoto(fileName: String?)
}
