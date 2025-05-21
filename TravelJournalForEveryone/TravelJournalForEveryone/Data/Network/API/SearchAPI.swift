//
//  SearchAPI.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import Foundation
import Alamofire

enum SearchType {
    case member
    case place
    case journal
    
    var path: String {
        switch self {
        case .member:
            "/members"
        case .place:
            "/places"
        case .journal:
            "/journals"
        }
    }
}

enum SearchAPI {
    case search(type: SearchType, request: SearchRequest)
}

extension SearchAPI: EndPoint {
    
    var basePath: String {
        return "/v1/search"
    }
    
    var path: String {
        switch self {
        case let .search(type, _):
            return type.path
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .search(_, let request):
            return [
                "keyword": "\(request.keyword)",
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .search:
            return nil
        }
    }
    
    var parameterEncoding: any Alamofire.ParameterEncoding {
        switch self {
        case .search:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Alamofire.Parameters? {
        switch self {
        case .search:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .search:
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
