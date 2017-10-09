//
//  HomeViewController.swift
//  WX
//
//  Created by PoetCoder on 2017/9/6.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HomeViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate {

    var scrollView = UIScrollView()
    var lastPosition:CGFloat = 0.0
    var toolBar = WXToolBar()
    var curr: String = ""
    var nextCurr: String = ""
    var itemLike = UIBarButtonItem()
    var likeArr = NSMutableArray()
    let def = UserDefaults.standard
    var readView = WXReadView()
    var config = WXReadConfig.readInstance
    var parse = WXReadParse()
    var isShow: Bool = true
    
    var article = Article(content: "", title: "", author: "", digest: "", curr: "", prev: "", next: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets  = false
        //隐藏nav_bar
//        self.navigationController?.setNavigationBarHidden(true , animated: false)
//        if (def.object(forKey: "like") != nil) {
//            self.likeArr = def.object(forKey: "like") as! NSMutableArray
//        }else {
//            def.set(likeArr, forKey: "like")
//        }
//
        
        self.setView()
        self.loadData()
    }
    
    fileprivate func setView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: SCREEN_W, height: SCREEN_H))
        scrollView.bounces = false
//        scrollView.delegate = self
        self.view.addSubview(scrollView)

        if (UserDefaults.standard.object(forKey: "theme") as? Int) != nil {
            let tag =  UserDefaults.standard.object(forKey: "theme") as? Int
            if tag == 2 {
                self.config.theme = UIColor(red: 0/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
                self.config.fontColor = UIColor.white
            }
            if tag == 1 {
                self.config.theme = UIColor(red: 255/255.0, green: 235/255.0, blue: 205/255.0, alpha: 1.0)
                self.config.fontColor = UIColor.black
            }
            if tag == 0{
                self.config.theme = UIColor.white
                self.config.fontColor = UIColor.black
            }
        }
        
        readView = WXReadView(frame: CGRect(x: 0, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height))
        scrollView.addSubview(readView)
        
        toolBar = WXToolBar(frame: CGRect(x: 0, y: (SCREEN_H - TOOL_BAR_HEIGHT), width: SCREEN_W, height: TOOL_BAR_HEIGHT))
        toolBar.itemBlock = {
            (item: UIBarButtonItem) in
            switch item.tag {
            case 0:
                self.loadLike(item: item)
            case 1:
                self.loadPrev()
            case 2:
                self.loadRand()
            case 3:
                self.loadNext()
            case 4:
                self.loadData()
            default:
                break
            }
        }
        
        self.view.addSubview(toolBar)
        
        let image = UIImage(named: "detail.png")
        let rightImage = UIImage(named: "set.png")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(detail))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(set))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        self.readView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func tapDismiss() {
        if self.menuView.frame != CGRect.zero {
            self.menuView.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.frame = CGRect(x: 0, y: SCREEN_H, width: SCREEN_W, height: 100)
            }, completion: { (_) -> Void in
            })
        }
        
        if isShow == true {
            //隐藏
            UIView .animate(withDuration: 0.3, animations: {
                self.toolBar.frame = CGRect(x: 0, y: (SCREEN_H), width: SCREEN_W, height: TOOL_BAR_HEIGHT)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                UIApplication.shared.isStatusBarHidden = true
            })
            isShow = false
        }else {
            //显示
            UIView .animate(withDuration: 0.3, animations: {
                self.toolBar.frame = CGRect(x: 0, y: (SCREEN_H - TOOL_BAR_HEIGHT), width: SCREEN_W, height: TOOL_BAR_HEIGHT)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                UIApplication.shared.isStatusBarHidden = false
            })
            isShow = true
        }
    }
    
    @objc fileprivate func detail() {
        let detail = DetailViewController()
        let detailNav = UINavigationController.init(rootViewController: detail)
        detail.article = self.article
        self.present(detailNav, animated: true, completion: nil)
    }
    
    @objc fileprivate func set() {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.frame = CGRect(x: 0, y: SCREEN_H - 100, width: SCREEN_W, height: 100)
        }, completion: { (_) -> Void in
             UIApplication.shared.keyWindow?.addSubview(self.menuView)
        })
    }
    
    fileprivate func loadLike(item:UIBarButtonItem) {
        item.image = UIImage(named: "like_selected.png")?.withRenderingMode(.alwaysOriginal)
        self.itemLike = item
        
        let dic = NSMutableDictionary()
        dic.setObject(self.article.curr, forKey: "time" as NSCopying)
        self.likeArr.add(dic)
        
        def.set(self.likeArr, forKey: "like")
    }
    
    fileprivate func changeLike() {
//        for item in self.likeArr {
//            let dic = item as! NSDictionary
//            if  dic.object(forKey: "time") as! String == self.curr{
//                
//                self.itemLike.image = UIImage(named: "like_selected.png")?.withRenderingMode(.alwaysOriginal)
//                break
//            }
//            self.itemLike.image = UIImage(named: "like.png")?.withRenderingMode(.alwaysOriginal)
//        }
    }
