//
//  NetworkService.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/4/25.
//

import Foundation
import Combine
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingError(error: Error)
    case networkingError(error: Error)
}

protocol NetworkService {
    func request<T: Decodable & Sendable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError>
}

final class DefaultNetworkService: NetworkService {
    func request<T: Decodable & Sendable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        return AF.request(
            endPoint.requestURL,
            method: endPoint.method,
            parameters: endPoint.bodyParameters,
            encoding: endPoint.parameterEncoding,
            headers: endPoint.headers
        )
        .validate()
        .publishDecodable(type: T.self)
        .value()
        /* 간단한 에러처리 방식
         .mapError { error in
         print(error.localizedDescription)
         return NetworkError.networkingError(error: error)
         }
         */
        .mapError { afError -> NetworkError in
            switch afError {
            case .invalidURL(let url):
                print("Invalid URL: \(url)")
                return .invalidURL
            case .responseValidationFailed(let reason):
                switch reason {
                case .unacceptableStatusCode(let code):
                    if code == 401 { return .unauthorized }
                    if code == 403 { return .forbidden }
                    if code == 404 { return .notFound }
                    if code >= 500 { return .serverError(statusCode: code) }
                    return .networkingError(error: afError)
                default:
                    return .networkingError(error: afError)
                }
            case .responseSerializationFailed(reason: let reason):
                return .decodingError(error: reason as! Error)
            default:
                return .networkingError(error: afError)
            }
        }
        .eraseToAnyPublisher()
    }
}
