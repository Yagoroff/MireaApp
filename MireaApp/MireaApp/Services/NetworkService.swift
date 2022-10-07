//
//  NetworkService.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(from: path, params: params)
        let session = URLSession.init(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        
        return components.url!
    }
}
