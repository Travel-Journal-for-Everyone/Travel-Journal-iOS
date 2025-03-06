//
//  Bundle+Key.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/24/25.
//

import Foundation

extension Bundle {
    var kakaoNativeAppKey: String {
        guard let result = infoDictionary?["KAKAO_NATIVE_APPKEY"] as? String else {
            fatalError("KAKAO_NATIVE_APPKEY not found in Info.plist")
        }
        
        return result
    }
    
    var serverHostURL: String {
        guard let result = infoDictionary?["SERVER_HOST_URL"] as? String else {
            fatalError("SERVER_HOST_URL not found in Info.plist")
        }
        
        return result
    }
}
