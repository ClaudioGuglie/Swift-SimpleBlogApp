//
//  UserPreferences.swift
//  ZEF
//
//  Created by Claudio on 11/20/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit

class UserPreferences {
    enum Key: String {
        case TOKEN_EXPIRE_AT
        case GTOKEN
        case USERNAME
        case EMAIL
        case PIC_URL
    }

    class var sharedInstance : UserPreferences {
        struct Singleton {
            static let instance = UserPreferences()
        }
        
        return Singleton.instance
    }

    var gToken: String! {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Key.GTOKEN.rawValue)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Key.GTOKEN.rawValue)
        }
    }

    var gTokenExpireAt: NSNumber {
        get {
            if (NSUserDefaults.standardUserDefaults().objectForKey(Key.TOKEN_EXPIRE_AT.rawValue) == nil)
            {
                return 0
            }
            return NSUserDefaults.standardUserDefaults().objectForKey(Key.TOKEN_EXPIRE_AT.rawValue) as! NSNumber
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Key.TOKEN_EXPIRE_AT.rawValue)
        }
    }
    
    var username: String! {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Key.USERNAME.rawValue)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Key.USERNAME.rawValue)
        }
    }
    
    var email: String! {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Key.EMAIL.rawValue)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Key.EMAIL.rawValue)
        }
    }

    var picUrl: String! {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(Key.PIC_URL.rawValue)
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: Key.PIC_URL.rawValue)
        }
    }

    func clear()
    {        
        UserPreferences.sharedInstance.gToken = ""
        UserPreferences.sharedInstance.gTokenExpireAt = NSNumber()
        UserPreferences.sharedInstance.username = ""
        UserPreferences.sharedInstance.email = ""
        UserPreferences.sharedInstance.picUrl = ""
    }
}

