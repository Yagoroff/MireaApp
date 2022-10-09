//
//  ScheduleModels.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Schedule {
   
    enum Model {
      struct Request {
        enum RequestType {
          case getTeachers
            case getSchedule(teacherId: Int)
        }
      }
      struct Response {
        enum ResponseType {
            case presentTeachers(teachers: TeachersResponse)
            case presentSchedule(schedule: ScheduleResponse)
        }
      }
      struct ViewModel {
        enum ViewModelData {
            case displayTeachers(teachersViewModel: TeachersViewModel)
            case displaySchedule(schedule: ScheduleViewModel)
        }
    }
  }
}

struct TeachersViewModel {
    struct Cell {
        let id: Int?
        let name: String?
    }
    var cells: [Cell]
}

struct ScheduleViewModel {
    
    struct Cell {
        let name: String?
        let number, wdNum: Int?
        let group, type, room: String?
        let weeks: [Int]?
        let strWeeks: String?
    }
    
    let cellsOfEven: [Cell]
    let cellsOfOdd: [Cell]
}
