//
//  SwiftHelpers.swift
//  WorkedUp
//
//  Created by Michel Storms on 04/03/2023.
//

import Foundation

func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
    return (minutes / 60, (minutes % 60))
}
