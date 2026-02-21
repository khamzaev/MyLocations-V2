//
//  LocationsViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import UIKit

final class LocationsViewController: UIViewController {
    
    var presenter: LocationsPresenterProtocol!
    
    private var sections: [SectionModel] = []
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupEmptyLabel()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseId)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 72
        
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
        let grouped = Dictionary(grouping: items) { $0.category }
        
        let sortedCategories = grouped.keys.sorted { $0.rawValue < $1.rawValue}
        
        self.sections = sortedCategories.map { category in
            let items = (grouped[category] ?? []).sorted { $0.createdAt > $1.createdAt}
            return SectionModel(category: category, items: items)
        }
        
        emptyLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func showEmptyState() {
        sections = []
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }
}

extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].category.rawValue.uppercased()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseId, for: indexPath) as! LocationCell

        let item = sections[indexPath.section].items[indexPath.row]

        let title = item.name.isEmpty ? "(No Description)" : item.name

        let subtitle: String
        if let address = item.address, !address.isEmpty {
            subtitle = address
        } else if let city = item.city, !city.isEmpty {
            subtitle = city
        } else {
            subtitle = String(format: "%.6f, %.6f", item.latitude, item.longitude)
        }

        var image: UIImage? = nil
        if let fileName = item.photoFileName {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            image = UIImage(contentsOfFile: url.path)
        }

        cell.configure(title: title, subtitle: subtitle, image: image)
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
                let item = sections[indexPath.section].items[indexPath.row]
                presenter.deleteItem(id: item.id)
            }
    }
}
