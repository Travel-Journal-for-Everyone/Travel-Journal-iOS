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
    
    case follow(memberID: Int)
    case unfollow(memberID: Int)
    case isFollowing(memberID: Int)
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
        case .follow(let memberID), .unfollow(let memberID):
            "/\(memberID)"
        case .isFollowing(let memberID):
            "/\(memberID)/is-following"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchFollowCount, .follow, .unfollow, .isFollowing:
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
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings, .isFollowing:
                .get
        case .follow:
                .post
        case .unfollow:
                .delete
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings, .follow, .unfollow, .isFollowing:
            nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings, .follow, .unfollow, .isFollowing:
            URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings, .follow, .unfollow, .isFollowing:
            nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchFollowCount, .fetchFollowers, .fetchFollowings, .follow, .unfollow, .isFollowing:
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
