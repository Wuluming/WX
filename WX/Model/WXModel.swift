//
//  WXModel.swift
//  WX
//
//  Created by PoetCoder on 2017/9/7.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit

class Article: NSObject {
    var content: String = ""
    var titlte: String = ""
    var author: String = ""
    var digest: String = ""
    var curr: String = ""
    var prev: String = ""
    var next: String = ""
    
    init(content:String, title: String, author:String, digest: String, curr: String, prev: String, next: String) {
        
        self.content = content
        self.titlte = title
        self.author = author
        self.digest = digest
        self.curr = curr
        self.prev = prev
        self.next = next
    }
}