//    //数据请求 今日
    fileprivate func loadData() {
        
        self.itemLike.image = UIImage(named: "like.png")?.withRenderingMode(.alwaysOriginal)
        Alamofire.request(Router.getToday().path).responseJSON {
            response in
            if response.result.isFailure {
                print("failure :\(String(describing: response.result.error))")
                let alert = UIAlertController(title: "网络异常", message: "请检查网络", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let json = response.result.value
            
            var result = JSON(json!)
            
            let content = result["data"]["content"].rawString()
            let title = result["data"]["title"].rawString()
            self.navigationItem.title = title
            
            self.readView.readData = self.parse.parseAttributed(content: content!, config: self.config)
            self.readView.setNeedsDisplay()
            
            
            self.article.content  = content!
            self.article.titlte = title!
            self.article.author = result["data"]["author"].rawString()!
            self.article.digest = result["data"]["digest"].rawString()!
            self.article.curr = result["data"]["date"]["curr"].rawString()!
            self.article.prev = result["data"]["date"]["prev"].rawString()!
            self.article.next = result["data"]["date"]["next"].rawString()!
            
            
            self.nextCurr = self.article.next
            self.reloadReadView(article: self.article,from: true)
        }
    }
    
    //    //数据请求 随机
    fileprivate func loadRand() {
        Alamofire.request(Router.getRand().path).responseJSON {
            response in
            if response.result.isFailure {
                print("failure :\(String(describing: response.result.error))")
                let alert = UIAlertController(title: "网络异常", message: "请检查网络", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let json = response.result.value
            
            var result = JSON(json!)
            
            let content = result["data"]["content"].rawString()
            let title = result["data"]["title"].rawString()
            self.navigationItem.title = title
            
            
            self.article.content  = content!
            self.article.titlte = title!
            self.article.author = result["data"]["author"].rawString()!
            self.article.digest = result["data"]["digest"].rawString()!
            self.article.curr = result["data"]["date"]["curr"].rawString()!
            self.article.prev = result["data"]["date"]["prev"].rawString()!
            self.article.next = result["data"]["date"]["next"].rawString()!
            
            self.reloadReadView(article: self.article,from: true)
        }
    }
    
    
    //    //数据请求 上一篇
    fileprivate func loadPrev() {
        print(self.article.prev)
        Alamofire.request(Router.getDate(date: self.article.prev).path).responseJSON {
            response in
            if response.result.isFailure {
                print("failure :\(String(describing: response.result.error))")
                let alert = UIAlertController(title: "网络异常", message: "请检查网络", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let json = response.result.value
            
            var result = JSON(json!)
            
            let content = result["data"]["content"].rawString()
            let title = result["data"]["title"].rawString()
            self.navigationItem.title = title
            
            self.article.content  = content!
            self.article.titlte = title!
            self.article.author = result["data"]["author"].rawString()!
            self.article.digest = result["data"]["digest"].rawString()!
            self.article.curr = result["data"]["date"]["curr"].rawString()!
            self.article.prev = result["data"]["date"]["prev"].rawString()!
            self.article.next = result["data"]["date"]["next"].rawString()!
            
            self.reloadReadView(article: self.article,from: true)
        }
    }
    
    //    //数据请求 下一篇
    fileprivate func loadNext() {
        
        
        if self.nextCurr == self.article.next {
            let alert = UIAlertController(title: "已是最新", message: "请随机浏览", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        Alamofire.request(Router.getDate(date: self.article.next).path).responseJSON {
            response in
            if response.result.isFailure {
                print("failure :\(String(describing: response.result.error))")
                let alert = UIAlertController(title: "网络异常", message: "请检查网络", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let json = response.result.value
            
            var result = JSON(json!)
            
            let content = result["data"]["content"].rawString()
            let title = result["data"]["title"].rawString()
            self.navigationItem.title = title
            
            
            
            self.article.content  = content!
            self.article.titlte = title!
            self.article.author = result["data"]["author"].rawString()!
            self.article.digest = result["data"]["digest"].rawString()!
            self.article.curr = result["data"]["date"]["curr"].rawString()!
            self.article.prev = result["data"]["date"]["prev"].rawString()!
            self.article.next = result["data"]["date"]["next"].rawString()!
            
            self.reloadReadView(article: self.article,from: true)
        }
    }

    fileprivate func reloadReadView(article:Article, from:Bool) {
        self.curr = self.article.curr
        self.readView.readData = self.parse.parseAttributed(content: self.contentChange(content: article.content), config: self.config)
        let rect = CGRect(x: self.readView.frame.origin.x, y: self.readView.frame.origin.y, width: self.readView.frame.size.width, height: (self.readView.readData?.height)!)
        self.readView.frame = rect;
        self.scrollView.contentSize = CGSize(width: self.readView.frame.size.width, height: (self.readView.readData?.height!)!)
        self.readView.backgroundColor = self.config.theme
        self.readView.setNeedsDisplay()
//        self.changeLike()
        if from == true {
         self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    fileprivate func contentChange(content:String) -> String {
        let str = "\n" + self.article.titlte + "\n" + content.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "\n") + "\n\n"
        return str
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition: CGFloat = scrollView.contentOffset.y
        
        if currentPosition - lastPosition >= 0 && currentPosition > 0{
            lastPosition = currentPosition
            UIView .animate(withDuration: 0.3, animations: { 
                self.toolBar.frame = CGRect(x: 0, y: (SCREEN_H), width: SCREEN_W, height: TOOL_BAR_HEIGHT)
            })
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentPosition: CGFloat = scrollView.contentOffset.y
        lastPosition = currentPosition
        if currentPosition - lastPosition <= 0 {
            UIView .animate(withDuration: 0.3, animations: {
                self.toolBar.frame = CGRect(x: 0, y: (SCREEN_H - TOOL_BAR_HEIGHT), width: SCREEN_W, height: TOOL_BAR_HEIGHT)
            })
        }
    }
    
    lazy var menuView : WXMenuView = {
        let temp = WXMenuView()
        temp.frame = CGRect(x: 0, y: SCREEN_H, width: SCREEN_W, height: 100)
        temp.backgroundColor = UIColor.white
        
        let colorArr:[UIColor] = [UIColor.white,UIColor(red: 255/255.0, green: 235/255.0, blue: 205/255.0, alpha: 1.0),UIColor(red: 0/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)]
        
        let w:CGFloat = (SCREEN_W - 20 * 4)/3
        let h:CGFloat = 30
        let y: CGFloat = (100 - h)/2
        for index in 0..<3 {
            let btn = UIButton(type: UIButtonType.custom)
            btn.frame = CGRect(x: 20 + (w + 20) * CGFloat(index), y: y, width: w, height: h)
            btn.layer.borderWidth = 0.5
            btn.layer.borderColor = UIColor.black.cgColor
            btn.backgroundColor = colorArr[index]
            btn.tag = index
            btn.addTarget(self, action: #selector(chageTheme(btn:)), for: UIControlEvents.touchUpInside)
            temp.addSubview(btn)
        }
        return temp
    }()
    
    @objc fileprivate func chageTheme(btn:UIButton) {
        self.config.theme = btn.backgroundColor
        self.readView.backgroundColor = self.config.theme
        self.menuView.backgroundColor = self.config.theme
        if btn.tag == 2  {
            self.config.fontColor = UIColor.white
            self.reloadReadView(article: self.article ,from: false)
        }else {
            self.config.fontColor = UIColor.black
            self.reloadReadView(article: self.article,from: false)
        }
        UserDefaults.standard.set(btn.tag, forKey: "theme")
    }
}
