//
//  AppState.swift
//  WorkedUp
//
//  Created by Michel Storms on 04/03/2023.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()
    
    private init () {}
    
    // persist label for nice startup
    @Published var label: String = (UserDefaults.standard.value(forKey: "label") as? String ?? "00:00") {
        didSet {
            UserDefaults.standard.set(label, forKey: "label")
        }
    }
}
