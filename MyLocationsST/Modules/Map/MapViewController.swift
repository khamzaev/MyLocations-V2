//
//  MapViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import UIKit
import MapKit

final class MapViewController: UIViewController, MapViewProtocol {
    var presenter: MapPresenterProtocol!
    var store: LocationsStoreProtocol!
    
    private let mapView = MKMapView()
    private var annotations: [MKAnnotation] = []
    private let centerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupMap()
        presenter.viewDidLoad()
    }
    
    func showTitle(_ text: String) {
        title = text
    }
    
    
    private func setupMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        mapView.delegate = self
        
        setupCenterButton()
    }
    
    private func setupCenterButton() {
        centerButton.translatesAutoresizingMaskIntoConstraints = false

        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: "location.fill", withConfiguration: config)
        centerButton.setImage(image, for: .normal)

        centerButton.backgroundColor = .systemBackground
        centerButton.layer.cornerRadius = 22
        centerButton.layer.shadowOpacity = 0.15
        centerButton.layer.shadowRadius = 6
        centerButton.layer.shadowOffset = CGSize(width: 0, height: 3)

        centerButton.addTarget(self, action: #selector(centerOnUserTapped), for: .touchUpInside)

        view.addSubview(centerButton)

        NSLayoutConstraint.activate([
            centerButton.widthAnchor.constraint(equalToConstant: 44),
            centerButton.heightAnchor.constraint(equalToConstant: 44),

            centerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            centerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func centerOnUserTapped() {
        presenter.onCenterOnUserTapped()
    }
    
    func showLocations(_ locations: [LocationItem]) {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
        let newAnnotations: [LocationAnnotation] = locations.map { item in
            let ann = LocationAnnotation(id: item.id)
            ann.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            
            let title = item.name.isEmpty ? "(No Description)" : item.name
            ann.title = title
            
            if let address = item.address, !address.isEmpty {
                ann.subtitle = address
            } else if let city = item.city, !city.isEmpty {
                ann.subtitle = city
            } else {
                ann.subtitle = nil
            }
            
            return ann
        }
        
        annotations = newAnnotations
        mapView.addAnnotations(newAnnotations)
        
        if !newAnnotations.isEmpty {
            mapView.showAnnotations(newAnnotations, animated: true)
        }
    }
    
    func openEditor(for item: LocationItem) {
        let editor = TagLocationEditorAssembly.buildEdit(item: item, store: store, output: self)
        present(editor, animated: true)
    }
    
    func setUserLocationVisible(_ isVisible: Bool) {
        mapView.showsUserLocation = isVisible
    }
    
    func setUserTrackingEnabled(_ enabled: Bool) {
        mapView.userTrackingMode = enabled ? .follow : .none
    }
    
    func centerOnUser() {
        mapView.userTrackingMode = .follow
    }
    
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ ampView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let reuseId = "LocationPin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view?.canShowCallout = true
            
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let ann = view.annotation as? LocationAnnotation else { return }
        presenter.onAnnotationSelected(id: ann.id)
    }
}

extension MapViewController: TagLocationEditorOutput {
    func tagLocationEditorDidSave() {
        dismiss(animated: true)
        presenter.reload()
    }
}
