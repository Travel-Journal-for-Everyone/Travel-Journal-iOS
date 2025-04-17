//
//  AuthAPI.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/12/25.
//

import Foundation
import Alamofire

enum AuthAPI {
    case loginByIDToken(LoginRequest)
    case logout(deviceID: String)
    case unlink(socialProvider: String)
}

extension AuthAPI: EndPoint {
    var basePath: String { "/v1/auth" }
    
    var path: String {
        switch self {
        case .loginByIDToken(let request): "/login/\(request.loginProvider)/id-token"
        case .logout: "/logout"
        case .unlink(let provider): "/\(provider)/unlink"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .loginByIDToken, .unlink: nil
        case .logout(let deviceID):
            ["deviceId": deviceID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .loginByIDToken, .logout: .post
        case .unlink: .delete
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .loginByIDToken(let request): HeaderType.bearer(request.idToken).value
        case .logout, .unlink: HeaderType.basic.value
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .loginByIDToken, .logout: URLEncoding.default
        case .unlink: JSONEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .loginByIDToken, .logout, .unlink: nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .loginByIDToken: false
        case .logout, .unlink: true
        }
    }

    var multipartFormImage: (
        textTitle: String,
        imageTitle: String,
        imageData: Data?
    )? {
        return nil
    }
}
