//
//  TagLocationEditorViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 11.02.2026.
//

import UIKit

final class TagLocationEditorViewController: UIViewController {
    
    private enum Section: Int, CaseIterable {
        case main
        case photo
        case info
    }
    
    private enum MainRow: Int, CaseIterable {
        case description
        case category
    }
    
    private enum PhotoRow: Int, CaseIterable {
        case addPhoto
    }
    
    private enum InfoRow: Int, CaseIterable {
        case latitude
        case longitude
        case address
        case date
    }
    
    var presenter: TagLocationEditorPresenterProtocol!
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var descriptionText: String = ""
    private var selectedCategory: LocationCategory = .noCategory
    
    private var latitudeText: String = ""
    private var longitudeText: String = ""
    private var addressText: String = ""
    private var dateText: String = ""
    private var photoFileName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupTable()
        
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
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func descriptionChanged(_ sender: UITextField) {
        descriptionText = sender.text ?? ""
    }
    
    @objc private func saveTapped() {
        presenter.onSaveTapped(
            name: descriptionText,
            category: selectedCategory
        )
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    
    private func saveImageToDocuments(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        
        let fileName = "loc_\(UUID().uuidString).jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) [0]
            .appendingPathComponent(fileName)
        
        do {
            try data.write(to: url, options: .atomic)
            return fileName
        } catch {
            print("Failed to save image", error)
            return nil
        }
    }
    
    
}


extension TagLocationEditorViewController: TagLocationEditorViewProtocol {
    
    
    func showTitle(_ title: String) {
        self.title = title
    }
    
    
    func close(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
    
    func showPhotoActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) {[weak self] _ in
            self?.presenter.onPhotoSourceSelected(.camera)
        })
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default) {[weak self] _ in
            self?.presenter.onPhotoSourceSelected(.photoLibrary)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showCategory(title: String) {
        selectedCategory = LocationCategory(rawValue: title) ?? .noCategory
        tableView.reloadRows(at: [IndexPath(row: MainRow.category.rawValue, section: Section.main.rawValue)], with: .none)
    }
    
    func showInfo(latitude: String, longitude: String, address: String, date: String) {
        latitudeText = latitude
        longitudeText = longitude
        addressText = address
        dateText = date
        
        tableView.reloadSections(IndexSet(integer: Section.info.rawValue), with: .none)
    }
    
    func showCategories(selected: LocationCategory) {
        
        selectedCategory = selected
        tableView.reloadRows(at: [IndexPath(row: MainRow.category.rawValue, section: Section.main.rawValue)], with: .none)
    }
    
    func showImagePicker(source: ImageSource) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        switch source {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                picker.sourceType = .photoLibrary
            }
        case .photoLibrary:
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true)
    }
    
    func showCategoryPicker(selected: LocationCategory) {
        let vc = CategoryPickerAssembly.build(selected: selected, output: presenter as! CategoryPickerOutput)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPhoto(fileName: String?) {
        photoFileName = fileName
        tableView.reloadRows(
                at: [IndexPath(row: PhotoRow.addPhoto.rawValue, section: Section.photo.rawValue)],
                with: .none
            )
    }
    
}

extension TagLocationEditorViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .main: return MainRow.allCases.count
        case .photo: return PhotoRow.allCases.count
        case .info: return InfoRow.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .main:
            switch MainRow(rawValue: indexPath.row)! {
            case .description:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                
                let tf = UITextField()
                tf.placeholder = "Description"
                tf.text = descriptionText
                tf.addTarget(self, action: #selector(descriptionChanged(_:)), for: .editingChanged)
                tf.translatesAutoresizingMaskIntoConstraints = false
                
                cell.contentView.addSubview(tf)
                
                NSLayoutConstraint.activate([
                    tf.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    tf.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
                    tf.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    tf.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
                ])
                
                cell.selectionStyle = .none
                return cell
            case .category:
              let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
              cell.textLabel?.text = "Category"
              cell.detailTextLabel?.text = selectedCategory.rawValue
              cell.accessoryType = .disclosureIndicator
              return cell
            }
            
        case .photo:
            if let fileName = photoFileName {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default

                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .scaleAspectFit
                    imageView.clipsToBounds = true

                    cell.contentView.addSubview(imageView)

                    NSLayoutConstraint.activate([
                        imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
                        imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12),
                        imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                        imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                        imageView.heightAnchor.constraint(equalToConstant: 160)
                    ])

                    // загрузка картинки из Documents
                    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        .appendingPathComponent(fileName)
                    imageView.image = UIImage(contentsOfFile: url.path)

                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    cell.textLabel?.text = "Add Photo"
                    cell.accessoryType = .disclosureIndicator
                    return cell
                }
            
        case .info:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            cell.detailTextLabel?.textAlignment = .right
            
            switch InfoRow(rawValue: indexPath.row)! {
            case .latitude:
                cell.textLabel?.text = "Latitude"
                cell.detailTextLabel?.text = latitudeText
            case .longitude:
                cell.textLabel?.text = "Longitude"
                cell.detailTextLabel?.text = longitudeText
            case .address:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.textLabel?.text = "Address"
                    cell.textLabel?.textColor = .label

                    cell.detailTextLabel?.text = addressText
                    cell.detailTextLabel?.textColor = .secondaryLabel
                    cell.detailTextLabel?.numberOfLines = 0
                    cell.detailTextLabel?.lineBreakMode = .byWordWrapping

                    return cell
            case .date:
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = dateText
            }
            
            return cell
        }
    }
}

extension TagLocationEditorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch Section(rawValue: indexPath.section)! {
        case .main:
            if MainRow(rawValue: indexPath.row) == .category {
                presenter.onCategoryTapped()
            }
        case .photo:
            presenter.onAddPhotoTapped()
        case .info:
            break
        }
    }
}


extension TagLocationEditorViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let fileName = saveImageToDocuments(image) else { return }
        
        presenter.onPhotoPicked(photoFileName: fileName)
    }
}
