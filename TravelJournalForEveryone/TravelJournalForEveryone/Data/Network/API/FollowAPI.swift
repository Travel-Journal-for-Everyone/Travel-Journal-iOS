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
    case fetchFollowers(FetchFollowersRequest)
}

extension FollowAPI: EndPoint {
    var basePath: String {
        return "/v1/follow"
    }
    
    var path: String {
        switch self {
        case .fetchFollowCount(let memberID):
            "/\(memberID)/count"
        case .fetchFollowers(let request):
            "/\(request.memberID)/followers"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchFollowCount:
            nil
        case .fetchFollowers(let request):
            [
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchFollowCount, .fetchFollowers:
                .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchFollowCount, .fetchFollowers:
            nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchFollowCount, .fetchFollowers:
            URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchFollowCount, .fetchFollowers:
            nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchFollowCount, .fetchFollowers:
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
