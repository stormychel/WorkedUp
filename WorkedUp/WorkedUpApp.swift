//
//  WorkedUpApp.swift
//  WorkedUp
//
//  Created by Michel Storms on 01/03/2023.
//

import SwiftUI

@main
struct WorkedUpApp: App {
    @StateObject var appState = AppState.shared

    init() {
        LoginItemHelper.setLoginItem(enabled: true)
        updateLabel()
        startTimer()
    }

    var body: some Scene {
        MenuBarExtra(appState.label) {
            Text("Total time on Upwork this week: \(appState.label)")
            
            Button("Update") {
                updateLabel()
            }
            
            Button("Quit") {
                NSApplication.shared.terminate(self)
            }
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            updateLabel()
        }
    }

    private func updateLabel() {
        DispatchQueue.main.async {
            let hhmm = SwiftHelpers.minutesToHoursAndMinutes(SwiftHelpers.getTotal())
            AppState.shared.label = String(format: "%02d:%02d", hhmm.hours, hhmm.leftMinutes)
        }
    }





}
