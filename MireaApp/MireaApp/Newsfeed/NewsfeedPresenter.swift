//
//  NewsfeedPresenter.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
  weak var viewController: NewsfeedDisplayLogic?
  
  func presentData(response: Newsfeed.Model.Response.ResponseType) {
      switch response {
          
      case .presentNewsFeed(feed: let feed):
          
          let cells = feed.map { newsItem in
              cellViewModel(from: newsItem)
          }
                    
          let feedViewModel = FeedViewModel.init(cells: cells)
          viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsFeed(feedViewModel: feedViewModel))
      }
  }
    
    private func cellViewModel(from feedItem: NewsItem) -> FeedViewModel.Cell {
        return FeedViewModel.Cell.init(id: Int(feedItem.id ?? 0), name: String(feedItem.name ?? ""), image: String(feedItem.image ?? ""))
    }
  
}
