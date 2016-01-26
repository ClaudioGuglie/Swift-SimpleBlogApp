//
//  AppItem.swift
//  ZEF
//
//  Created by Claudio on 11/14/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit

class AppItem: NSObject {
    var mId : String
    var mName : String
    var mType : String
    var mCreated : String
    var mModified : String
    var mShareImageUrl : String
    var mUsersCount : Int
    var mLastHours : Int
    var mReportGroups : NSMutableArray = NSMutableArray();
    
    override init() {
        mId = ""
        mName = ""
        mType = ""
        mCreated = ""
        mModified = ""
        mShareImageUrl = ""
        mUsersCount = 0
        mLastHours = 0
    }
}
