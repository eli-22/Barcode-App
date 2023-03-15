//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner_V4.1_Customize Alerts
//
//  Created by Elise on 12/31/22.
//

import Foundation
import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
    
    // @State in view, @Published in view model. 
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String {
        scannedCode.isEmpty ? "Not yet scanned": scannedCode
    }
    
    var statusTextColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
}


