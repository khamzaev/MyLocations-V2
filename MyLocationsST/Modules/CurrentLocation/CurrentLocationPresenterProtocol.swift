//
//  CurrentLocationPresenterProtocol.swift
//  MyLocationsST
//
//  Created by khamzaev on 01.02.2026.
//

import Foundation

protocol CurrentLocationPresenterProtocol: BasePresenterProtocol {
    func onLocationServicesDisabled()
    func onGetMyLocationTapped()
    func onTagLocationTapped()
}
