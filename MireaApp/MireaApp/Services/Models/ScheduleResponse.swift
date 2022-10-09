//
//  ScheduleResponse.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//

import Foundation

struct TeachersItem: Decodable {
    let id: Int?
    let name: String?
}

typealias TeachersResponse = [TeachersItem]

struct ScheduleEvenOddModel: Decodable {
    let even, odd: [ScheduleItems]?
}

struct ScheduleItems: Decodable {
    let name: String?
    let number, wdNum: Int?
    let group, type, room: String?
    let weeks: [Int]?
    let strWeeks: String?
}

typealias ScheduleResponse = [[String: ScheduleEvenOddModel]]

