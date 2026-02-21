//
//  CategoryPickerViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 19.02.2026.
//

import UIKit

final class CategoryPickerViewController: UIViewController {
    var presenter: CategoryPickerPresenterProtocol!
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Category"
        
        setupTable()
    }
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension CategoryPickerViewController: CategoryPickerViewProtocol {
    func reload() {
        tableView.reloadData()
    }
    func close() {
        navigationController?.popViewController(animated: true)
    }
}


extension CategoryPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let category = presenter.category(at: indexPath.row)
        
        cell.textLabel?.text = category.rawValue
        cell.accessoryType = presenter.isSelected(category) ? .checkmark : .none
        
        return cell
    }
}

extension CategoryPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectCategory(at: indexPath.row)
    }
}
