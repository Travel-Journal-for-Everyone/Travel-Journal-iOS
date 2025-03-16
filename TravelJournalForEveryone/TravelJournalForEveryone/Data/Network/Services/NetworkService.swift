//
//  NetworkService.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/4/25.
//

import Foundation
import Combine
import Alamofire

protocol NetworkService {
    func request<T: Decodable & Sendable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError>
}

final class AFSession {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let logger = NetworkEventMonitor()
        return Session(configuration: configuration, eventMonitors: [logger])
    }()
}

final class DefaultNetworkService: NetworkService {
    private let interceptor: RequestInterceptor?
    
    init() {
        let credential = OAuthCredential(
            accessToken: KeychainManager.load(forAccount: .accessToken) ?? "",
            refreshToken: KeychainManager.load(forAccount: .refreshToken) ?? ""
        )
        let authenticator = OAuthAuthenticator()
        
        self.interceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
    }
    
    func request<T: Decodable & Sendable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        return AFSession.session.request(
            endPoint.requestURL,
            method: endPoint.method,
            parameters: endPoint.bodyParameters,
            encoding: endPoint.parameterEncoding,
            headers: endPoint.headers,
            interceptor: endPoint.requiresAuth ? interceptor : nil
        )
        .validate()
        .publishDecodable(type: T.self)
        .tryMap { dataResponse in
            guard let httpResponse = dataResponse.response,
                  let data = dataResponse.data
            else {
                throw NetworkError.invalidResponse
            }
            
            self.extractAccessToken(from: httpResponse)
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let decodedData = dataResponse.value else {
                    throw NetworkError.decodingFailed(data)
                }
                return decodedData
            default:
                guard let afError = dataResponse.error else {
                    throw NetworkError.unknownError(dataResponse.error ?? NSError())
                }
                throw self.handleStatusCode(
                    httpResponse.statusCode,
                    data: data,
                    afError: afError
                )
            }
        }
        .mapError { error in
            return error as? NetworkError ?? .unknownError(error)
        }
        .eraseToAnyPublisher()
    }
    
    private func extractAccessToken(from response: HTTPURLResponse) {
        guard let authorizationValue = response.value(forHTTPHeaderField: "Authorization"),
              authorizationValue.hasPrefix("Bearer ")
        else { return }
        
        let accessToken = authorizationValue.replacingOccurrences(of: "Bearer ", with: "")
        
        #if DEBUG
        print("📌 Updated Access Token: \(accessToken)")
        #endif
        
        KeychainManager.save(
            forAccount: .accessToken,
            value: accessToken
        )
    }
    
    private func handleStatusCode(
        _ statusCode: Int,
        data: Data,
        afError: AFError
    ) -> NetworkError {
        let errorMessage = extractErrorMessage(from: data)
        
        switch (statusCode, errorMessage) {
        case (409, "duplicate"):
            return .invalidNickname(reason: errorMessage)
        case (409, "containsBadWord"):
            return .invalidNickname(reason: errorMessage)
        case(_, "Failed to decode error response"):
            return .decodingFailed(data)
        default:
            return .unknownError(afError)
        }
    }
    
    private func extractErrorMessage(from data: Data) -> String {
        guard let errorResponse = try? JSONDecoder().decode(
            ErrorResponseDTO.self,
            from: data
        ) else {
            return "Failed to decode error response"
        }
        
        return errorResponse.message
    }
}
