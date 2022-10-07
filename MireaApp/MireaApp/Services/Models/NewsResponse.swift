//
//  NewsResponse.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//

import Foundation

struct NewsItem: Decodable {
    let id: Int?
    let image: String?
    let name: String?
}

typealias NewsResponse = [NewsItem]
