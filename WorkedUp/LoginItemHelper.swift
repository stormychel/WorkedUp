//
//  LoginItemHelper.swift
//  WorkedUp
//
//  Docs: https://developer.apple.com/documentation/servicemanagement/smappservice
//
//  Created by Michel Storms on 19/03/2024.
//

import Foundation
import ServiceManagement

final class LoginItemHelper {
    
    /// Make sure isLoginItem reflects actual system state.
    @available(macOS 13.0, *)
    static func isLoginItem() -> Bool {
        let systemLoginItemState = SMAppService.mainApp.status
        
        print("LoginItemHelper.isLoginItem() - SMAppService.mainApp.status: \(systemLoginItemState)")
        
        switch systemLoginItemState {
        case .enabled:
            return true
        case .notRegistered, .notFound, .requiresApproval:
            return false
        @unknown default:
            return false
        }
    }
    
    /// Set "Open at Login" support.
    static func setLoginItem(enabled: Bool) {
        print("LoginItemHelper.setLoginItem() - setting to: \(enabled)")

        if #available(macOS 13.0, *) { // new code - #197
            if enabled {
                try? SMAppService().register()
            } else {
                try? SMAppService().unregister()
            }
        } else {
            print("LoginItemHelper.setLoginItem() - could not set to \(enabled), macOS version < 13.0")
        }

    }
    
}
