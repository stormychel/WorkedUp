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
    
    @Published var label: String = "?"
}
