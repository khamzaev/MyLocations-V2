//
//  MapPresenter.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import Foundation
import CoreLocation

final class MapPresenter: NSObject,MapPresenterProtocol {
    private weak var view: MapViewProtocol?
    private let store: LocationsStoreProtocol
    private var locations: [LocationItem] = []
    private let locationManager = CLLocationManager()
    
    
    init(view: MapViewProtocol, store: LocationsStoreProtocol) {
        self.view = view
        self.store = store
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func viewDidLoad() {
        view?.showTitle("Map")
        reload()
        startUserLocation()
    }
    
    func reload() {
        locations = store.fetchAll()
        view?.showLocations(locations)
    }
    
    func onAnnotationSelected(id: UUID) {
        guard let item = locations.first(where: { $0.id == id}) else { return }
        view?.openEditor(for: item)
    }
    
    func onCenterOnUserTapped() {
        startUserLocation()
        view?.centerOnUser()
    }
    
    private func startUserLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            view?.setUserLocationVisible(false)
            return
        }
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            view?.setUserLocationVisible(true)
            view?.setUserTrackingEnabled(true)
            locationManager.startUpdatingLocation()
            
        default:
            view?.setUserLocationVisible(false)
        }
    }
    
}


extension MapPresenter: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        startUserLocation()
    }
}
