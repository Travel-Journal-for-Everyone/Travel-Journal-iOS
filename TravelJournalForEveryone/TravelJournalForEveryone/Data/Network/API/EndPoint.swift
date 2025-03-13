//
//  EndPoint.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/4/25.
//

import Foundation
import Alamofire

protocol EndPoint {
    var hostURL: String { get }
    var basePath: String { get }
    var path: String { get }
    var queryParameters: [String: String]? { get }
    var requestURL: URL { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameterEncoding: ParameterEncoding { get }
    var bodyParameters: Parameters? { get }
    var requiresAuth: Bool { get }
}

extension EndPoint {
    var hostURL: String {
        Bundle.main.serverHostURL
    }
    
    var requestURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.hostURL
        components.path = self.basePath + self.path
        
        guard let queryParameters else { return components.url ?? URL(string: " ")! }
        components.queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url ?? URL(string: " ")!
    }
}

enum HeaderType {
    case basic
    case bearer(String)
    
    var value: HTTPHeaders {
        switch self {
        case .basic:
            ["Content-Type": "application/json"]
        case .bearer(let string):
            [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(string)",
                "X-Platform": "ios"
            ]
        }
    }
}
