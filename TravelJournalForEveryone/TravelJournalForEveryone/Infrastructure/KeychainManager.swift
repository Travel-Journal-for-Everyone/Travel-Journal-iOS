//
//  KeychainManager.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 3/9/25.
//

import Foundation
import Security

struct KeychainManager {
    static private let service = "TJFE"
    
    private init() { }
    
    @discardableResult
    static func save(forAccount: AccountType, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            #if DEBUG
            print("⛔️ Keychain-Saving Error(\(forAccount)): Failed to convert string to data.")
            #endif
            return false
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
            return false
        }
        #if DEBUG
        print("✅ Keychain-Saving Success(\(forAccount))")
        #endif
        return true
    }
    
    @discardableResult
    static func load(forAccount: AccountType) -> String? {
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
                return value
            } else {
                #if DEBUG
                print("⛔️ Keychain-Loading Error(\(forAccount)): Invalid data.")
                #endif
                return nil
            }
        } else if status == errSecItemNotFound {
            #if DEBUG
            print("⛔️ Keychain-Loading Error(\(forAccount)): Data was not found.")
            #endif
            return nil
        } else {
            #if DEBUG
            print("⛔️ Keychain-Loading Error(\(forAccount)): Failed to load data.")
            #endif
            return nil
        }
    }
    
    @discardableResult
    static func delete(forAccount: AccountType) -> Bool {
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
            return false
        }
        
        guard status == errSecSuccess else {
            #if DEBUG
            print("⛔️ Keychain-Delete Error(\(forAccount)): Failed to delete data.")
            #endif
            return false
        }
        #if DEBUG
        print("✅ Keychain-Delete Success(\(forAccount))")
        #endif
        return true
    }
}

extension KeychainManager {
    enum AccountType: String {
        case accessToken
        case refreshToken
    }
}
