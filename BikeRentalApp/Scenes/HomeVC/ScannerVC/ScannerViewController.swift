//
//  ScannerViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 20.07.24.
//

import UIKit
import VisionKit

class ScannerViewController: UIViewController {

    var scannerAvailable: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanner()
        
    }
    
    func setupScanner() {
        let dataScanner = DataScannerViewController(recognizedDataTypes: [.barcode()], isHighlightingEnabled: true)
        present(dataScanner, animated: true) {
            try? dataScanner.startScanning()
        }
    }

}
