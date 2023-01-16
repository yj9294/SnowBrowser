//
//  FirebaseHelper.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/10.
//

import Foundation
import Firebase

class FirebaseHelper: NSObject {
    static func log(event: Event, params: [String: Any]? = nil) {
        
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        if event == .homeShow, BrowserHelper.shared.webItem.isNavigation {
            log(event: .navigaShow)
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        NSLog("[Event] \(event.rawValue) \(params ?? [:])")
    }
    
    static func log(property: Property, value: String? = nil) {
        
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        NSLog("[Property] \(property.rawValue) \(value ?? "")")
    }
}

enum Property: String {
    /// 設備
    case local = "w"
    
    var first: Bool {
        switch self {
        case .local:
            return true
        }
    }
}

enum Event: String {
    
    var first: Bool {
        switch self {
        case .open:
            return true
        default:
            return false
        }
    }
    
    case open = "e_100"
    case openCold = "r_100"
    case openHot = "h_100"
    case homeShow = "u_100"
    case navigaShow = "i_100"
    case navigaClick = "o_100"
    case navigaSearch = "p_100"
    case cleanClick = "z_100"
    case cleanSuccess = "x_100"
    case cleanAlert = "c_100"
    case tabShow = "b_100"
    case tabNew = "v_100"
    case shareClick = "n_100"
    case copyClick = "m_100"
    case webStart = "k_100"
    case webSuccess = "ll_100"
}
