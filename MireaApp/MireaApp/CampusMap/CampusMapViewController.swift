//
//  CampusMapViewController.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit

protocol CampusMapDisplayLogic: class {
  func displayData(viewModel: CampusMap.Model.ViewModel.ViewModelData)
}

class CampusMapViewController: UIViewController, CampusMapDisplayLogic {

  var interactor: CampusMapBusinessLogic?
  var router: (NSObjectProtocol & CampusMapRoutingLogic)?
    
    private let webMapView = WKWebView()


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
    let interactor            = CampusMapInteractor()
    let presenter             = CampusMapPresenter()
    let router                = CampusMapRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      view.addSubview(webMapView)
      webMapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
      loadRequest()
  }
  
  func displayData(viewModel: CampusMap.Model.ViewModel.ViewModelData) {

  }
}

extension CampusMapViewController {
    private func loadRequest() {
        guard let url = URL(string: "https://ischemes.ru/group/rtu-mirea/vern78") else {return}
        let urlRequest = URLRequest(url: url)
        webMapView.load(urlRequest)
    }
}
