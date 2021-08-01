//
//  NetworkDispatcher.swift
//  NetworkDispatcherDemo
//
//  Created by lidor tamir on 01/08/2021.
//

import Foundation

class NetworkDispatcher : Network {
    
    private var tasksQueue : OperationQueue = OperationQueue()
    
    public static let share : Network = NetworkDispatcher(maximumTasks: DEFAULT_MAX_TASKS)
    
    init(maximumTasks : Int) {
        tasksQueue.maxConcurrentOperationCount = maximumTasks
    }
    
    func decodableResponse<T>(_ request: Request, responseDecodable: T.Type, completionBlock: @escaping NetworkCompletionBlock) throws -> OperationID where T : Decodable {
      
        let operation  = NetworkOperationModel<T>(request: request, type: .object,
                                                   completionBlock: completionBlock)
        tasksQueue.addOperation(operation)

        return operation.operationIdentifier()
    }
    
    func decodableArrayResponse<T>(_ request: Request, responseDecodable: T.Type, completionBlock: @escaping NetworkCompletionBlock) throws -> OperationID where T : Decodable {
        let operation  = NetworkOperationModel<T>(request: request, type: .array,completionBlock: completionBlock)
        
        tasksQueue.addOperation(operation)

        return operation.operationIdentifier()
    }
    
    func response(_ request : Request , completionBlock : @escaping NetworkCompletionBlock) throws -> OperationID {
        let operation  = NetworkOperationModel<NONE>(request: request, type: .none ,completionBlock: completionBlock)
        
        tasksQueue.addOperation(operation)

        return operation.operationIdentifier()
    }
    
    func cancelTask(_ operationId : OperationID) -> Void {
        task(operationId)?.cancel()
    }
    
    func taskStatus(_ identifier : OperationID) -> TaskStatus {
        if let task = task(identifier) {
            switch task.state {
            case .finished :
                return .done
                
            case .executing :
                return .perform
                
            case .ready :
                return .wait
            }
        }
        return .unknown
    }
    
    private func task(_ operationId : OperationID) -> NetworkOperation? {
        let filterOperation = tasksQueue.operations.filter { (operation) -> Bool in
            if let customOperation = operation as? NetworkOperation {
                return customOperation.operationIdentifier() == operationId
            }
            return false
        }
        return filterOperation.first as? NetworkOperation
    }
}
