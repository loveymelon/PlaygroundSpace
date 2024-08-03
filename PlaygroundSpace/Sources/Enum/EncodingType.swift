//
//  EncodingType.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import Alamofire

enum EncodingType {
    case url
    case json
    case multiPart(MultipartFormData)
}
