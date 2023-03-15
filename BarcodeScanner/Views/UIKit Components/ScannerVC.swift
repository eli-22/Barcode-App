//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Elise on 12/28/22.
//

import Foundation
import UIKit
import AVFoundation

// UIKit communicates with SwiftUI through delegates and protocols.
// The Delegate is the coordinator in the middle. It passes information between the VC and the SwiftUI View.

// Deleted raw values and moved to AlertContext.
enum CameraError {
    case invalidDeviceInput
    case invalidScannedValue
}

// No implementation here, just a list of commands.
protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    // When the camera successfully scans a barcode, it returns it as a string.
    // The VC will then send that string to the delegate, which will send it to the SwiftUI view.
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    let captureSession = AVCaptureSession()
    // What is actually captured on the camera.
    
    var previewLayer: AVCaptureVideoPreviewLayer? // We don't have it right away.
    // Shows the preview on the screen before the camera takes a picture.
    
    weak var scannerDelegate: ScannerVCDelegate?
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    // Set up preview layer. 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    // All checks go in this function.
    private func setupCaptureSession() {
        
        // Do we have a device that can capture video?
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        // Make sure we can get input from the device.
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        // Make sure we can add the output.
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
            // Array of the types of barcodes we want to scan.
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        // Fill the available view while maintaining aspect ratio.
        
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        // Will capture continuously until stopped.

    }
}

// Create extension to conform to delegate.
extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Do we have a metadata object in the array? Get the first one.
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // Is it type AVMetadataMachineReadableCodeObject?
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // Get string value.
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        //captureSession.stopRunning()
        // To implement this, we need to add functionality to restart. 
        
        // Send string value to delegate.
        scannerDelegate?.didFind(barcode: barcode)
    }
}
