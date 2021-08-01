//
//  HTTPRequest.swift
//  NetworkDispatcherDemo
//
//  Created by lidor tamir on 01/08/2021.
//

import Foundation


struct HTTPRequest : Request {
    var url : String = ""
    var headers : [String : String]? = nil
    var body : Data? = nil
    var method : RequestMethod = .post
    
    init(path : String , headers : [String : String]? , body : Data? , method : RequestMethod){
       self.url = path
       self.headers = headers
       self.body = body
       self.method = method
   }
}
