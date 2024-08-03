//
//  RouterProtocol.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/27/24.
//

import Foundation
import Alamofire

protocol Router {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var defaultHeader: HTTPHeaders { get }
    var optionalHeaders: HTTPHeaders? { get } // secretHeader 말고도 추가적인 헤더가 필요시
    var headers: HTTPHeaders { get } // 다 합쳐진 헤더
    var parameters: Parameters? { get }
    var body: Data? { get }
    var encodingType: EncodingType { get }
}

extension Router {
    
    var baseURL: String {
        return APIKey.baseURL
    }
    
    var defaultHeader: HTTPHeaders {
        return [HeaderType.secretHeader : APIKey.secretKey]
    }
    
    var headers: HTTPHeaders {
        var combine = defaultHeader
        if let optionalHeaders {
            optionalHeaders.forEach { header in
                combine.add(header)
            }
        }
        print("헤더 합침: ",combine)
        return combine
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = try URLRequest(url: url.appending(path: path), method: method, headers: headers)
        
        switch encodingType {
        case .url:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            return urlRequest
        case .json:
            let jsonObject = try JSONSerialization.jsonObject(with: body!, options: [])
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: jsonObject)
            return urlRequest
        case .multiPart:
            return urlRequest
        }
    }

    func requestToBody(_ request: RequestDTO) -> Data? {
        return JSONManager.shared.encoder(data: request)
    }
    
}
