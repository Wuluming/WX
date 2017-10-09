

//
//  WXReadConfig.swift
//  WX
//
//  Created by PoetCoder on 2017/9/6.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit


class WXReadConfig: NSObject,NSCoding {
    
    static let readInstance = WXReadConfig()
    
    var width:CGFloat?
    var fontSize: CGFloat?
    var lineSpace: CGFloat?
    var fontColor: UIColor?
    var theme: UIColor?
    
    override private init() {
        super.init()
//        let data = UserDefaults.standard.object(forKey: "config") as! NSData
//        if data.length > 0 {
//            let unarchive = NSKeyedUnarchiver(forReadingWith: data as Data)
//            WXReadConfig.readInstance = unarchive.decodeObject(forKey: "config") as! WXReadConfig
//        }
//
        
//        if (UserDefaults.standard.object(forKey: "config") as? NSData) != nil {
//            let data = UserDefaults.standard.object(forKey: "config") as! NSData
//            if data.length > 0 {
//                let unarchive = NSKeyedUnarchiver(forReadingWith: data as Data)
//                WXReadConfig.readInstance = unarchive.decodeObject(forKey: "config") as! WXReadConfig
//            }
//        }
        
//        if (UserDefaults.standard.object(forKey: "config") as? NSData) == nil {
            width = SCREEN_W
            lineSpace = 8
            fontSize = 16
            fontColor = UIColor.black
            theme = UIColor.white
            
//            self.addObserver(self, forKeyPath: "width", options: NSKeyValueObservingOptions.new, context: nil)
//            self.addObserver(self, forKeyPath: "fontSize", options: NSKeyValueObservingOptions.new, context: nil)
//            self.addObserver(self, forKeyPath: "lineSpace", options: NSKeyValueObservingOptions.new, context: nil)
//            self.addObserver(self, forKeyPath: "fontColor", options: NSKeyValueObservingOptions.new, context: nil)
//            self.addObserver(self, forKeyPath: "theme", options: NSKeyValueObservingOptions.new, context: nil)
//            WXReadConfig.updateConfig(config: self)
//        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        WXReadConfig.updateConfig(config: self)
    }
    
    fileprivate class func updateConfig(config:WXReadConfig) {
        let data = NSMutableData()
        let archive = NSKeyedArchiver(forWritingWith: data)
        archive.encode(config, forKey: "config")
        archive.finishEncoding()
        UserDefaults.standard.set(data, forKey: "config")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.width = aDecoder.decodeObject(forKey: "width") as? CGFloat
        self.fontSize = aDecoder.decodeObject(forKey: "fontSize") as? CGFloat
        self.lineSpace = (aDecoder.decodeObject(forKey: "lineSpace") as? CGFloat)
        self.fontColor = aDecoder.decodeObject(forKey: "fontColor") as? UIColor
        self.theme = aDecoder.decodeObject(forKey: "theme") as? UIColor
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encodeConditionalObject(width, forKey: "width")
        aCoder.encodeConditionalObject(fontSize, forKey: "fontSize")
        aCoder.encodeConditionalObject(lineSpace, forKey: "lineSpace")
        aCoder.encodeConditionalObject(fontColor, forKey: "fontColor")
        aCoder.encodeConditionalObject(theme, forKey: "theme")
    }
}
