//
//  CampusMapInteractor.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CampusMapBusinessLogic {
  func makeRequest(request: CampusMap.Model.Request.RequestType)
}

class CampusMapInteractor: CampusMapBusinessLogic {

  var presenter: CampusMapPresentationLogic?
  var service: CampusMapService?
  
  func makeRequest(request: CampusMap.Model.Request.RequestType) {
    if service == nil {
      service = CampusMapService()
    }
  }
  
}
