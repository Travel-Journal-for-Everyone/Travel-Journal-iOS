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
    case signUp(SignUpRequestDTO, Data?)
    // TODO: 백엔드 API 작업 완료 후 전체적으로 맞는지 확인하기!!!
    case fetchUser(memberID: Int)
}

extension MemberAPI {
    var basePath: String {
        return "/v1/member"
    }
    
    var path: String {
        switch self {
        case .checkNickname(let nickname):
            return "/check-nickname/\(nickname)"
        case .signUp:
            return "/complete-first-login"
        case .fetchUser(let memberID):
            return "/\(memberID)"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .checkNickname, .signUp, .fetchUser:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkNickname, .fetchUser:
            return .get
        case .signUp:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .checkNickname, .fetchUser:
            return nil
        case .signUp:
            return HeaderType.multipartForm.value
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .checkNickname, .fetchUser:
            return URLEncoding.default
        case .signUp:
            return JSONEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .checkNickname, .fetchUser:
            return nil
        case .signUp(let request, _):
            return [
                "nickname": request.nickname,
                "accountScope": request.accountScope.rawValue
            ]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        default: true
        }
    }
    
    var multipartFormImage: (String, String, Data?)? {
        switch self {
        case .signUp(_, let image): ("firstLoginRequest", "profileImage", image)
        default: nil
        }
    }
}
