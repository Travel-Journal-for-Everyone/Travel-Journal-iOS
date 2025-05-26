//
//  ExploreAPI.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/17/25.
//

import Foundation
import Alamofire

enum ExploreAPI {
    case fetchExploreJournals(FetchExploreJournalsRequest)
    case markJournalsAsSeen(journalIDs: [Int])
}

extension ExploreAPI: EndPoint {
    var basePath: String {
        return "/v1/explore/journals"
    }
    
    var path: String {
        switch self {
        case .fetchExploreJournals: return "/feed"
        case .markJournalsAsSeen: return "/seen"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchExploreJournals(let request):
            return [
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        case .markJournalsAsSeen:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchExploreJournals:
            return .get
        case .markJournalsAsSeen:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchExploreJournals, .markJournalsAsSeen:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchExploreJournals:
            return URLEncoding.default
        case .markJournalsAsSeen:
            return JSONEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchExploreJournals:
            return nil
        case .markJournalsAsSeen(let feedIDs):
            return [
                "journalIds": feedIDs
            ]
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchExploreJournals, .markJournalsAsSeen:
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
