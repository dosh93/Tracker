//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Dosh on 15.04.2024.
//

import Foundation

typealias Binding = () -> Void

final class CategoryViewModel {
    
    var updateCategory: Binding?
    
    private let model: TrackerCategoryStore
    
    var countCategory: Int {
        return model.countCategory ?? 0
    }
    
    init(model: TrackerCategoryStore) {
        self.model = model
        self.model.delegate = self
    }
    
    func getCategory(_ indexPath: IndexPath) -> String {
        model.object(at: indexPath)
    }
    
    func createCategory(_ categoryName: String) {
        do {
            try model.createCategory(name: categoryName)
        } catch {
            print("createCategory")
        }
        
    }
}

extension CategoryViewModel: StoreDelegate {
    func didUpdate() {
        print("Data updated, reloading table view and checking placeholder visibility.")
        updateCategory?()
    }
}
