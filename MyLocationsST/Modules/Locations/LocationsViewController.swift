//
//  LocationsViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import UIKit

final class LocationsViewController: UIViewController {
    
    var presenter: LocationsPresenterProtocol!
    
    private var items: [LocationItem] = []
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter.viewDidLoad()
        
        setupTable()
        setupEmptyLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupEmptyLabel() {
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.text = "No Locations yet"
        emptyLabel.isHidden = true
        
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }
    
}



extension LocationsViewController: LocationsViewProtocol {
    
    func showTitle(_ text: String) {
        title = text
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    func showItems(_ items: [LocationItem]) {
        self.items = items
        emptyLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func showEmptyState() {
        self.items = []
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }
}

extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name.isEmpty ? "Unnamed location" : item.name
        
        if let city = item.city {
            cell.detailTextLabel?.text = city
        } else {
            cell.detailTextLabel?.text = String(format: "%.6f, %.6f", item.latitude, item.longitude)
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension LocationsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                presenter?.deleteItem(at: indexPath.row)
            }
    }
}
