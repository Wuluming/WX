//
//  ServiceAPI.swift
//  WX
//
//  Created by PoetCoder on 2017/9/6.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit

class ServiceAPI: NSObject {
    static var host:String = "https://interface.meiriyiwen.com/article"
    
    internal class func getToday() -> String {
        return "\(host)/today?dev=1"
    }
    
    internal class func getSpecialDay(_ date:String) -> String {
        return "\(host)/day?dev=1&date=\(date)"
    }
    
    internal class func getRand() -> String{
        return "\(host)/random?dev=1"
    }
}
