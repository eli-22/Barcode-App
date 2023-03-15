//
//  Alerts.swift
//  BarcodeScanner_V4.1_Customize Alerts
//
//  Created by Elise on 12/30/22.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: Text("Invalid Device Input"),
                                        message: Text("A camera error occurred. Unable to capture input."),
                                        dismissButton: .default(Text("Dismiss")))
    static let invalidScannedType = AlertItem(title: Text("Invalid Scan"),
                                        message: Text("Value scanned is invalid. This app scanns EAN-8 and EAN-13."),
                                        dismissButton: .default(Text("Dismiss")))
}
