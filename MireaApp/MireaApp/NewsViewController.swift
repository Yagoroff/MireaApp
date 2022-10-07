//
//  ViewController.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//

import UIKit

class NewsViewController: UIViewController {

    private let networkService: Networking = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params = ["limit": "10"]
        decodeJSON(params: params)
        }

}

extension NewsViewController {
    func decodeJSON(params: [String: String]) {
        networkService.request(path: API.news, params: params) { data, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            let decoder = JSONDecoder()
            guard let data = data else { return }
            let response = try? decoder.decode(NewsResponse.self, from: data)
            response!.map { newsItem in
                print(newsItem.name)
            }
        }
    }
}

