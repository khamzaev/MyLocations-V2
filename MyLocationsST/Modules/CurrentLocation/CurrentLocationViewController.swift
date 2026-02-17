//
//  CurrentLocationViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import UIKit

final class CurrentLocationViewController: UIViewController, CurrentLocationViewProtocol {
    var presenter: CurrentLocationPresenterProtocol!
    
    private let statusLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let tagLocationButton = UIButton(type: .system)
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    private let cityLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 16, weight: .medium)
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 0
        statusLabel.preferredMaxLayoutWidth = view.bounds.width - 40
        
        view.addSubview(statusLabel)
        
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        latitudeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        latitudeLabel.textColor = .label
        latitudeLabel.textAlignment = .left
        
        view.addSubview(latitudeLabel)
        
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        longitudeLabel.textColor = .label
        longitudeLabel.textAlignment = .left
        
        view.addSubview(longitudeLabel)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cityLabel.textColor = .secondaryLabel
        cityLabel.textAlignment = .left
        
        view.addSubview(cityLabel)
        
        actionButton.setTitle("Get My Location", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.backgroundColor = .systemYellow
        actionButton.layer.cornerRadius = 12
        actionButton.clipsToBounds = true
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        
        tagLocationButton.setTitle("Tag Location", for: .normal)
        tagLocationButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        tagLocationButton.setTitleColor(.black, for: .normal)
        tagLocationButton.backgroundColor = .systemYellow
        tagLocationButton.layer.cornerRadius = 12
        tagLocationButton.clipsToBounds = true
        tagLocationButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        tagLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tagLocationButton)
        
        
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            latitudeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            latitudeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            latitudeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 24),
            longitudeLabel.leadingAnchor.constraint(equalTo: latitudeLabel.leadingAnchor),
            longitudeLabel.trailingAnchor.constraint(equalTo: latitudeLabel.trailingAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 12),
            cityLabel.leadingAnchor.constraint(equalTo: latitudeLabel.leadingAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: latitudeLabel.trailingAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -24),
            actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tagLocationButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 32),
            tagLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        tagLocationButton.addTarget(self, action: #selector(tagLocationTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        
    }
    
    func showTitle(_ text: String) {
        title = text
    }
    
    func showStatus(_ text: String) {
        statusLabel.text = text
    }
    
    func showGetLocationButton() {
        actionButton.setTitle("Get My Location", for: .normal)
    }
    
    func showTagLocationButton() {
        tagLocationButton.isHidden = false
    }
    
    func hideActionButtons() {
        tagLocationButton.isHidden = true
    }
    
    func showCoordinates(latitude: String, longitude: String) {
        latitudeLabel.text = "Latitude: \(latitude)"
        longitudeLabel.text = "Longitude: \(longitude)"
    }
    
    func showCity(_ city: String) {
        cityLabel.text = city
    }
    
    func hideStatus() {
        statusLabel.isHidden = true
    }
    
    func openTagLocationEditor(with item: LocationItem, store: LocationsStoreProtocol, output: TagLocationEditorOutput) {
        let editor = TagLocationEditorAssembly.build(item: item, store: store, output: output)
        present(editor, animated: true)
    }
    
    func switchToLocationsTab() {
        tabBarController?.selectedIndex = 1
    }
    
    
    @objc private func actionButtonTapped() {
        presenter.onGetMyLocationTapped()
    }
    
    @objc private func tagLocationTapped() {
        presenter.onTagLocationTapped()
    }
    
}
