//
//  TagLocationEditorViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import UIKit

final class TagLocationEditorViewController: UIViewController {
    
    var presenter: TagLocationEditorPresenterProtocol!
    
    private let nameTextField = UITextField()
    private let categoryButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupUI()
        
        presenter.viewDidLoad()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    private func setupUI() {
        nameTextField.placeholder = "Description"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        categoryButton.setTitle("No Category", for: .normal)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameTextField)
        view.addSubview(categoryButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            categoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            categoryButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor)
        ])
    }
    
    @objc private func saveTapped() {
        presenter.onSaveTapped(
            name: nameTextField.text ?? "",
            category: .noCategory
        )
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    
}


extension TagLocationEditorViewController: TagLocationEditorViewProtocol {
    func showTitle(_ title: String) {
        self.title = title
    }
    
    func showLocationInfo(latitude: String, longitude: String, city: String?) {
        
    }
    
    func close(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
    
    
}
