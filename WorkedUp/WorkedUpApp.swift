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
            let logs = try fm.contentsOfDirectory(atPath: path).filter({!$0.contains("cmon") && !$0.contains("dash")})
            
            if let newestLog = logs.sorted(by: {$0.filter("0123456789".contains) > $1.filter("0123456789".contains)}).first {
                print("newestLog: \(newestLog)")
                
                
            }
            
        } catch {
            print("failed to read directory – bad permissions, perhaps?")
        }

        
        
        // MARK: TEST
        
        if let url = URL(string: path) {
            
            print("URL: \(url.absoluteString)")
            
            do {
                let contents = try String(contentsOfFile: url.absoluteString)
                
                print(contents)
            } catch {
                // contents could not be loaded
                print("CATCH")
            }
        } else {
            // example.txt not found!
            print("ELSE")
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
