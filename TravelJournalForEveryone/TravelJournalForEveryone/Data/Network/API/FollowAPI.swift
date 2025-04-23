//
//  FollowAPI.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/23/25.
//

import Foundation
import Alamofire

enum FollowAPI {
    case fetchFollowCount(memberID: Int)
}

extension FollowAPI: EndPoint {
    var basePath: String {
        return "/v1/follow"
    }
    
    var path: String {
        switch self {
        case .fetchFollowCount(let memberID):
            "/\(memberID)/count"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchFollowCount:
            nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchFollowCount:
                .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchFollowCount:
            nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchFollowCount:
            URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchFollowCount:
            nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchFollowCount:
            true
        }
    }
    
    var multipartFormImage: (
        textTitle: String,
        imageTitle: String,
        imageData: Data?
    )? {
        nil
    }
}
