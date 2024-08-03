//
//  KingfisherRequestModifier.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/3/24.
//

import Kingfisher
import Foundation

final class KFImageRequestModifier: ImageDownloadRequestModifier {
    
    private
    let baseURL = APIKey.baseURL
    
    private
    let version = APIKey.version
    
    func modified(for request: URLRequest) -> URLRequest? {
        
        let accessToken = UserDefaultsManager.shared.accessToken
        
        // URLComponents url를 좀더 분리하는 것이다. 포트번호, 스키마, 호스트등으로
        guard var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        if !urlComponents.path.contains(version) {
            urlComponents.path = version + urlComponents.path
        } // 버전이 없을때 추가하는 부분이다.
        
        if let baseURLComponents = URLComponents(string: baseURL) {
            urlComponents.scheme = baseURLComponents.scheme
            urlComponents.host = baseURLComponents.host
            urlComponents.port = baseURLComponents.port
        } // 실수 방지
        print("urlComponents KJS Win", urlComponents.url)
        guard let modifiedURL = urlComponents.url else {
            print("here KJS")
            return nil
        }
        
        var urlRequest = URLRequest(url: modifiedURL) // 헤더랑 바디를 넣으면 URLRequest
        
        urlRequest.addValue(accessToken, forHTTPHeaderField: HeaderType.auth)
        urlRequest.addValue(APIKey.secretKey, forHTTPHeaderField: HeaderType.secretHeader)
        
        print("request", urlRequest)
        
        return urlRequest
    }
}
