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
    
    private lazy var scheduleViewModel = ScheduleViewModel.init(cells: [])

    private lazy var scheduleWeekViewModel = ScheduleWeekViewModel.init(cells: [])
    
    private let networkService: Networking = NetworkService()
    
    private lazy var nameTeacher: String? = ""
    
    private lazy var selectWeek: Int = 0
    
    private let countOfWeeks: [Int] = [1, 2, 3, 4, 5, 6,
                                            7, 8, 9, 10, 11, 12,
                                            13, 14, 15, 16, 17, 18]
    
    private lazy var collectionViewForSchedule: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 7)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    } ()
    
    //Все, что связано с выбором учителя
    
    private let pickerTeacherView = UIPickerView()
    
    private let findTeacherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(rgb: 0xeeedff)
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        return view
    } ()
    
    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textAlignment = .left
        field.layer.cornerRadius = 5
        field.placeholder = "Выберите преподавателя"
        field.backgroundColor = UIColor.init(rgb: 0xeeedff)
        return field
    } ()
    
    private let imageSearch: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.init(rgb: 0x574af9)
        return imageView
    } ()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButtton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButtton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    } ()
    
    //Все, что связано с выбором недели
    
    private let pickerNumberOfWeekView = UIPickerView()
    
    private let numberField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textAlignment = .center
        field.layer.cornerRadius = 5
        field.placeholder = "Неделя"
        field.backgroundColor = UIColor.init(rgb: 0xeeedff)
        field.layer.shadowColor = UIColor.black.cgColor
        field.layer.shadowRadius = 2
        field.layer.shadowOpacity = 0.7
        field.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        return field
    } ()
    
    private lazy var toolBarForWeek: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButtton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePickerForWeek(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerForWeek(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButtton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    } ()
    
    //Кнопки для вывода расписания

    private let buttonForSearchSchedule: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("На семестр", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.init(rgb: 0x574af9)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(searchSchedule(_:)), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        return button
    } ()
    
    private let buttonForScheduleOnWeek: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("На неделю", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.init(rgb: 0x574af9)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(searchScheduleOnWeek(_:)), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        return button
    } ()
    
    private lazy var errorLable: UILabel = {
        let label = UILabel()
        label.text = "Пар нет!"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
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
    let interactor            = ScheduleInteractor()
    let presenter             = SchedulePresenter()
    let router                = ScheduleRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
 
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      title = "Расписание"
      view.backgroundColor = .white
      addSubviews()
      setPickers()
      animateStaticItems()
      setCollection()
      makeConstraints()
      interactor?.makeRequest(request: .getTeachers)
  }

  func displayData(viewModel: Schedule.Model.ViewModel.ViewModelData) {
      switch viewModel {
      case .displayTeachers(teachersViewModel: let teachersViewModel):
          self.teachersViewModel = teachersViewModel
          pickerTeacherView.reloadAllComponents()
      case .displaySchedule(schedule: let schedule):
          errorLable.isHidden = true
          self.scheduleViewModel = schedule
          self.scheduleWeekViewModel = ScheduleWeekViewModel.init(cells: [])
          if scheduleViewModel.cells.isEmpty {
              errorLable.isHidden = false
          }
          collectionViewForSchedule.reloadData()
          animateCollectionView()
      case .presentScheduleOnWeek(schedule: let schedule):
          errorLable.isHidden = true
          self.scheduleWeekViewModel = schedule
          self.scheduleViewModel = ScheduleViewModel.init(cells: [])
          if scheduleWeekViewModel.cells.isEmpty {
              errorLable.isHidden = false
          }
          collectionViewForSchedule.reloadData()
          animateCollectionView()
      }
  }
}

extension ScheduleViewController {
    @objc private func donePicker(_ sender: UIButton) {
        textField.text = nameTeacher
        textField.resignFirstResponder()
    }
    
    @objc private func cancelPicker(_ sender: UIButton) {
        textField.resignFirstResponder()
    }
    
    @objc private func donePickerForWeek(_ sender: UIButton) {
        guard selectWeek != 0 else { numberField.resignFirstResponder(); return}
        numberField.text = String(selectWeek)
        numberField.resignFirstResponder()
    }
    
    @objc private func cancelPickerForWeek(_ sender: UIButton) {
        numberField.resignFirstResponder()
    }
    
    @objc private func searchSchedule(_ sender: UIButton)  {
        for teachersItem in teachersViewModel.cells {
            if teachersItem.name == textField.text {
                interactor?.makeRequest(request: Schedule.Model.Request.RequestType.getSchedule(teacherId: teachersItem.id ?? 0))
            }
        }
    }
    
