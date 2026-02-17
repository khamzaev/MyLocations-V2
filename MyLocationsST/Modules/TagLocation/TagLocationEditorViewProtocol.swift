//
//  TagLocationEditorViewProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 07.02.2026.
//

import Foundation

protocol TagLocationEditorViewProtocol: AnyObject {
    func showTitle(_ title: String)
    func showLocationInfo(latitude: String, longitude: String, city: String?)
    func close(completion: (() -> Void)?)
}
