//
//  NewsfeedModels.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
          case getNewsFeed(page: Int)
      }
    }
    struct Response {
      enum ResponseType {
          case presentNewsFeed(feed: NewsResponse)
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case displayNewsFeed(feedViewModel: FeedViewModel)
      }
    }
  }
}

//Новостые ячейки

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var id: Int?
        var name: String?
        var image: String?
    }
    
    var cells: [Cell]
}
