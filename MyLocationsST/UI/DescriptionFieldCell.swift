//
//  DescriptionFieldCell.swift
//  MyLocationsST
//
//  Created by khamzaev on 26.02.2026.
//

import UIKit

final class DescriptionFieldCell: UITableViewCell {
    static let reuseId = "DescriptionFieldCell"
    
    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Description"
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(text: String) {
        if textField.text != text {
            textField.text = text
        }
    }
}
