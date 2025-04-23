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
    case fetchFollowers(FetchFollowRequest)
    case fetchFollowings(FetchFollowRequest)
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
        case .fetchFollowings(let request):
            "/\(request.memberID)/followings"
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
        case .fetchFollowings(let request):
            [
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings:
                .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings:
            nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings:
            URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings:
            nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings:
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
