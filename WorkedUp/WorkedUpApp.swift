//
//  WorkedUpApp.swift
//  WorkedUp
//
//  Created by Michel Storms on 01/03/2023.
//

import SwiftUI

@main
struct WorkedUpApp: App {
    @State var currentNumber: String = "1"

    var body: some Scene {
        MenuBarExtra(currentNumber, systemImage: "\(currentNumber)") {
            // 3
            Button("One") {
                currentNumber = "1"
            }
            Button("Two") {
                currentNumber = "2"
            }
            Button("Three") {
                currentNumber = "3"
            }
        }
    }
}
