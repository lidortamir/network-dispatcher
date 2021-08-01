//
//  HTTPResponse.swift
//  NetworkDispatcherDemo
//
//  Created by lidor tamir on 01/08/2021.
//

import Foundation

struct HTTPResponse {
    
    public var identifier : Int = 0
    
    public var request: URLRequest!
    
    /// The server's response to the URL request.
    public var response: HTTPURLResponse?
    
    /// The data returned by the server.
    public var data: Data?
    
    public var networkErrorType: NetworkError = .none
    
    init(request: URLRequest, httpResponse: HTTPURLResponse?,identifier : Int ,  data: Data?, error: Error?) {
        self.identifier = identifier
        self.request = request
        self.data = data
        self.response = httpResponse
        
        networkErrorType = .none 
        if let err = error  {
            let errorCode = ErrorCode(fromRawValue :  (err as NSError).code)
            
            switch errorCode {
                
            case .unknownError:
                networkErrorType = NetworkError.unknownError
                break
            case .cancelled:
                networkErrorType = NetworkError.responseFailure(reason: .cancelled)
                break
            case .badURL:
                let url = request.url?.absoluteString ?? ""
                networkErrorType = NetworkError.invalidRequest(reason: .invalidURL(url))
                break
            case .unsupportedURL:
                let url = request.url?.absoluteString ?? ""
                networkErrorType = NetworkError.invalidRequest(reason: .invalidURL(url))
                break
            case .timedOut:
                networkErrorType = NetworkError.connectionFailure(reason: .requestTimeOut)
                break
            case .cannotFindHost:
                let url = request.url?.absoluteString ?? ""
                networkErrorType = NetworkError.connectionFailure(reason: .serviceUNAvailable(url))
                break
            case .networkConnectionLost:
                networkErrorType = NetworkError.unknownError
                break
            case .notConnectedToInternet:
                networkErrorType = NetworkError.connectionFailure(reason: .netowrkConnectionFailed)
                break
            case .badServerResponse:
                networkErrorType = NetworkError.responseFailure(reason: .internalServerError)
                break
            case .zeroByteResource:
                networkErrorType = NetworkError.unknownError
                break
            case .callIsActive:
                networkErrorType = NetworkError.unknownError
                break
            case .dataNotAllowed:
                networkErrorType = NetworkError.connectionFailure(reason: .dataCellularNotAllow)
                break
            case .secureConnectionFailed:
                networkErrorType = NetworkError.unknownError
                break
            }
        }else{
            if data == nil {
                networkErrorType = NetworkError.responseFailure(reason: .dataIsNil)
            }
        }
    }
}
