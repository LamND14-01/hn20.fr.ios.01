//
//  Body.swift
//  handleError
//
//  Created by Nguyễn Lâm on 4/14/20.
//  Copyright © 2020 Nguyễn Lâm. All rights reserved.
//

import Foundation

struct ResponseData: Codable {
    let isClass : String
    let detail : String
    let trainer: Trainer?
    
    enum CodingKeys: String, CodingKey {
        case isClass = "class"
        case detail
        case trainer
    }
}

struct Trainer: Codable {
   let trainer: String
   let classCode: String
   let unit: String
    
    enum CodingKeys: String, CodingKey {
        case trainer
        case classCode = "class_code"
        case unit
    }
}
