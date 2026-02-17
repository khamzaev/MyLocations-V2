//
//  MapViewController.swift
//  MyLocationsST
//
//  Created by khamzaev on 22.01.2026.
//

import UIKit

final class MapViewController: UIViewController, MapViewProtocol {
    private var presenter: BasePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter.viewDidLoad()
    }
    
    func showTitle(_ text: String) {
        title = text
    }
    
    static func make() -> UIViewController {
        let vc = MapViewController()
        let presenter = MapPresenter(view: vc)
        vc.presenter = presenter
        return vc
    }
}
