//
//  MembersAPI.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/27/25.
//

import Foundation
import Alamofire

enum MembersAPI {
    case fetchUser(memberID: Int)
}

extension MembersAPI: EndPoint {
    var basePath: String {
        return "/v1/members"
    }
    
    var path: String {
        switch self {
        case .fetchUser(let memberID):
            return "/\(memberID)"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchUser:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUser:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchUser:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchUser:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchUser:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchUser:
            return true
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
