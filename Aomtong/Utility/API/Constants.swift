//
//  Constants.swift
//  demoFirebase
//
//  Created by IT-EFW-65-03 on 3/11/2565 BE.
//

import Foundation
import UIKit

struct Constants {
    static let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //The API's base URL
    static let baseUrl = Configuration.baseURL
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let userId = "userId"
        static let parameter = "param"
    }
    
    //static let cryptLib = CryptLib()
    
    //    static let key = "lumpsum3805325"
    //    static let keySHA256 = {
    //        return cryptLib.sha256(Constants.key, length: 32)
    //    }
    
    //The header fields
    enum HttpHeaderField: String {
//        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
//        case acceptEncoding = "Accept-Encoding"
//        case lumpsum_unique_id = "lumpsum_unique_id"
//        case lumpsum_token_id = "lumpsum_token_id"
//        case app_version = "app_version"
//        case device = "device"
//        case os_version = "os_version"
//        case os_type = "os_type"
//        case lumpsum_email = "lumpsum_email"
//        case lang = "lang"
//        case user_id = "user_id"
//        case user_token = "user_token"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json
//        case lumpsum_unique_id
//        case lumpsum_token_id
//        case app_version
//        case device
//        case os_version
//        case os_type
//        case lumpsum_email
//        case lang
//        case user_id
//        case user_token
        
        var rawValue: String {
            get {
                switch self {
                case .json:
                    return "application/json; charset=utf-8"
//                case .lumpsum_unique_id:
//                    return ""
//                case .lumpsum_token_id:
//                    return ""
//                case .app_version:
//                    return ""
//                case .device:
//                    return ""
//                case .os_version:
//                    return ""
//                case .os_type:
//                    return ""
//                case .lumpsum_email:
//                    return ""
//                case .lang:
//                    return ""
//                case .user_id:
//                    return ""
//                case .user_token:
//                    return ""
                }
            }
        }
    }
    
    enum APIService: String {
        case booking = "bookingapi"
        case product = "productapi"
        case authentication = "authenticationapi"
    }
}
