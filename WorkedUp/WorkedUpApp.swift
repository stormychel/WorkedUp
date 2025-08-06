//
//  WorkedUpApp.swift
//  WorkedUp
//
//  Created by Michel Storms on 01/03/2023.
//

import SwiftUI


// MARK: TEST CODE (testing improvements)
@main
struct WorkedUpApp: App {
    @StateObject var appState = AppState.shared

    private let logFilePath = "/Users/\(NSUserName())/Library/Application Support/Upwork/Upwork/Logs"

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
            let hhmm = minutesToHoursAndMinutes(getTotal())
            AppState.shared.label = String(format: "%02d:%02d", hhmm.hours, hhmm.leftMinutes)
        }
    }

    private func getTotal() -> Int {
        guard let newestLogFile = fetchNewestLogFile() else { return 0 }

        do {
            let newestLogFileString = try String(contentsOfFile: newestLogFile)
            let contracts = parseLogFile(newestLogFileString)
            return contracts.values.reduce(0, +)
        } catch {
            print("Error reading log file: \(error)")
            return 0
        }
    }

    private func fetchNewestLogFile() -> String? {
        let fm = FileManager.default
        
        do {
            let logFileNames = try fm.contentsOfDirectory(atPath: logFilePath)
                .filter { !$0.contains("cmon") && !$0.contains("dash") }

            return logFileNames
                .sorted { $0.filter("0123456789".contains) > $1.filter("0123456789".contains) }
                .first
                .map { logFilePath + "/" + $0 }
        } catch {
            print("Error fetching log files: \(error)")
            return nil
        }
    }

    private func parseLogFile(_ logFileString: String) -> [String: Int] {
        var contracts = [String: Int]()
        var currentRollupId = ""
        
        for line in logFileString.split(separator: "\n") {
            if let rollupId = extractRollupId(from: String(line)) {
                currentRollupId = rollupId
            } else if let minutesWorked = extractMinutesWorked(from: String(line)), !currentRollupId.isEmpty {
                contracts[currentRollupId] = max(contracts[currentRollupId] ?? 0, minutesWorked)
                currentRollupId = "" // Reset after processing
            }
        }
        
        return contracts
    }

    private func extractRollupId(from line: String) -> String? {
        return line.contains("rollupId") ? line.filter("0123456789".contains) : nil
    }

    private func extractMinutesWorked(from line: String) -> Int? {
        return line.contains("minutesWorkedThisWeek") ? Int(line.filter("0123456789".contains)) : nil
    }
}
//


/*
@main
struct WorkedUpApp: App {
    @StateObject var appState = AppState.shared

    init() {
        LoginItemHelper.setLoginItem(enabled: true)
        Self.updateLabel()
        Self.startTimer()
    }

    var body: some Scene {
        MenuBarExtra( appState.label) {
            Text("Total time on Upwork this week: \(appState.label)")
            
            Button("Update") {
                Self.updateLabel()
            }
            
            Button("Quit") {
                NSApplication.shared.terminate(self)
            }
        }
    }
    
    fileprivate static func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            updateLabel()
        }
    }
    
    
    fileprivate static func getTotals() -> (week: Int, day: Int) {
        let fm = FileManager.default
        let userName = NSUserName()
        let path = "/Users/\(userName)/Library/Application Support/Upwork/Upwork/Logs"

        do {
            let logFileNames = try fm.contentsOfDirectory(atPath: path)
                .filter { !$0.contains("cmon") && !$0.contains("dash") }

            if let newestLogFileName = logFileNames
                .sorted(by: { $0.filter("0123456789".contains) > $1.filter("0123456789".contains) })
                .first {
                
                let urlString = path + "/" + newestLogFileName
                let logContent = try String(contentsOfFile: urlString)

//                var currentRollupId: String = ""
                var weekTotals: [String: Int] = [:]
                var dayTotals: [String: Int] = [:]

                var lines = logContent.split(separator: "\n")

                for i in 0..<lines.count {
                    let line = lines[i]

                    if line.contains("minutesWorkedThisWeek") || line.contains("minutesWorkedToday") {
                        var rollupId: String? = nil

                        // Try to find rollupId by scanning upward
                        for j in stride(from: i, through: max(i - 10, 0), by: -1) {
                            let candidate = lines[j]
                            if candidate.contains("rollupId") {
                                rollupId = candidate.filter("0123456789".contains)
                                break
                            }
                        }

                        guard let rollup = rollupId, !rollup.isEmpty else {
                            print("⚠️ No rollupId found for line \(i): \(line)")
                            continue
                        }

                        if let minutes = Int(line.filter("0123456789".contains)) {
                            if line.contains("minutesWorkedThisWeek") {
                                weekTotals[rollup] = max(weekTotals[rollup] ?? 0, minutes)
                            } else if line.contains("minutesWorkedToday") {
                                dayTotals[rollup] = max(dayTotals[rollup] ?? 0, minutes)
                            }
                        }
                    }
                }

                let totalWeek = weekTotals.values.reduce(0, +)
                let totalDay = dayTotals.values.reduce(0, +)
                
                
                print("✅ WEEK TOTALS: \(weekTotals)")
                print("✅ DAY TOTALS: \(dayTotals)")
                
                
                return (totalWeek, totalDay)
            }
        } catch {
            print("‼️ Error while reading log: \(error)")
        }

        return (0, 0)
    }

    fileprivate static func updateLabel() {
        DispatchQueue.main.async {
            let totals = getTotals()
            let week = minutesToHoursAndMinutes(totals.week)
            let day = minutesToHoursAndMinutes(totals.day)

            let label = String(format: "D-%02d:%02d / W-%02d:%02d", day.hours, day.leftMinutes, week.hours, week.leftMinutes)
            print("⏱️ Updated label: \(label)")
            AppState.shared.label = label
        }
    }
    //
    
}
*/
