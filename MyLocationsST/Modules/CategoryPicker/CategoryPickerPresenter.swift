//
//  CategoryPickerPresenter.swift
//  MyLocationsST
//
//  Created by khamzaev on 19.02.2026.
//

import Foundation

final class CategoryPickerPresenter: CategoryPickerPresenterProtocol {
    private weak var view: CategoryPickerViewProtocol?
    private weak var output: CategoryPickerOutput?
    
    private let categories: [LocationCategory] = LocationCategory.allCases
    private var selected: LocationCategory
    
    init(
    view: CategoryPickerViewProtocol,
    selected: LocationCategory,
    output: CategoryPickerOutput
    ) {
        self.view = view
        self.selected = selected
        self.output = output
    }
    
    var numberOfCategories: Int {
        categories.count
    }
    
    func category(at index: Int) -> LocationCategory {
        categories[index]
    }
    
    func isSelected(_ category: LocationCategory) -> Bool {
        category == selected
    }
    
    func didSelectCategory(at index: Int) {
        let category = categories[index]
        selected = category
        view?.reload()
        output?.categoryPickerDidSelect(category)
        view?.close()
    }
}