    @objc private func searchScheduleOnWeek(_ sender: UIButton)  {
        for teachersItem in teachersViewModel.cells {
            if teachersItem.name == textField.text {
                interactor?.makeRequest(request: Schedule.Model.Request.RequestType.getScheduleOnWeek(teacherId: teachersItem.id ?? 0, numberOfWeek: selectWeek))
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(findTeacherView)
        view.addSubview(numberField)
        findTeacherView.addSubview(textField)
        findTeacherView.addSubview(imageSearch)
        view.addSubview(buttonForSearchSchedule)
        view.addSubview(buttonForScheduleOnWeek)
        view.addSubview(collectionViewForSchedule)
        view.addSubview(errorLable)
    }
    
    private func setPickers() {
        textField.inputView = pickerTeacherView
        textField.inputAccessoryView = toolBar
        numberField.inputView = pickerNumberOfWeekView
        numberField.inputAccessoryView = toolBarForWeek
        pickerTeacherView.dataSource = self
        pickerTeacherView.delegate = self
        pickerNumberOfWeekView.dataSource = self
        pickerNumberOfWeekView.delegate = self
    }
    
    private func setCollection() {
        collectionViewForSchedule.dataSource = self
        collectionViewForSchedule.delegate = self
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            findTeacherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 40),
            findTeacherView.heightAnchor.constraint(equalToConstant: 40),
            findTeacherView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            findTeacherView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 20),
            numberField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 40),
            numberField.heightAnchor.constraint(equalToConstant: 40),
            numberField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.20),
            numberField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width / 20),
            imageSearch.widthAnchor.constraint(equalTo: findTeacherView.widthAnchor, multiplier: 0.08),
            imageSearch.heightAnchor.constraint(equalTo: findTeacherView.heightAnchor),
            imageSearch.leadingAnchor.constraint(equalTo: findTeacherView.leadingAnchor, constant: 10),
            imageSearch.centerYAnchor.constraint(equalTo: findTeacherView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: findTeacherView.heightAnchor),
            textField.widthAnchor.constraint(equalTo: findTeacherView.widthAnchor, multiplier: 0.85),
            textField.trailingAnchor.constraint(equalTo: findTeacherView.trailingAnchor),
            buttonForSearchSchedule.heightAnchor.constraint(equalToConstant: 60),
            buttonForSearchSchedule.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            buttonForSearchSchedule.topAnchor.constraint(equalTo: findTeacherView.bottomAnchor, constant: view.frame.height / 40),
            buttonForSearchSchedule.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 20),
            buttonForScheduleOnWeek.heightAnchor.constraint(equalToConstant: 60),
            buttonForScheduleOnWeek.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            buttonForScheduleOnWeek.topAnchor.constraint(equalTo: findTeacherView.bottomAnchor, constant: view.frame.height / 40),
            buttonForScheduleOnWeek.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width / 20),
            collectionViewForSchedule.topAnchor.constraint(equalTo: buttonForSearchSchedule.bottomAnchor, constant: 20),
            collectionViewForSchedule.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionViewForSchedule.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLable.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func animateStaticItems() {
        for (index, view) in [buttonForSearchSchedule, findTeacherView,
                             buttonForScheduleOnWeek, numberField, pickerNumberOfWeekView].enumerated() {
            
            var translationTransform = CATransform3DTranslate(CATransform3DIdentity, -300, 0, 0)
            if index > 1 {
                translationTransform = CATransform3DTranslate(CATransform3DIdentity, 300, 0, 0)
            }
            
            view.layer.transform = translationTransform
            view.layer.opacity = 0
            
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                view.layer.opacity = 1
                view.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    private func animateCollectionView() {
        collectionViewForSchedule.layer.opacity = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.collectionViewForSchedule.layer.opacity = 1
        })
    }
}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerTeacherView {
            return teachersViewModel.cells.count
        } else {
            return countOfWeeks.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerTeacherView {
            let result = teachersViewModel.cells[row].name
            return result
        } else {
            let result = String(countOfWeeks[row])
            return result
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerTeacherView {
            nameTeacher = teachersViewModel.cells[row].name
        } else {
            selectWeek = countOfWeeks[row]
        }
    }
}

extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !scheduleViewModel.cells.isEmpty {
            return scheduleViewModel.cells.count
        } else if !scheduleWeekViewModel.cells.isEmpty {
            return scheduleWeekViewModel.cells.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.reuseId, for: indexPath) as! ScheduleCell
        
        if !scheduleViewModel.cells.isEmpty {
            cell.configureLabelForLocation(number: scheduleViewModel.cells[indexPath.row].number ?? 0, wdNum: scheduleViewModel.cells[indexPath.row].wdNum ?? 0, strWeeks: scheduleViewModel.cells[indexPath.row].strWeeks ?? "", room: scheduleViewModel.cells[indexPath.row].room ?? "")
            cell.configureLabelForSubject(name: scheduleViewModel.cells[indexPath.row].name ?? "", type: scheduleViewModel.cells[indexPath.row].type ?? "", group: scheduleViewModel.cells[indexPath.row].group ?? "")
        } else if !scheduleWeekViewModel.cells.isEmpty {
            cell.configureWeekLabelForLocation(number: scheduleWeekViewModel.cells[indexPath.row].number ?? 0, wdNum: scheduleWeekViewModel.cells[indexPath.row].wdNum ?? 0, room: scheduleWeekViewModel.cells[indexPath.row].room ?? "")
            cell.configureLabelForSubject(name: scheduleWeekViewModel.cells[indexPath.row].name ?? "", type: scheduleWeekViewModel.cells[indexPath.row].type ?? "", group: scheduleWeekViewModel.cells[indexPath.row].group ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 5)
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        let translationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0)
//        cell.layer.transform = translationTransform
//        cell.layer.opacity = 0
//
//        UIView.animate(withDuration: 1.2, delay: 0.1 * Double(indexPath.row), options: .curveEaseInOut, animations: {
//            cell.layer.opacity = 1
//            cell.layer.transform = CATransform3DIdentity
//        })
//    }
}
