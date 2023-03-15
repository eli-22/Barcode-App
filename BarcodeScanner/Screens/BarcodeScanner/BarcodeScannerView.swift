//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Elise on 12/27/22.
//

import SwiftUI

struct BarcodeScannerView: View {
    
    // Creating a new view model -> @StateObject
    // Passing in a view model -> @ObservedObject
    @StateObject var viewModel = BarcodeScannerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedCode: $viewModel.scannedCode, alertItem: $viewModel.alertItem)
                    .frame(maxHeight: 300)
                // .infinity for width will fill the screen.
                // BUT we don't need it, because that's the default for this view.
                // We don't want the height to be larger than 300 no matter what size the screen is, because the barcode is only so big.
                
                Spacer().frame(height: 60)
            
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                // Label shows text and image. Can use same modifiers as Text.
                // systemImage comes from SF Symbols.
                Text(viewModel.statusText)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(viewModel.statusTextColor)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
        }
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
