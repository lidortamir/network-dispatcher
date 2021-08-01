//
//  Constants.swift
//  NetworkDispatcherDemo
//
//  Created by lidor tamir on 01/08/2021.
//

import Foundation

let DEFAULT_MAX_TASKS = 5

let REQUEST_TIME_OUT : TimeInterval = 10

typealias NetworkCompletionBlock = (Any?,HTTPResponse) -> Void

typealias OperationID = (Int)

enum State: String {
    case ready = "Ready"
    case executing = "Executing"
    case finished = "Finished"
    var keyPath: String { return "is" + self.rawValue }
}

enum RequestMethod : String {
    case post = "POST"
    case get = "GET"
}

enum TaskStatus {
    case perform
    case wait
    case done
    case cancelled
    case unknown
}

enum ErrorCode : Int {
    case unknownError = -1
    case cancelled = -999
    case badURL = -1000
    case timedOut = -1001
    case unsupportedURL = -1002
    case cannotFindHost = -1003
    case networkConnectionLost = -1005
    case notConnectedToInternet = -1009
    case badServerResponse = -1011
    case zeroByteResource = -1014
    case callIsActive = -1019
    case dataNotAllowed = -1020
    case secureConnectionFailed = -1200
    
    init(fromRawValue: Int){
        self = ErrorCode(rawValue: fromRawValue) ?? .unknownError
    }
}

enum NetworkError : Error {
    
    public enum InvalidRequest {
        case invalidURL(String)
        case invalidActionMethod(String)
    }
    
    enum ConnectionFailure {
        case badRequest(String)
        case requestTimeOut
        case serviceUNAvailable(String)
        case netowrkConnectionFailed
        case dataCellularNotAllow
    }
    
    public enum ResponseFailure {
        case cancelled
        case dataIsNil
        case internalServerError
        case dataParsingFailed(String)
        case responseValidationFailed(String)
    }
    
    case invalidRequest(reason : InvalidRequest)
    case connectionFailure(reason : ConnectionFailure)
    case responseFailure(reason : ResponseFailure)
    case unknownError
    case none 
    
}

protocol Network {
    
    func decodableResponse<T : Decodable>(_ request : Request , responseDecodable: T.Type , completionBlock : @escaping NetworkCompletionBlock) throws -> OperationID
  
    func decodableArrayResponse<T : Decodable>(_ request : Request , responseDecodable: T.Type , completionBlock : @escaping NetworkCompletionBlock) throws -> OperationID
    
    func response(_ request : Request , completionBlock : @escaping NetworkCompletionBlock) throws -> OperationID

    func cancelTask(_ identifier : OperationID) -> Void
  
    func taskStatus(_ identifier : OperationID) -> TaskStatus
}


protocol Request {
    var url : String {get set}
    var headers : [String : String]? {get set}
    var body : Data? {get set}
    var method : RequestMethod {get set}
    init(path : String , headers : [String : String]? , body : Data? , method : RequestMethod)
}

protocol NetworkOperation : Operation {
    func operationIdentifier() -> OperationID
    var state: State {get set}
}

struct NONE: Decodable {} 
