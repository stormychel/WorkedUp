//
//  SwiftHelpers.swift
//  WorkedUp
//
//  Created by Michel Storms on 04/03/2023.
//

import Foundation

final class SwiftHelpers {
    
    static func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    static func getTotal() -> Int {
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
    
    static func fetchNewestLogFile() -> String? {
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
    
    static func parseLogFile(_ logFileString: String) -> [String: Int] {
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
}
