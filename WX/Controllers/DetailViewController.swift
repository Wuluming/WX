//
//  DetailViewController.swift
//  WX
//
//  Created by PoetCoder on 2017/9/7.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var article = Article(content: "", title: "", author: "", digest: "", curr: "", prev: "", next: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详细信息"
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(DetailViewController.cancel))
        
        
        let author = UILabel(frame: CGRect(x: 0, y: 84, width: SCREEN_W, height: 30))
        author.text = "作者：".appending(self.article.author)
        author.textAlignment = NSTextAlignment.center
        self.view.addSubview(author)
        
        let time = UILabel(frame: CGRect(x: 0, y: 120, width: SCREEN_W, height: 30))
        time.text = "时间：".appending(self.article.curr)
        time.textAlignment = NSTextAlignment.center
        self.view.addSubview(time)
        
        let dig: NSString = "摘要：".appending(self.article.digest) as NSString
        let font = UIFont.systemFont(ofSize: 15.0)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let size = dig.boundingRect(with: CGSize(width: SCREEN_W - 20, height: SCREEN_H - 140), options: .usesLineFragmentOrigin, attributes: dic as? [String : Any], context: nil).size
//        .appending("摘要：")
        
        let digest = UILabel(frame: CGRect(x: 10, y: 160, width: SCREEN_W-20, height: size.height))
        digest.text = dig as String
        digest.numberOfLines = 0
        digest.font = UIFont.systemFont(ofSize: 15.0)
        digest.textAlignment = NSTextAlignment.left
        self.view.addSubview(digest)
        
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
