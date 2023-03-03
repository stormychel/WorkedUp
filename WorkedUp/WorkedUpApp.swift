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
//        let urlString = "file:///Users/stormychel/Library/Application\\ Support/Upwork/Upwork/Logs/upwork..20230303.log"

        let urlString = "/Users/stormychel/Library/Application Support/Upwork/Upwork/Logs"
        
        let fm = FileManager.default
        let path = urlString

        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
            }
        } catch {
            
            print("failed to read directory – bad permissions, perhaps?")
            
        }
        
        
        // just trying to get to the data we need first
        
//        if let filepath = Bundle.main.path(forResource: "example", ofType: "txt") {
        
        
        print("urlString: \(urlString)")
        print("test     : file:///Users/stormychel/Library/Containers/com.tiseyer.typegear-ai/Data/Documents/")
        
        if let url = URL(string: urlString) {
            
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
