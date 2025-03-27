//
//  MemberAPI.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/12/25.
//

import Foundation
import Alamofire

enum MemberAPI {
    case checkNickname(String)
    case signUp(SignUpRequestDTO)
}

extension MemberAPI: EndPoint {
    var basePath: String {
        return "/v1/member"
    }
    
    var path: String {
        switch self {
        case .checkNickname(let nickname):
            return "/check-nickname/\(nickname)"
        case .signUp:
            return "/complete-first-login"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .checkNickname, .signUp:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkNickname:
            return .get
        case .signUp:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .checkNickname, .signUp:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .checkNickname:
            return URLEncoding.default
        case .signUp:
            return JSONEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .checkNickname:
            return nil
        case .signUp(let request):
            return [
                "nickname": request.nickname,
                "accountScope": request.accountScope.rawValue
            ]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .checkNickname, .signUp:
            return true
        }
    }
}
