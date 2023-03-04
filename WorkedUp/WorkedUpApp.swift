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
    
    init() {
        let fm = FileManager.default
        let userName = NSUserName()
        let path = "/Users/\(userName)/Library/Application Support/Upwork/Upwork/Logs"
        
        print("path: \(path)")

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
                        print (line)
                        
                        lines.append( String(line) )
                    }
                    
                    // TODO: scan for entry line containing LOAD_WORKED_TIME, this is the start of the JSON

                    var contracts: [String : String] = [ : ] // contains rollupId entries
                    
                    var currenrRollupId: String = ""
                    
                    for line in lines {
                        if line.contains("rollupId") {
                            currenrRollupId = line.filter("0123456789".contains)
                        } else if line.contains("minutesWorkedThisWeek") {
                            if !currenrRollupId.isEmpty {
                                contracts[currenrRollupId] = line.filter("0123456789".contains)
                                currenrRollupId = ""
                            }
                        }
                    }
                    
                    print(contracts)
                    
                    /*
                     [2023-03-03T23:01:27.057] [INFO] fe.[default] - [INFO] <Redux> - action { type: 'LOAD_WORKED_TIME',
                       payload:
                        [ { rollupId: '30472057',
                            minutesWorkedThisWeek: 0,
                            minutesWorkedToday: 0,
                            lastTimeWorked: 1675342994 },
                          { rollupId: '31147095',
                            minutesWorkedThisWeek: 0,
                            minutesWorkedToday: 0,
                            lastTimeWorked: 1677414806 },
                          { rollupId: '31592247',
                            minutesWorkedThisWeek: 0,
                            minutesWorkedToday: 0,
                            lastTimeWorked: 1669898652 },
                          { rollupId: '31744019',
                            minutesWorkedThisWeek: 0,
                            minutesWorkedToday: 0,
                            lastTimeWorked: 1673558939 },
                          { rollupId: '32175518',
                            minutesWorkedThisWeek: 0,
                            minutesWorkedToday: 0,
                            lastTimeWorked: 0 },
                          { rollupId: '32614295',
                            minutesWorkedThisWeek: 1510,
                            minutesWorkedToday: 410,
                            lastTimeWorked: 1677861093 } ] }
                     */
                    
                    
                    
                    
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }

    }

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
