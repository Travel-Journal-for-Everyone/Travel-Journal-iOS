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
            print("⛔️ Keychain-Saving Error: Failed to convert string to data.")
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
            print("⛔️ Keychain-Saving Error: Failed to save data.")
            return false
        }
        
        print("✅ Keychain-Saving Success")
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
                print("✅ Keychain-Loading Success")
                return value
            } else {
                print("⛔️ Keychain-Loading Error: Invalid data.")
                return nil
            }
        } else if status == errSecItemNotFound {
            print("⛔️ Keychain-Loading Error: Data was not found.")
            return nil
        } else {
            print("⛔️ Keychain-Loading Error: Failed to load data.")
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
            print("⛔️ Keychain-Delete Error: Data was not found.")
            return false
        }
        
        guard status == errSecSuccess else {
            print("⛔️ Keychain-Delete Error: Failed to delete data.")
            return false
        }
        
        print("✅ Keychain-Delete Success")
        return true
    }
}

extension KeychainManager {
    enum AccountType: String {
        case accessToken
        case refreshToken
    }
}
