//
//  Configuration.swift
//  LFPCenter
//
//  Created by IT-EFW-65-03 on 16/3/2566 BE.
//

import Foundation

enum Configuration: String {
    
    // MARK: - Configurations
    
    case debug
    case production
    case release
    
    // MARK: - Current Configuration
    
    static let current: Configuration = {
        guard let rawValue = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("No Configuration Found")
        }
        
        guard let configuration = Configuration(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }
        
        return configuration
    }()
    
    // MARK: - Base URL
    
    static var baseURL: String {
        switch current {
        case .debug:
            return "http://zaserzafear.thddns.net:9973"
        case .production, .release:
            return "http://zaserzafear.thddns.net:9973"
        }
    }
    
//    static var firebaseConfig: String {
//        switch current {
//        case .debug:
//            return Bundle.main.path(forResource: "GoogleService-Info-Demo", ofType: "plist") ?? "GoogleService-Info-Demo.plist"
//        case .production, .release:
//            return Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") ?? "GoogleService-Info.plist"
//        }
//    }
}
