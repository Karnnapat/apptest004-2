//
//  ApiModel.swift
//  LUMPSUM
//
//  Created by IT-EFW-65-03 on 21/11/2565 BE.
//  Copyright © 2565 BE OnlineAsset. All rights reserved.
//

import Foundation

struct ApiModel : Codable {
    var cmd : String = ""
    var result: Bool = false
    var status: String = ""
    var msg: String = ""
    var token : String = ""
    var data : String = ""
    var lasted_token : String = ""
}

struct BaseResponse: Codable {
    var message: String? = ""
    var success: Bool? = false
    var status: Int? = 0
}
