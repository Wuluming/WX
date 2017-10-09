//
//  Router.swift
//  WX
//
//  Created by PoetCoder on 2017/9/6.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit
import Alamofire


enum Router: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        return self.urlRequest
    }
    
    case getToday()
    case getDate(date: String)
    case getRand()
    
    var path: String {
        switch self {
        case .getToday:
            return ServiceAPI.getToday()
        case .getDate(let date):
            return ServiceAPI.getSpecialDay(date)
        case .getRand:
            return ServiceAPI.getRand()
        }
    }
    
    var method : Alamofire.HTTPMethod {
        return .post
    }
    
    
    var urlRequest: URLRequest {
        let url = URL(string: path)!
        var mulURLRequest = URLRequest(url: url)
        mulURLRequest.httpMethod = method.rawValue
        return mulURLRequest
        
    }
    
    
    
}
