//
//  Encodable + Extention.swift
//  LUMPSUM
//
//  Created by macbook-Art on 30/6/2565 BE.
//  Copyright © 2565 BE OnlineAsset. All rights reserved.
//

import Foundation

extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        //jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    var convertToData: Data {
        var strJson : String = ""
        
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            strJson = String(data: jsonData, encoding: String.Encoding.utf8)!
            
            
        }catch{}
        
        return (strJson).data(using: .utf8) ?? Data()
    }
    
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
//    static func convertStringToArray<T:Decodable>(_ jsonStr : String, type : T.Type) throws -> T {
//        let jsonData = jsonStr.data(using: .utf8)!
//        let decoder = JSONDecoder()
//        let obj = try! decoder.decode(type, from: jsonData)
//
//        return obj
//    }


}
