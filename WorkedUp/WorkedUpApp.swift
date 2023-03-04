//
//  WorkedUpApp.swift
//  WorkedUp
//
//  Created by Michel Storms on 01/03/2023.
//

import SwiftUI

@main
struct WorkedUpApp: App {
    @State var totalTimeWorked: Int = 0
    
    init() {
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
                    
                    // chop string into array of lines
                    var lines: [String] = [] // contains file line by line
                    for line in newestLogFileString.split(separator: "\n") {
                        lines.append( String(line) )
                    }
                    
                    // TODO: scan for entry line containing LOAD_WORKED_TIME, this is the start of the JSON

                    var contracts: [String : Int] = [ : ] // contains rollupId entries
                    
                    var currenrRollupId: String = ""
                    
                    for line in lines {
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
                                
                                currenrRollupId = ""
                            }
                        }
                    }
                    
                    print(contracts)
                                       
                    totalTimeWorked = 0
                    
                    var test: Int = 0
                    
                    for (_, value) in contracts {
                        totalTimeWorked += value
                        
                        test += value
                    }
                                        
                    print("test : \(test)")

                    totalTimeWorked = test
                    
                    print("totalTimeWorked : \(totalTimeWorked)")
                    
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }

    }

    var body: some Scene {
        MenuBarExtra( String(totalTimeWorked) ) {
            
            Button("Quit") {
                NSApplication.shared.terminate(self)
            }
            
        }
    }
}
