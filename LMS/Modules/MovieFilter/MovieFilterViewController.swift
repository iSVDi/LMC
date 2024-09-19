//
//  MovieFilterViewController.swift
//  LMS
//
//  Created by daniil on 19.09.2024.
//

import UIKit
import TinyConstraints

enum MovieFilterDTO {
    case year(year: Int)
    case rating
    
func getOrder() -> String {
        switch self {
        case .year(_):
            return "YEAR"
        case .rating:
            return "RATING"
        }
    }
    
}

class MovieFilterViewController: UIViewController {
    
    private let yearLabel = UILabel()
    private let ratingLabel = UILabel()
    private let yearSwitch = UISwitch()
    private let ratingSwitch = UISwitch()
    private let yearPicker = UIPickerView()
    
    private var selectedYearId = 0
    private(set) var years = Array((1950...2024).reversed())
    private var filter: MovieFilterDTO?
    private var filterHandler: ((MovieFilterDTO) ->())?
    
    
    init(filterHandler: @escaping (MovieFilterDTO) -> ()) {
        self.filterHandler = filterHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let filter else {
            return
        }
        filterHandler?(filter)
    }
    
    
    private func setupLayout() {
        let yearLabelSwitchStack = UIStackView()
        yearLabelSwitchStack.axis = .horizontal
        yearLabelSwitchStack.spacing = 10
        [yearLabel, yearSwitch].forEach { subview in
            yearLabelSwitchStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        
        let yearStack = UIStackView()
        
        yearStack.axis = .vertical
        [yearLabelSwitchStack, yearPicker].forEach { subview in
            yearStack.addArrangedSubview(subview)
            subview.horizontalToSuperview()
        }
        yearPicker.height(80)
        
        let ratingStack = UIStackView()
        ratingStack.axis = .horizontal
        
        [ratingLabel, ratingSwitch].forEach { subview in
            ratingStack.addArrangedSubview(subview)
            subview.verticalToSuperview()
        }
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        [yearStack, ratingStack].forEach { subview in
            mainStack.addArrangedSubview(subview)
            subview.horizontalToSuperview()
            
        }
        mainStack.spacing = 20
        
        view.addSubview(mainStack)
        mainStack.edgesToSuperview(excluding: .bottom, insets: .horizontal(16), usingSafeArea: true)
        
    }
    
    private func setupViews() {
        title = AppStrings.filterTitle
        yearLabel.text = AppStrings.yearTitle
        ratingLabel.text = AppStrings.ratingTitle
        yearLabel.textColor = AppColors.appColor
        ratingLabel.textColor = AppColors.appColor
        
        yearSwitch.onTintColor = AppColors.appColor
        ratingSwitch.onTintColor = AppColors.appColor
        
        yearPicker.isHidden = true
        yearPicker.selectRow(selectedYearId, inComponent: 0, animated: false)
        yearPicker.dataSource = self
        yearPicker.delegate = self
        
        yearSwitch.addTarget(self, action: #selector(yearSwitchHandler), for: .valueChanged)
        ratingSwitch.addTarget(self, action: #selector(ratingSwitchHandler), for: .valueChanged)
        
        
    }
    
    @objc
    private func yearSwitchHandler(switchView: UISwitch) {
        if switchView.isOn {
            ratingSwitch.setOn(false, animated: true)
            filter = .year(year: years[selectedYearId])
        }
        yearPicker.isHidden = !switchView.isOn
    }
    
    @objc
    private func ratingSwitchHandler(switchView: UISwitch) {
        if switchView.isOn {
            yearSwitch.setOn(false, animated: true)
            yearPicker.isHidden = true
            filter = .rating
        }
    }
    
}

extension MovieFilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(years[row])",
                                  attributes: [NSAttributedString.Key.foregroundColor: AppColors.appWhite])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filter = .year(year: years[row])
    }
    
}
