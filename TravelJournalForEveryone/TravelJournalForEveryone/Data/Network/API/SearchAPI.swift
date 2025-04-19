//
//  SearchAPI.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation
import Alamofire

enum SearchAPI {
    case searchMembers(SearchMembersRequest)
}

extension SearchAPI: EndPoint {
    var basePath: String {
        return "/v1/search"
    }
    
    var path: String {
        switch self {
        case .searchMembers(let request):
            return "/members"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .searchMembers(let request):
            return [
                "keyword": "\(request.keyword)",
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .searchMembers:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .searchMembers:
            return nil
        }
    }
    
    var parameterEncoding: any Alamofire.ParameterEncoding {
        switch self {
        case .searchMembers:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Alamofire.Parameters? {
        switch self {
        case .searchMembers:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .searchMembers:
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
