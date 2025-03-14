//
//  MemberAPI.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/12/25.
//

import Foundation
import Alamofire

enum MemberAPI: EndPoint {
    case checkNickname(String)
    case completeFirstLogin(CompleteFirstLoginRequestDTO)
}

extension MemberAPI {
    var basePath: String {
        return "/v1/member"
    }
    
    var path: String {
        switch self {
        case .checkNickname(let nickname):
            return "/check-nickname/\(nickname)"
        case .completeFirstLogin:
            return "/complete-first-login"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .checkNickname, .completeFirstLogin:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkNickname:
            return .get
        case .completeFirstLogin:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .checkNickname, .completeFirstLogin:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .checkNickname:
            return URLEncoding.default
        case .completeFirstLogin:
            return JSONEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .checkNickname:
            return nil
        case .completeFirstLogin(let request):
            params["nickname"] = request.nickname
            params["accountScope"] = request.accountScope.key
            return params
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .checkNickname, .completeFirstLogin:
            return true
        }
    }
    
}
