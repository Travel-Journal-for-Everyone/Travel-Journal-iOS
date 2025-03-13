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
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .checkNickname:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        //TODO: 임시
        return HeaderType.bearer(KeychainManager.load(forAccount: .accessToken) ?? "").value
    }
    
    var parameterEncoding: any Alamofire.ParameterEncoding {
        switch self {
        case .checkNickname:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Alamofire.Parameters? {
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
