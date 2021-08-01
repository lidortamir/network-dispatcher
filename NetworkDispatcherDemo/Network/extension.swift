//
//  extension.swift
//  NetworkDispatcherDemo
//
//  Created by lidor tamir on 01/08/2021.
//

import Foundation


extension String {
    public func asUrl() throws -> URL {
        guard let url = URL(string: self) else {
            throw NetworkError.invalidRequest(reason: .invalidURL(self))
        }
        return url
    }
}

extension Data {
    func decodeToJson() -> Any? {
        do{
        let json = try JSONSerialization.jsonObject(with: self, options: [])
            return json
        }catch{ print(" Data decodeToJson error") }
        return nil
    }
}

extension JSONDecoder {
    func decode<T : Decodable>(_ from : Any , to : T.Type) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: from, options: .prettyPrinted) else { return nil}
        do {
            let model = try self.decode(T.self, from: data)
            return model
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension FileManager {
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        let rootPath =  path.first
        return rootPath
    }
    
    func saveImage(_ key : String , image: Data) -> Bool {
        if let rootDirectory = documentDirectoryPath()  {
            try? image.write(to: rootDirectory)
            return true
        }
        return false
    }
    
    func loadImage(_ key : String) -> Data? {
        if let url = documentDirectoryPath() {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}



