//
//  EndPoint.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/4/25.
//

import Foundation
import Alamofire

protocol EndPoint {
    /// API를 요청하는 URL 주소의 host 부분을 입력합니다.
    /// 예를 들면, https://api.maru.hello/ 라는 URL 주소에서
    /// api.maru.hello 이 host 부분입니다.
    var hostURL: String { get }
    /// API를 요청하는 URL 주소의 path 부분을 입력합니다.
    /// 앞에 슬래쉬(/) 를 반드시 붙여야 합니다.
    var path: String { get }
    /// API를 요청하는 URL 주소의 Query Parameter 부분을 입력합니다.
    /// Query Parameter가 필요없다면 nil을 입력합니다.
    var queryParameters: [String: String]? { get }
    var requestURL: URL { get }
    var method: HTTPMethod { get }
    /// Request의 Header 부분을 입력합니다.
    /// [String: String] 타입으로 입력합니다.
    /// Header가 필요없다면 nil을 입력합니다.
    var headers: HTTPHeaders? { get }
    var parameterEncoding: ParameterEncoding { get }
    /// Request의 Body Parameter 를 입력합니다.
    /// [String: any Sendable] 타입으로 입력합니다.
    /// Body Parameter가 필요없다면 nil을 입력합니다.
    var bodyParameters: Parameters? { get }
    /// API를 요청할 때, 헤더에 엑세스 토큰 정보를 함께 보내야 한다면 true로 설정합니다.
    /// 그렇지 않다면 false로 설정합니다.
    var requiresAuth: Bool { get }
}

extension EndPoint {
    var requestURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.hostURL
        components.path = self.path
        
        guard let queryParameters else { return components.url ?? URL(string: " ")! }
        components.queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url ?? URL(string: " ")!
    }
}
