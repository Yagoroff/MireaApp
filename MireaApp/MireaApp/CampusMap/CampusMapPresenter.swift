//
//  CampusMapPresenter.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CampusMapPresentationLogic {
  func presentData(response: CampusMap.Model.Response.ResponseType)
}

class CampusMapPresenter: CampusMapPresentationLogic {
  weak var viewController: CampusMapDisplayLogic?
  
  func presentData(response: CampusMap.Model.Response.ResponseType) {
  
  }
  
}
