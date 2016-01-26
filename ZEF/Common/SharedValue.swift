//
//  SharedValue.swift
//  RankUpApp
//
//  Created by Claudio on 4/18/15.
//  Copyright (c) 2015 Claudio. All rights reserved.
//

import UIKit

class SharedValue {
    var gZefToken : String = ""
    
    var gAppsArray : NSMutableArray = NSMutableArray();
    
    class var sharedInstance : SharedValue {
        struct Singleton {
            static let instance = SharedValue()
        }
        
        return Singleton.instance
    }
    
}
