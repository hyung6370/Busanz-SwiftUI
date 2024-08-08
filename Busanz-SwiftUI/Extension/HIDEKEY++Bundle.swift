//
//  HIDEKEY++Bundle.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/8/24.
//

import Foundation

extension Bundle {
    var NMAP_CLIENT_ID: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Secret", ofType: "plist") else {
                fatalError("Couldn't find file 'Secret.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "NMAP_CLIENT_ID") as? String else {
                fatalError("Couldn't find key 'NMAP_CLIENT_ID' in 'Secret.plist'.")
            }
            return value
        }
    }

    var NMAP_CLIENT_SECRET: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Secret", ofType: "plist") else {
                fatalError("Couldn't find file 'Secret.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "NMAP_CLIENT_SECRET") as? String else {
                fatalError("Couldn't find key 'NMAP_CLIENT_SECRET' in 'Secret.plist'.")
            }
            return value
        }
    }
}
