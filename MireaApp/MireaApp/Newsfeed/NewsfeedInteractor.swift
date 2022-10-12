//
//  NewsfeedInteractor.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
  func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {

  var presenter: NewsfeedPresentationLogic?
  var service: NewsfeedService?
    
    private var networkService: Networking = NetworkService()

  func makeRequest(request: Newsfeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsfeedService()
    }
      
      switch request {
          
      case .getNewsFeed(page: let page):
          var params = ["limit": "10"]
          params["page"] = String(page)
          networkService.request(path: API.news, params: params) { data, error in
              if let error = error {
                  print(error.localizedDescription)
              }
              
              let decoder = JSONDecoder()
              guard let data = data else { return }
              let response = try? decoder.decode(NewsResponse.self, from: data)
              self.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(feed: response!))
              }
      }
      }
      
  }
    

