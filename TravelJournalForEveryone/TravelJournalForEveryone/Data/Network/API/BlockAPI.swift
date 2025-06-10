//
//  BlockAPI.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/28/25.
//

import Foundation
import Alamofire

enum BlockAPI {
    case blockUser(id: Int)
    case unblockUser(id: Int)
    case fetchBlockedUsers(FetchBlockedUsersRequest)
}

extension BlockAPI: EndPoint {
    var basePath: String {
        return "/v1/block"
    }
    
    var path: String {
        switch self {
        case .blockUser(let id), .unblockUser(let id):
            return "/\(id)"
        case .fetchBlockedUsers:
            return "/list"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .blockUser, .unblockUser:
            return nil
        case .fetchBlockedUsers(let request):
            return [
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .blockUser:
            return .post
        case .unblockUser:
            return .delete
        case .fetchBlockedUsers:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .blockUser, .unblockUser, .fetchBlockedUsers:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .blockUser, .unblockUser, .fetchBlockedUsers:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .blockUser, .unblockUser, .fetchBlockedUsers:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .blockUser, .unblockUser, .fetchBlockedUsers:
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
