//
//  SchedulePresenter.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SchedulePresentationLogic {
  func presentData(response: Schedule.Model.Response.ResponseType)
}

class SchedulePresenter: SchedulePresentationLogic {
  weak var viewController: ScheduleDisplayLogic?
  
  func presentData(response: Schedule.Model.Response.ResponseType) {
      switch response {
          
      case .presentTeachers(teachers: let teachers):
          
          let cells = teachers.map { teachersItem in
              cellViewModel(from: teachersItem)
          }
          
          var teachersViewModel = TeachersViewModel.init(cells: cells)
          teachersViewModel.cells = teachersViewModel.cells.suffix(teachersViewModel.cells.count - 8)
          
          viewController?.displayData(viewModel: Schedule.Model.ViewModel.ViewModelData.displayTeachers(teachersViewModel: teachersViewModel))
          
      case .presentSchedule(schedule: let schedule):
          
          var cellsForEvenWeeks: [ScheduleViewModel.Cell] = []
          var cellsForOddWeeks: [ScheduleViewModel.Cell] = []
          
          for openedSchedule in schedule {
              for (_, scheduleOddAndEven) in openedSchedule {
                  if let evenWeeks = scheduleOddAndEven.even {
                      for scheduleItems in evenWeeks {
                          cellsForEvenWeeks.append(cellOfEvenAndOddWeeksViewModel(from: scheduleItems))
                      }
                  }
                  
                  if let oddWeeks = scheduleOddAndEven.odd {
                      for scheduleItems in oddWeeks {
                          cellsForOddWeeks.append(cellOfEvenAndOddWeeksViewModel(from: scheduleItems))
                      }
                  }
              }
          }
          
          let finalCells = cellsForEvenWeeks + cellsForOddWeeks
          
          let scheduleViewModel = ScheduleViewModel.init(cells: finalCells)
          viewController?.displayData(viewModel: Schedule.Model.ViewModel.ViewModelData.displaySchedule(schedule: scheduleViewModel))
          
      case .presentScheduleOnWeek(schedule: let schedule):
        
          var cells: [ScheduleWeekViewModel.Cell] = []
          
          for openSchedule in schedule {
              for scheduleItem in openSchedule {
                  cells.append(cellOfWeekViewModel(from: scheduleItem))
              }
            }
          
          
          let scheduleWeekViewModel = ScheduleWeekViewModel.init(cells: cells)
          viewController?.displayData(viewModel: Schedule.Model.ViewModel.ViewModelData.presentScheduleOnWeek(schedule: scheduleWeekViewModel))
      }
  }
    
    private func cellOfEvenAndOddWeeksViewModel(from scheduleItem: ScheduleItems) -> ScheduleViewModel.Cell {
        
        var weeks: [Int] = []

        if scheduleItem.weeks != nil {
            for el in scheduleItem.weeks! {
                weeks.append(Int(el))
            }
        }
        
        return ScheduleViewModel.Cell.init(name: String(scheduleItem.name ?? ""), number: Int(scheduleItem.number ?? 0), wdNum: Int(scheduleItem.number ?? 0), group: String(scheduleItem.group ?? ""), type: String(scheduleItem.type ?? ""), room: String(scheduleItem.room ?? ""), weeks: weeks, strWeeks: String(scheduleItem.strWeeks ?? ""))
    }
    
    private func cellOfWeekViewModel(from scheduleWeekItem: ScheduleWeekItems) -> ScheduleWeekViewModel.Cell {
        return ScheduleWeekViewModel.Cell.init(name: String(scheduleWeekItem.name ?? ""), number: Int(scheduleWeekItem.number ?? 0), wdNum: Int(scheduleWeekItem.number ?? 0), group: String(scheduleWeekItem.group ?? ""), type: String(scheduleWeekItem.type ?? ""), room: String(scheduleWeekItem.room ?? ""), week: Int(scheduleWeekItem.week ?? 0))
    }
    
    private func cellViewModel(from teachersItem: TeachersItem) -> TeachersViewModel.Cell {
        return TeachersViewModel.Cell.init(id: Int(teachersItem.id ?? 0), name: String(teachersItem.name ?? ""))
    }
  
}
