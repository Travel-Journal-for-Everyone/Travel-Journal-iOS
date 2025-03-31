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
    func request(_ endPoint: EndPoint) -> AnyPublisher<String, NetworkError>
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
    
    func request(_ endPoint: EndPoint) -> AnyPublisher<String, NetworkError> {
        do {
            return try makeRequest(endPoint)
                .validate()
                .publishString()
                .tryMap { dataResponse in
                    switch dataResponse.result {
                    case .success(let stringResponse):
                        return stringResponse
                    case .failure:
                        guard let stringData = dataResponse.data else {
                            throw NetworkError.invalidData
                        }
                        return String(decoding: stringData, as: UTF8.self)
                    }
                }
                .mapError { error in
                    return error as? NetworkError ?? .unknownError(error)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error as? NetworkError ?? .unknownError(error))
                .eraseToAnyPublisher()
        }
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
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        guard let decodedData = dataResponse.value else {
                            throw NetworkError.decodingFailed(data)
                        }
                        return decodedData
                    default:
                        throw NetworkError.unknownError(dataResponse.error ?? NSError())
                    }
                }
                .mapError { error in
                    return error as? NetworkError ?? .unknownError(error)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error as? NetworkError ?? .unknownError(error))
                .eraseToAnyPublisher()
        }
    }
    
    private func makeRequest(_ endPoint: EndPoint) throws -> DataRequest {
        if let imageData = endPoint.multipartFormImage {
            guard let bodyParameters = endPoint.bodyParameters,
                  let jsonData = try? JSONSerialization.data(withJSONObject: bodyParameters)
            else {
                throw NetworkError.imageUploadFailed
            }
            
            return AFSession.session.upload(
                multipartFormData: { multipartFormData in
                    // object
                    multipartFormData.append(
                        jsonData,
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
}
