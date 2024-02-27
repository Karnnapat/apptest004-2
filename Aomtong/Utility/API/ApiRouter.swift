//
//  ApiRouter.swift
//  demoFirebase
//
//  Created by IT-EFW-65-03 on 3/11/2565 BE.
//

import Foundation
import Alamofire
import KeychainSwift

enum ApiRouter: URLRequestConvertible {
    
    //The endpoint name we'll call later
    case Post(data: Data, urlApi: String)
    case Patch(urlApi: String)
    case Get(urlApi: String)
    case Delete(data: Data, urlApi: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: url)
        
        var urlRequest = URLRequest(url: url?.appendingPathComponent(path) ?? URL(fileURLWithPath: ""))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
       
//        let keychain = KeychainSwift()
//        let jwtToken : String = keychain.get("jwtToken") ?? ""
//        urlRequest.headers.add(.authorization(bearerToken: jwtToken))
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        switch self {
//        case .PostVBWS:
//            urlRequest.setValue(Constants.ContentType.lumpsum_unique_id.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.lumpsum_unique_id.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.lumpsum_token_id.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.lumpsum_token_id.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.app_version.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.app_version.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.device.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.device.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.os_version.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.os_version.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.os_type.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.os_type.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.lumpsum_email.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.lumpsum_email.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.lang.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.lang.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.user_id.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.user_id.rawValue)
//            
//            urlRequest.setValue(Constants.ContentType.user_token.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.user_token.rawValue)
//            
//            return try encoding.encode(urlRequest, with: parameters)
            
        case .Post, .Delete:
            urlRequest.httpBody = body
            
            return try encoding.encode(urlRequest, with: nil)
        case .Get, .Patch:
            return try encoding.encode(urlRequest, with: nil)
        }
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .Get:
            return .get
        case .Post:
            return .post
//        case .PostVBWS:
//            return .post
        case .Delete:
            return .delete
        case .Patch:
            return .patch
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    private var path: String {
        switch self {
//        case .PostVBWS:
//            return "/GetCmdValue"
        case .Post(data: _, urlApi: let urlApi):
            return urlApi
        case .Get(urlApi: let urlApi):
            return urlApi
        case .Delete(data: _, urlApi: let urlApi):
            return urlApi
        case .Patch(urlApi: let urlApi):
            return urlApi
        }
    }
    
    //MARK: - Url
    //The path is the part following the base url
    private var url: String {
        switch self {
//        case .PostVBWS:
//            return Constants.baseUrl
        case .Post:
            return Constants.baseUrl
        case .Get:
            return Constants.baseUrl
        case .Delete:
            return Constants.baseUrl
        case .Patch:
            return Constants.baseUrl
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        switch self {
//        case .PostVBWS(let param):
//            //A dictionary of the key (From the constants file) and its value is returned
//            var parameter : String = ""
//            
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: param)
//                if let json = String(data: jsonData, encoding: .utf8) {
//                    parameter = json
//                    _ = json.data(using: .utf8)
////                    let dataEn = Constants.cryptLib.encrypt(data, key: Constants.keySHA256(), iv: "")
////                    parameter = dataEn?.base64EncodedString(options: .endLineWithCarriageReturn) ?? ""
//                }
//            } catch {
//                parameter = ""
//            }
//            
//            return [Constants.Parameters.parameter: parameter]
            
        case .Post, .Delete, .Get, .Patch:
            return nil
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var body: Data? {
        switch self {
//        case .PostVBWS:
//            return Data()
        case .Get(urlApi: _):
            return nil
        case .Post(data: let data, urlApi: _):
            return data
        case .Delete(data: let data, urlApi: _):
            return data
        case .Patch(urlApi: _):
            return nil
        }
    }
}
