//
//  AuthAPI.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/12/25.
//

import Foundation
import Alamofire

enum AuthAPI {
    case fetchJWTToken(FetchJWTTokenRequest)
    case logout(deviceID: String)
}

extension AuthAPI: EndPoint {
    var basePath: String { "/v1/auth" }
    
    var path: String {
        switch self {
        case .fetchJWTToken(let request): "/login/\(request.loginProvider)/id-token"
        case .logout: "/logout"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchJWTToken: nil
        case .logout(let deviceID):
            ["deviceId": deviceID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchJWTToken, .logout: .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchJWTToken(let request): HeaderType.bearer(request.idToken).value
        case .logout: HeaderType.basic.value
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchJWTToken, .logout: URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchJWTToken, .logout: nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchJWTToken: false
        case .logout: true
        }
    }
}
