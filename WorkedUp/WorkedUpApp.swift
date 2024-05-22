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
        updateLabel()
        startTimer()
    }

    var body: some Scene {
        MenuBarExtra( appState.label) {
            Text("Total time on Upwork this week: \(appState.label)")
            
            Button("Update") {
                updateLabel()
            }
            
            Button("Quit") {
                NSApplication.shared.terminate(self)
            }
        }
    }
    
    fileprivate func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            updateLabel()
        }
    }
    
    fileprivate func updateLabel() {
        DispatchQueue.main.async {
            let hhmm = minutesToHoursAndMinutes(getTotal())
            let formattedTime = String(format: "%02d:%02d", hhmm.hours, hhmm.leftMinutes)
            
            AppState.shared.label = formattedTime
        }
    }
    
    fileprivate func getTotal () -> Int {
        let fm = FileManager.default
        let userName = NSUserName()
        let path = "/Users/\(userName)/Library/Application Support/Upwork/Upwork/Logs"
        
        do {
            let logFileNames = try fm.contentsOfDirectory(atPath: path).filter({!$0.contains("cmon") && !$0.contains("dash")})
            
            if let newestLogFileName = logFileNames.sorted(by: {$0.filter("0123456789".contains) > $1.filter("0123456789".contains)}).first {
                let urlString = path + "/" + newestLogFileName
                
                print("urlString: \(urlString)")
                    
                do {
                    let newestLogFileString = try String(contentsOfFile: urlString) // make string from file
                    
                    var contracts: [String : Int] = [ : ] // contains rollupId entries
                    var currenrRollupId: String = ""
                    
                    // chop string into array of lines + get required data
                    for line in newestLogFileString.split(separator: "\n") {
                        if line.contains("rollupId") {
                            currenrRollupId = line.filter("0123456789".contains)
                        } else if line.contains("minutesWorkedThisWeek") {
                            if !currenrRollupId.isEmpty {
                                if let new = Int( line.filter("0123456789".contains) ) {
                                    if let old = contracts[currenrRollupId] {
                                        if new > old { // found newer value, replace
                                            contracts[currenrRollupId] = new
                                        }
                                    } else { // no value found yet, assign
                                        contracts[currenrRollupId] = new
                                    }
                                }
                                currenrRollupId = "" // end of current, clear name
                            }
                        }
                    }
                     
                    var total: Int = 0
                    
                    for (_, value) in contracts {
                        total += value
                    }
                                                            
                    return total
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }

        return 0
    }
}
