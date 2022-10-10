//
//  ScheduleInteractor.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ScheduleBusinessLogic {
  func makeRequest(request: Schedule.Model.Request.RequestType)
}

class ScheduleInteractor: ScheduleBusinessLogic {

  var presenter: SchedulePresentationLogic?
  var service: ScheduleService?
    
    private var networkService: Networking = NetworkService()
  
  func makeRequest(request: Schedule.Model.Request.RequestType) {
    if service == nil {
      service = ScheduleService()
    }
      
      switch request {
          
      case .getTeachers:
          networkService.request(path: API.teachers, params: ["":""]) { data, error in
              if let error = error {
                  print(error.localizedDescription)
              }
              
              let decoder = JSONDecoder()
              guard let data = data else { return }
              let response = try? decoder.decode(TeachersResponse.self, from: data)
              self.presenter?.presentData(response: Schedule.Model.Response.ResponseType.presentTeachers(teachers: response!))
              }
                
      case .getSchedule(teacherId: let teacherId):
          let fullPath = API.schedule + "/\(teacherId)"
          networkService.request(path: fullPath, params: ["":""]) { data, error in
              if let error = error {
                  print(error.localizedDescription)
              }
              
              let decoder = JSONDecoder()
              guard let data = data else { return }
              let response = try? decoder.decode(ScheduleResponse.self, from: data)
              self.presenter?.presentData(response: Schedule.Model.Response.ResponseType.presentSchedule(schedule: response!))
          }
      case .getScheduleOnWeek(teacherId: let teacherId, numberOfWeek: let numberOfWeek):
          let fullPath = API.schedule + "/\(teacherId)/\(numberOfWeek)"
          networkService.request(path: fullPath, params: ["":""]) { data, error in
              if let error = error {
                  print(error.localizedDescription)
              }
              
              let decoder = JSONDecoder()
              guard let data = data else { return }
              let response = try? decoder.decode(ScheduleWeekResponse.self, from: data)
              self.presenter?.presentData(response: Schedule.Model.Response.ResponseType.presentScheduleOnWeek(schedule: response!))
          }
      }
  }
  
}
