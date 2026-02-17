//
//  CurrentLocationViewProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import Foundation

protocol CurrentLocationViewProtocol: BaseViewProtocol {
    
    func showTitle(_ text: String)
    
    func showStatus(_ text: String)
    
    func showGetLocationButton()
    
    func showTagLocationButton()
    
    func hideActionButtons()
    
    func showCoordinates(latitude: String, longitude: String)
    
    func showCity(_ city: String)
    
    func hideStatus()
    
    func openTagLocationEditor(with item: LocationItem, store: LocationsStoreProtocol, output: TagLocationEditorOutput)
    
    func switchToLocationsTab()
    
}
