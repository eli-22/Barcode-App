//
//  ScannerView.swift
//  BarcodeScanner_V3.0_Coordinator Setup
//
//  Created by Elise on 12/30/22.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    // 6. Once this updates, it will also update scannedCode in BarcodeScannerView, which will then update the view.
    @Binding var scannedCode: String
    @Binding var alertItem: AlertItem?
    
    func makeUIViewController(context: Context) -> ScannerVC {
        // typealias UIViewControllerType = ScannerVC
        // 1. Once you tell Xcode the type is ScannerVC, it supplies the proper protocol stubs. (Select "Fix" on the error message.)
        
        // Context is a type alias for UIViewControllerRepresentableContext<Self>
        // A type alias allows you to provide a new name for an existing data type. Can add an extra step (if you have to look up what it represents), but can also keep the code clean.
        
        ScannerVC(scannerDelegate: context.coordinator)
        // 2. Initialize scannerVC with scannerDelegate, which we want to be the coordinator.
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
        // required method, empty implementation
    }
    
    // 4. Select "Fix" to add required makeCoordinator function.
    // Like makeUIViewController, this is called automatically when the ScannerView is created.
    func makeCoordinator() -> Coordinator {
        // Now the Coordinator is "listening" to the ScannerVC.
        Coordinator(scannerView: self)
    }
    
    // 3. If we put the class inside the struct, it is clear WHICH coordinator this is (if we have multiple).
    final class Coordinator: NSObject, ScannerVCDelegate {
        
        // 7. Now we can connect our Coordinator to our ScannerView.
        private let scannerView: ScannerView
        init (scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            // Coordinator needs to pass info to ScannerView.
            // 8. Now when we find the barcode, we will set it equal to the scanner view's scannedCode.
            // This is bound to scannedCode in BarcodeScannerView, which is a state variable and will update the UI accordingly.
            scannerView.scannedCode = barcode
        }
        
        // Set alertItem that corresponds to one of the error types in our CameraError enum.
        func didSurface(error: CameraError) {
            switch error {
            case .invalidDeviceInput:
                scannerView.alertItem = AlertContext.invalidDeviceInput
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScannedType
            }
        }
    }
}
