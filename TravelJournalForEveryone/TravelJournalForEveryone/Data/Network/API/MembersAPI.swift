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
    case fetchJournalList(FetchJournalsRequest)
}

extension MembersAPI: EndPoint {
    var basePath: String {
        return "/v1/members"
    }
    
    var path: String {
        switch self {
        case .fetchUser(let memberID):
            return "/\(memberID)"
        case .fetchJournalList(let request):
            return "/\(request.memberID)/journals/region/\(request.regionName)"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchUser:
            return nil
        case .fetchJournalList(let request):
            return [
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUser, .fetchJournalList:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchUser, .fetchJournalList:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchUser, .fetchJournalList:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchUser, .fetchJournalList:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchUser, .fetchJournalList:
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
