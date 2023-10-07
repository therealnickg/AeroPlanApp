//
//  DataStorageManager.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 10/6/23.
//

import Foundation

class DataStorageManager {
    // Define a file URL where you want to store the data.
    private let fileURL: URL

    init(fileName: String) {
        // Get the document directory path
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Append the file name to the document directory path to create the complete file URL.
            self.fileURL = documentDirectory.appendingPathComponent(fileName)
        } else {
            fatalError("Could not determine the document directory.")
        }
    }

    // Write data to the file
    func writeData(_ data: Data) {
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error writing data to file: \(error)")
        }
    }

    // Read data from the file
    func readData() -> Data? {
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Error reading data from file: \(error)")
            return nil
        }
    }
}
