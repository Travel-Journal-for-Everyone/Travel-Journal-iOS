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
}

extension AuthAPI: EndPoint {
    var basePath: String { "/v1/auth" }
    
    var path: String {
        switch self {
        case .fetchJWTToken(let request): "/login/\(request.loginProvider)/id-token"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchJWTToken: nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchJWTToken: .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchJWTToken(let request): HeaderType.bearer(request.idToken).value
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchJWTToken: URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchJWTToken: nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchJWTToken: false
        }
    }
}
