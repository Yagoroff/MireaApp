//
//  NewsfeedViewController.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {

  var interactor: NewsfeedBusinessLogic?
  var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel.init(cells: [])
    
    private var pageCount = 0
            
    let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(NewsfeedCell.self, forCellReuseIdentifier: NewsfeedCell.reuseId)
        return table
    } ()
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    } ()

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsfeedInteractor()
    let presenter             = NewsfeedPresenter()
    let router                = NewsfeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: View lifecycle
    func setTableView() {
        tableView.addSubview(refreshControl)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
      title = "Новости"
      view.backgroundColor = .systemBackground
      setTableView()
      interactor?.makeRequest(request: .getNewsFeed(page: pageCount))
      NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
      ])
  }
  
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
      switch viewModel {
          
      case .displayNewsFeed(feedViewModel: let feedViewModel):
          self.feedViewModel.cells += feedViewModel.cells
          tableView.reloadData()
          refreshControl.endRefreshing()
//          self.feedViewModel.cells.map { cell in
//              print(cell.id)
//          }
      }
  }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.4 {
            pageCount += 1
            interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed(page: pageCount))
        }
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as! NewsfeedCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/2
    }
}

extension NewsfeedViewController {
    @objc private func refresh() {
        pageCount = 0
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed(page: pageCount))
        feedViewModel.cells = []
    }
}
