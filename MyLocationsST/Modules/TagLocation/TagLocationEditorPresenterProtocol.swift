//
//  TagLocationEditorPresenterProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 07.02.2026.
//

import Foundation

protocol TagLocationEditorPresenterProtocol: AnyObject {
    func viewDidLoad()
    func onSaveTapped(name: String, category: LocationCategory)
    func onCategoryTapped()
    func onAddPhotoTapped()
    func onCategorySelected(_ category: LocationCategory)
    func onPhotoPicked(photoFileName: String)
    func onPhotoSourceSelected(_ source: ImageSource)
}
