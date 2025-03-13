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
}

extension MemberAPI {
    var basePath: String {
        return "/v1/member"
    }
    
    var path: String {
        switch self {
        case .checkNickname(let nickname):
            return "/check-nickname/\(nickname)"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .checkNickname:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkNickname:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .checkNickname:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .checkNickname:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .checkNickname:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .checkNickname:
            return true
        }
    }
    
}
