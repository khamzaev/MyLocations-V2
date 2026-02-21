//
//  LocationCell.swift
//  MyLocationsST
//
//  Created by khamzaev on 21.02.2026.
//

import UIKit

final class LocationCell: UITableViewCell {

    static let reuseId = "LocationCell"

    private let photoView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 28

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        contentView.addSubview(photoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoView.widthAnchor.constraint(equalToConstant: 56),
            photoView.heightAnchor.constraint(equalToConstant: 56),

            // Описание чуть выше, отступы контролируем
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Вот тут создаётся расстояние между description и address
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(title: String, subtitle: String, image: UIImage?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle

        if let image {
            photoView.image = image
        } else {
            photoView.image = LocationCell.placeholderImage(size: CGSize(width: 56, height: 56))
        }
    }

    private static func placeholderImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            // фон-плейсхолдер
            UIColor.secondarySystemFill.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))

            // иконка в центре
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            let icon = UIImage(systemName: "photo", withConfiguration: config)?
                .withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)

            if let icon {
                let iconSize = icon.size
                let x = (size.width - iconSize.width) / 2
                let y = (size.height - iconSize.height) / 2
                icon.draw(in: CGRect(x: x, y: y, width: iconSize.width, height: iconSize.height))
            }
        }
    }
}
