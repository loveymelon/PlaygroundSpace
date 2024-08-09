//
//  UserDefaultManager.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 7/29/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    let ud = UserDefaults.standard
    
    enum UDKey: String {
        case userNickname
        case accessToken
        case refreshToken
        case workSpaceId
        case userId
    }

    var userNickname: String {
        get {
            ud.string(forKey: UDKey.userNickname.rawValue) ?? "없음"
        }
        set {
            ud.set(newValue, forKey: UDKey.userNickname.rawValue)
        }
    }
    
    var accessToken: String {
        get {
            ud.string(forKey: UDKey.accessToken.rawValue) ?? ""
        }
        set {
            ud.set(newValue, forKey: UDKey.accessToken.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            ud.string(forKey: UDKey.refreshToken.rawValue) ?? "없음"
        }
        set {
            ud.set(newValue, forKey: UDKey.refreshToken.rawValue)
        }
    }
    
    var currentWorkSpaceId: String {
        get {
            ud.string(forKey: UDKey.workSpaceId.rawValue) ?? "없음"
        }
        set {
            ud.set(newValue, forKey: UDKey.workSpaceId.rawValue)
        }
    }
    
    var userId: String {
        get {
            ud.string(forKey: UDKey.userId.rawValue) ?? "없음"
        }
        set {
            ud.set(newValue, forKey: UDKey.userId.rawValue)
        }
    }
    
    func deleteObject() {
        ud.removeObject(forKey: UDKey.userNickname.rawValue)
        ud.removeObject(forKey: UDKey.accessToken.rawValue)
        ud.removeObject(forKey: UDKey.refreshToken.rawValue)
    }
}
