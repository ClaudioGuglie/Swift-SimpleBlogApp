//
//  ApiRequest.swift
//  ZEF
//
//  Created by Claudio on 11/21/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit
import Alamofire

class ApiRequest: NSObject {

    func getInfoRequest(token:String, callback : ((isSuccess : Bool, jsonDic : NSMutableDictionary)->Void)?)
    {
        let param = ["command": "my_info"]
        Alamofire.request(.POST, kGetUserInfoUrl, parameters: param, encoding: .JSON, headers: nil)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    let jsonDic = response.result.value as! NSMutableDictionary
                    
                    callback?(isSuccess: true, jsonDic: jsonDic)
                }
                else
                {
                    NSLog("Fail to get info")
                    let newDic: NSMutableDictionary = NSMutableDictionary()
                    callback?(isSuccess: false, jsonDic: newDic)
                }
        }

    }
    
    func getAppsRequest(callback : ((isSuccess : Bool, jsonDic : NSMutableDictionary)->Void)?)
    {
        let param = ["command": "get_user_apps"]
        Alamofire.request(.POST, kGetUserInfoUrl, parameters: param, encoding: .JSON, headers: nil)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    
                    let cookies:[NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! as [NSHTTPCookie]
                    for cookie:NSHTTPCookie in cookies as [NSHTTPCookie] {
                        if cookie.name as String == kZefToke {
                            let cookieValue : String = cookie.value as String
                            
                            SharedValue.sharedInstance.gZefToken = cookieValue
                        }
                    }
                    
                    let jsonDic = response.result.value as! NSMutableDictionary
                    callback?(isSuccess: true, jsonDic: jsonDic)
                }
                else
                {
                    NSLog("Fail to get apps")
                    let newDic: NSMutableDictionary = NSMutableDictionary()
                    callback?(isSuccess: false, jsonDic: newDic)

                }
        }
    }
    
    func getReportRequest(appId:String, callback : ((isSuccess : Bool, jsonDic : NSMutableDictionary)->Void)?)
    {
        let header = ["Cookie": "gToken=" + UserPreferences.sharedInstance.gToken + ";s~zefglobal_zg_sid=" + SharedValue.sharedInstance.gZefToken]
        Alamofire.request(.GET, kGetReport + appId, parameters: nil, encoding: .JSON, headers: header)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    let jsonDic = response.result.value as! NSMutableDictionary
                    
                    callback?(isSuccess: true, jsonDic: jsonDic)
                }
                else
                {
                    NSLog("Fail to get report")
                    let newDic: NSMutableDictionary = NSMutableDictionary()
                    callback?(isSuccess: false, jsonDic: newDic)
                }
        }
    }
    
    func getReportGroupRequest(appId:String, callback : ((isSuccess : Bool, jsonDic : NSMutableDictionary)->Void)?)
    {
        let header = ["Cookie": "gToken=" + UserPreferences.sharedInstance.gToken + ";s~zefglobal_zg_sid=" + SharedValue.sharedInstance.gZefToken]
        
        Alamofire.request(.GET, kGetReportGroup + appId, parameters: nil, encoding: .JSON, headers: header)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    let jsonDic = response.result.value as! NSMutableDictionary
                    
                    callback?(isSuccess: true, jsonDic: jsonDic)
                }
                else
                {
                    NSLog("Fail to get report")
                    let newDic: NSMutableDictionary = NSMutableDictionary()
                    callback?(isSuccess: false, jsonDic: newDic)
                }
        }

    }
}
