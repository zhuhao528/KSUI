//
//  UKSDatePickerViewDemoViewController.swift
//  KSUI_Example
//
//  Created by zhu hao on 2020/9/27.
//  Copyright © 2020 zhuhao. All rights reserved.
//

import UIKit
import KSUI

@objc class UKSDatePickerViewDemoViewController: UIViewController {
    
    var pickerView: UIPickerView = UIPickerView()
    var datePickerView: UIDatePicker = UIDatePicker()
    
    var uksPickerView: UKSPickerView = UKSPickerView()
    var agePicker: UKSDatePickerView = UKSDatePickerView.init(frame:CGRect(x: 400, y: 220, width: 300, height: 150))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        
        let button1 = UIButton(type: .custom)
        button1.frame = CGRect(x: 50, y: 100, width: 100, height: 50)
        button1.setTitle("年龄选择器", for: .normal)
        button1.backgroundColor = .blue
        button1.setTitleColor(.yellow, for: .normal)
        button1.addTarget(self,action: #selector(UKSDatePickerViewDemoViewController.buttonClicked(button:)),
                          for: .touchUpInside)
        view.addSubview(button1)
        
        /// 系统UIPickerView
        pickerView.center = self.view.center
        pickerView.dataSource=self
        pickerView.delegate=self
        pickerView.showsSelectionIndicator = true
        pickerView.frame = CGRect(x: 200, y: 100, width: 100, height: 80)
        pickerView.backgroundColor = .gray
        self.view.addSubview(pickerView)
        
        /// 时间选择器
        datePickerView.center = self.view.center
        datePickerView.frame = CGRect(x: 100, y: 210, width: 250, height: 150)
        datePickerView.backgroundColor = .gray
        self.view.addSubview(datePickerView)
        
        /// KSUI UKSPickerView
        uksPickerView.center = self.view.center
        uksPickerView.dataSource=self
        uksPickerView.delegate=self
        uksPickerView.frame = CGRect(x: 400, y: 100, width: 200, height: 100)
        uksPickerView.backgroundColor = .lightGray
        uksPickerView.selectionStyle = PickerView.UKSSelectionStyle.overlay
        self.view.addSubview(uksPickerView)
        
        /// UKSPickerView 的应用年龄选择器
//        agePicker.frame = CGRect(x: 400, y: 220, width: 300, height: 200)
        agePicker.backgroundColor = .red
        self.view.addSubview(agePicker)
    }

    @objc public func buttonClicked(button:UIButton)  {
        print("clicked")
    }
    
}

/// Mark - UIPickerViewProtocol
extension UKSDatePickerViewDemoViewController: UIPickerViewDelegate{
    
}

extension UKSDatePickerViewDemoViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "hello"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        label.text = "111"
        return label
    }

}

/// Mark - UKSPickerViewProtocol
extension UKSDatePickerViewDemoViewController: UKSPickerViewDelegate{

}

extension UKSDatePickerViewDemoViewController: UKSPickerViewDataSource{
    
    func uksNumberOfComponents(in pickerView: UKSPickerView) -> Int {
        return 3
    }
    
    func uksPickerView(_ pickerView: UKSPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return 3
        }
        return 5
    }
    
    func uksPickerView(_ pickerView: UKSPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 1 {
            return "——"
        }
        return "hello"
    }
    
}

