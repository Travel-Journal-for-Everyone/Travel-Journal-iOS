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
    case updateProfile(ProfileInfoRequestDTO)
}

extension MemberAPI: EndPoint {
    var basePath: String {
        return "/v1/member"
    }
    
    var path: String {
        switch self {
        case .checkNickname(let nickname):
            return "/check-nickname/\(nickname)"
        case .updateProfile:
            return "/profile/update"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkNickname:
            return .get
        case .updateProfile:
            return .put
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .checkNickname:
            return nil
        case .updateProfile:
            return HeaderType.multipartForm.value
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .checkNickname:
            return URLEncoding.default
        case .updateProfile:
            return JSONEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .checkNickname:
            return nil
        case .updateProfile(let request):
            return [
                "nickname": request.nickname,
                "accountScope": request.accountScope.rawValue
            ]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        default:
            return true
        }
    }
    
    var multipartFormImage: (
        textTitle: String,
        imageTitle: String,
        imageData: Data?
    )? {
        switch self {
        case .updateProfile(let request):
            (textTitle: "profileRequest",
             imageTitle: "profileImage",
             imageData: request.imageData)
        default: nil
        }
    }
}
