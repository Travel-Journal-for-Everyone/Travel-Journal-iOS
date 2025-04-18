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
    case fetchJournals(FetchJournalsRequest)
    case fetchPlaces(FetchPlacesRequest)
}

extension MembersAPI: EndPoint {
    var basePath: String {
        return "/v1/members"
    }
    
    var path: String {
        switch self {
        case .fetchUser(let memberID):
            return "/\(memberID)"
        case .fetchJournals(let request):
            if let regionName = request.regionName {
                return "/\(request.memberID)/journals/region/\(regionName)"
            } else {
                return "/\(request.memberID)/journals"
            }
        case .fetchPlaces(let request):
            if let regionName = request.regionName {
                return "/\(request.memberID)/places/region/\(regionName)"
            } else {
                return "/\(request.memberID)/places"
            }
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchUser:
            return nil
        case .fetchJournals(let request):
            return [
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        case .fetchPlaces(let request):
            return [
                "page": "\(request.pageNumber)",
                "size": "\(request.pageSize)"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUser, .fetchJournals, .fetchPlaces:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchUser, .fetchJournals, .fetchPlaces:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchUser, .fetchJournals, .fetchPlaces:
            return URLEncoding.default
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchUser, .fetchJournals, .fetchPlaces:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .fetchUser, .fetchJournals, .fetchPlaces:
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
