//
//  CurrentLocationPresenter.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import Foundation
import CoreLocation

enum CurrentLocationState {
    
    case idle
    case loading
    case result(latitude: String, longitude: String, city: String?)
    case error(String)
    
}

private enum StatusText {
    static let loading = "Searching for location..."
    static let success = "Location found"
    static let servicesDisabled = "Location services are disabled"
    static let accessDenied = "Location acces denied"
}


final class CurrentLocationPresenter: NSObject, CurrentLocationPresenterProtocol {
    
    private weak var view: CurrentLocationViewProtocol?
    private let store: LocationsStoreProtocol
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var currentLocation: CLLocation?
    private var state: CurrentLocationState = .idle {
        didSet {
            switch state {
            case .idle:
                view?.showGetLocationButton()
                view?.hideActionButtons()
            case .loading:
                view?.showStatus(StatusText.loading)
            case .result(let latitude, let longitude, let city):
                view?.hideStatus()
                view?.showCoordinates(latitude: latitude, longitude: longitude)
                if let city = city {
                    view?.showCity(city)
                }
                view?.showTagLocationButton()
            case .error(let message):
                view?.showStatus(message)
                view?.showGetLocationButton()
            }
        }
    }
    
    init(
        view: CurrentLocationViewProtocol,
        store: LocationsStoreProtocol
    ) {
        self.view = view
        self.store = store
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func viewDidLoad() {
        view?.showTitle("Tag")
        state = .idle
    }
    
    private func startLocationFlow() {
        if !CLLocationManager.locationServicesEnabled() {
            onLocationServicesDisabled()
            return
        }
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            handleAuthorizationStatus(status)
        }
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            state = .loading
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            state = .error(StatusText.accessDenied)
        case .notDetermined:
            break
        }
    }
    
    private func handleLocationRecevied(_ location: CLLocation) {
        currentLocation = location
        let latitude = String(format: "%.6f", location.coordinate.latitude)
        let longitude = String(format: "%.6f", location.coordinate.longitude)
        state = .result(latitude: latitude, longitude: longitude, city: nil)
        
        geocoder.reverseGeocodeLocation(location) { [weak self ] placemarks, error in
            guard let self = self else { return }
            if let city = placemarks?.first?.locality, !city.isEmpty {
                DispatchQueue.main.async {
                    self.state = .result(latitude: latitude, longitude: longitude, city: city)
                }
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func onLocationServicesDisabled(){
        state = .error(StatusText.servicesDisabled)
    }
    
    func onGetMyLocationTapped() {
        startLocationFlow()
    }
    
    func onTagLocationTapped() {
        guard case let .result(latitude, longitude, city) = state,
              let lat = Double(latitude),
              let lon = Double(longitude) else { return }
        
        let item = LocationItem(
            latitude: lat,
            longitude: lon,
            city: city
        )
        
        view?.openTagLocationEditor(with: item, store: store, output: self)
    }
    
    
}

extension CurrentLocationPresenter: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        handleLocationRecevied(location)
    }
    
}

extension CurrentLocationPresenter: TagLocationEditorOutput {
    func tagLocationEditorDidSave() {
        view?.switchToLocationsTab()
    }
}
