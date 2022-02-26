//
//  PickerPopupViewController.swift
//  Slash Roll
//
//  Created by Voxar on 21.02.22.
//

import UIKit


class PickUpPointPickerPopup: UIViewController {

    //MARK: - Properties

    private(set) lazy var selectedComponent = 0
    private var pickUpPonints = ["Победителей 111, Минск", "Скорины 25/3, Минск"]

    //MARK: - GUI Varibles

    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()


    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 500 , height: 250)
        view.backgroundColor = .clear
        addSubviews()
        configureLayout()
    }

    private func addSubviews() {
        view.addSubview(picker)
    }

    //MARK: - Layout Configuration

    private func configureLayout() {
        picker.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }

    func getPickUpPointName(with id: Int) -> String {
        pickUpPonints[id]
    }
}

//MARK: Delegates

extension PickUpPointPickerPopup: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedComponent = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickUpPonints[row]
    }
}

//MARK: DataSource

extension PickUpPointPickerPopup: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickUpPonints.count
    }
}

