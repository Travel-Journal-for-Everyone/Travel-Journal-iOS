//
//  KeychainManager.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/9/25.
//

import Foundation
import Security

enum KeychainError: Error {
    case invalidItem(KeychainAccountType)
    case itemNotFound(KeychainAccountType)
    
    case failedToSave(KeychainAccountType)
    case failedToLoad(KeychainAccountType)
    case failedToDelete(KeychainAccountType)
    case failedToConvert(KeychainAccountType)
}

enum KeychainAccountType: String {
    case accessToken
    case refreshToken
}

struct KeychainManager {
    static private let service = "TJFE"
    
    private init() { }
    
    @discardableResult
    static func save(
        forAccount: KeychainAccountType,
        value: String
    ) -> Result<Bool, KeychainError> {
        guard let data = value.data(using: .utf8) else {
            #if DEBUG
            print("⛔️ Keychain-Saving Error(\(forAccount)): Failed to convert string to data.")
            #endif
            return .failure(.failedToConvert(forAccount))
        }
        
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: forAccount.rawValue,
            kSecValueData: data
        ] as [String: Any]
        
        SecItemDelete(keychainQuery as CFDictionary)
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            #if DEBUG
            print("⛔️ Keychain-Saving Error(\(forAccount)): Failed to save data.")
            #endif
            return .failure(.failedToSave(forAccount))
        }
        #if DEBUG
        print("✅ Keychain-Saving Success(\(forAccount))")
        #endif
        return .success(true)
    }
    
    static func load(forAccount: KeychainAccountType) -> Result<String, KeychainError> {
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: forAccount.rawValue,
            kSecReturnData: kCFBooleanTrue!
        ] as [String: Any]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)
        
        if status == errSecSuccess {
            if let data = result as? Data,
               let value = String(data: data, encoding: .utf8) {
                #if DEBUG
                print("✅ Keychain-Loading Success(\(forAccount))")
                #endif
                return .success(value)
            } else {
                #if DEBUG
                print("⛔️ Keychain-Loading Error(\(forAccount)): Invalid data.")
                #endif
                return .failure(.invalidItem(forAccount))
            }
        } else if status == errSecItemNotFound {
            #if DEBUG
            print("⛔️ Keychain-Loading Error(\(forAccount)): Data was not found.")
            #endif
            return .failure(.itemNotFound(forAccount))
        } else {
            #if DEBUG
            print("⛔️ Keychain-Loading Error(\(forAccount)): Failed to load data.")
            #endif
            return .failure(.failedToLoad(forAccount))
        }
    }
    
    @discardableResult
    static func delete(forAccount: KeychainAccountType) -> Result<Bool, KeychainError> {
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: forAccount.rawValue
        ] as [String: Any]
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        guard status != errSecItemNotFound else {
            #if DEBUG
            print("⛔️ Keychain-Delete Error(\(forAccount)): Data was not found.")
            #endif
            return .failure(.itemNotFound(forAccount))
        }
        
        guard status == errSecSuccess else {
            #if DEBUG
            print("⛔️ Keychain-Delete Error(\(forAccount)): Failed to delete data.")
            #endif
            return .failure(.failedToDelete(forAccount))
        }
        #if DEBUG
        print("✅ Keychain-Delete Success(\(forAccount))")
        #endif
        return .success(true)
    }
}
