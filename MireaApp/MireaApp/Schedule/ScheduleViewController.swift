//
//  ScheduleViewController.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ScheduleDisplayLogic: class {
  func displayData(viewModel: Schedule.Model.ViewModel.ViewModelData)
}

class ScheduleViewController: UIViewController, ScheduleDisplayLogic {

  var interactor: ScheduleBusinessLogic?
  var router: (NSObjectProtocol & ScheduleRoutingLogic)?
    
    private var teachersViewModel = TeachersViewModel.init(cells: [])
    
    private let networkService: Networking = NetworkService()
    
    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .systemGray2
        field.layer.cornerRadius = 5
        field.textAlignment = .center
        field.placeholder = "Выберите преподавателя"
        return field
    } ()
    
    private let pickerView = UIPickerView()
    
    private let buttonForSearchSchedule: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вывести расписание", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(searchSchedule(_:)), for: .touchUpInside)
        return button
    } ()
    
    @objc private func searchSchedule(_ sender: UIButton)  {
        for teachersItem in teachersViewModel.cells {
            if teachersItem.name == textField.text {
                interactor?.makeRequest(request: Schedule.Model.Request.RequestType.getSchedule(teacherId: teachersItem.id ?? 0))
            }
        }
    }
    
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
    let interactor            = ScheduleInteractor()
    let presenter             = SchedulePresenter()
    let router                = ScheduleRouter()
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
      view.backgroundColor = .white
      view.addSubview(textField)
      view.addSubview(buttonForSearchSchedule)
      textField.inputView = pickerView
      makeConstraints()
      pickerView.dataSource = self
      pickerView.delegate = self
      interactor?.makeRequest(request: .getTeachers)
  }
  
  func displayData(viewModel: Schedule.Model.ViewModel.ViewModelData) {
      switch viewModel {
          
      case .displayTeachers(teachersViewModel: let teachersViewModel):
          self.teachersViewModel = teachersViewModel
          pickerView.reloadAllComponents()
          
      case .displaySchedule(schedule: let schedule):
          print(schedule)
      }
  }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonForSearchSchedule.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            buttonForSearchSchedule.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teachersViewModel.cells.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let result = teachersViewModel.cells[row].name
        return result
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = teachersViewModel.cells[row].name
        textField.resignFirstResponder()
    }
}
