//
//  TokenAPI.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/13/25.
//

import Foundation
import Alamofire

enum TokenAPI {
    case refreshJWTToken(RefreshJWTTokenRequestDTO)
}

extension TokenAPI: EndPoint {
    var basePath: String { "/v1/tokens" }
    
    var path: String {
        switch self {
        case .refreshJWTToken: "/reissue"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .refreshJWTToken: nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refreshJWTToken: .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .refreshJWTToken: nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .refreshJWTToken: JSONEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .refreshJWTToken(let requestDTO):
            ["refreshToken": requestDTO.refreshToken, "deviceId": requestDTO.deviceID]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .refreshJWTToken: false
        }
    }
}
