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

final class DefaultNetworkService: NetworkService {
    private let interceptor: RequestInterceptor?
    
    init() {
        let accessToken = try? KeychainManager.load(forAccount: .accessToken).get()
        let refreshToken = try? KeychainManager.load(forAccount: .refreshToken).get()
        
        let credential = OAuthCredential(
            accessToken: accessToken ?? "",
            refreshToken: refreshToken ?? ""
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
        do {
            return try makeRequest(endPoint)
                .validate()
                .publishDecodable(type: T.self)
                .tryMap { dataResponse in
                    guard let httpResponse = dataResponse.response,
                          let data = dataResponse.data
                    else {
                        throw NetworkError.invalidResponse
                    }
                    
                    self.extractAccessToken(from: httpResponse)
                    
                    //TODO: 임시로 String 디코딩 처리함. 추후 수정
                    if decodingType == String.self,
                       let stringResponse = String(data: data, encoding: .utf8) {
                        return stringResponse as! T
                    }
                    
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
        } catch {
            return Fail(error: NetworkError.imageUploadFailed)
                .eraseToAnyPublisher()
        }
    }
    
    private func makeRequest(_ endPoint: EndPoint) throws -> DataRequest {
        if let imageData = endPoint.multipartFormImage {
            guard let bodyParameters = endPoint.bodyParameters,
                  let jsonData = try? JSONSerialization.data(withJSONObject: bodyParameters),
                  let jsonString = String(data: jsonData, encoding: .utf8)
            else {
                throw NetworkError.imageUploadFailed
            }
            
            return AFSession.session.upload(
                multipartFormData: { multipartFormData in
                    // object
                    multipartFormData.append(
                        jsonString.data(using: .utf8)!,
                        withName: imageData.textTitle
                    )
                    
                    // image
                    // TODO: 이미지 여러개 올리는 건 추후 구현해야 함
                    if let image = imageData.imageData {
                        multipartFormData.append(
                            image,
                            withName: imageData.imageTitle,
                            fileName: "image.jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                },
                to: endPoint.requestURL,
                method: endPoint.method,
                headers: endPoint.headers,
                interceptor: endPoint.requiresAuth ? interceptor : nil
            )
        } else {
            return AFSession.session.request(
                endPoint.requestURL,
                method: endPoint.method,
                parameters: endPoint.bodyParameters,
                encoding: endPoint.parameterEncoding,
                headers: endPoint.headers,
                interceptor: endPoint.requiresAuth ? interceptor : nil
            )
        }
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
