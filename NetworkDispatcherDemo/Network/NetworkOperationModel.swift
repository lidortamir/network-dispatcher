//
//  NetworkOperation.swift
//  NetworkDispatcherDemo
//
//  Created by lidor tamir on 01/08/2021.
//

import Foundation

class NetworkOperationModel<T : Decodable>: Operation , NetworkOperation  {
    
    enum JSONType {
        case object , array, none
    }
    private var operationId : OperationID = -1
    
    private var task : URLSessionTask?
    
    private var urlRequest : URLRequest?
    
    private var block : NetworkCompletionBlock
    
    private var request : Request!
    
    private var type = JSONType.object
    
    init(request : Request , type : JSONType, completionBlock : @escaping
         
         NetworkCompletionBlock) {
        
        self.type = type
        
        self.request = request
        
        self.block = completionBlock
        
        self.state = .ready
        
        super.init()
        if let url = try? request.url.asUrl() {
            urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: REQUEST_TIME_OUT)
            urlRequest?.httpMethod = request.method.rawValue
            urlRequest?.httpBody = request.body
            
            if let headers = request.headers {
                for (key , value) in headers {
                    urlRequest?.addValue(value, forHTTPHeaderField: key)
                }
            }
        }
        
        if let urlRequest = urlRequest  {
            task = URLSession.shared.dataTask(with: urlRequest) {
                [weak self] (data, response, error) in
                
                let identifier = self?.operationId ?? 0
                if let req = self?.urlRequest  {
                    
                    let http_response = HTTPResponse(request: req, httpResponse: response as? HTTPURLResponse, identifier : identifier ,data: data, error: error)
                    
                    switch http_response.networkErrorType  {
                    case .none :
                        switch self?.type ?? .none {
                        case .object:
                            self?.handle(http_response, type: .object)
                            break
                        case .array:
                            self?.handle(http_response, type: .array)
                            break
                        case .none:
                            self?.result(nil, response: http_response)
                            break
                        }
                        break
                    default:
                        self?.result(nil, response: http_response)
                        break
                    }
                }
            }
        }
        operationId = task?.taskIdentifier ?? -1
    }
    
    
    private func handle(_ response : HTTPResponse, type: JSONType) {
        guard let json = response.data?.decodeToJson() else {
            result(nil, response: response)
            return
        }
        
        if type == .object {
            let object = JSONDecoder().decode(json, to: T.self)
            result(object, response: response)
        }else if type == .array {
            var items : [T] = []
            for item in json as? [[String :Any]] ?? [] {
                if let object = JSONDecoder().decode(item, to: T.self) {
                    items.append(object)
                }
            }
            result(items, response: response)
        }
        
    }
    
    private func result(_ result : Any?, response : HTTPResponse) {
        OperationQueue.main.addOperation {
            self.block(result,response)
            self.state = .finished
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    var state: State {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
            task?.resume()
        }
    }
    
    func operationIdentifier() -> OperationID {
        return operationId
    }
    
}
