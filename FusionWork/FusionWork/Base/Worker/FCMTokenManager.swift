//
//  FCMTokenManager.swift
//  FusionWork
//
//  Created by HartzedStory on 5/23/25.
//

import Foundation

final class FCMTokenManager {
    private static let tokenKey = "fcm_token"
    
    static var savedToken: String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }
    
    static func save(token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    static func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
