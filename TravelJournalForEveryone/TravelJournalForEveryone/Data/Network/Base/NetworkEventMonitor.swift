//
//  NetworkEventMonitor.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/13/25.
//

import Foundation
import Alamofire

final class NetworkEventMonitor: EventMonitor {
    let queue = DispatchQueue(label: "NetworkLogger")
    
    // 네트워크 요청 직후
    func requestDidFinish(_ request: Request) {
        print("\n\n🐿️ NETWORK Reqeust LOG")
        
        print(
            "🐿️ URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "🐿️ Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "🐿️ Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])"
        )
        if let bodyData = request.request?.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            print("🐿️ Body: " + bodyString)
        } else {
            print("🐿️ Body Empty")
        }
    }
    
    // 네트워크 응답 이후
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) where Value : Sendable {
        print("\n\n🚗 NETWORK Response LOG")
        print(
            "🚗 URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "🚗 Result: " + "\(response.result)" + "\n"
            + "🚗 StatusCode: " + "\(response.response?.statusCode ?? 0)"
        )
        if let bodyData = response.data,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            print("🚗 Body: " + bodyString + "\n\n")
        } else {
            print("🚗 Body Empty\n\n")
        }
    }
    
    // 네트워크 오류 발생
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        print("❌ NETWORK ERROR : \(error)")
    }

}
