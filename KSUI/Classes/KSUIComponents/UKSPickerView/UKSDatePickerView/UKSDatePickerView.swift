//
//  UKSAgePickerView.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/29.
//

import UIKit

open class UKSDatePickerView: UIView {
    
    open var date: Date?
    
    let presentYear =  Calendar.current.component(.year, from: Date())
    let presentMonth = Calendar.current.component(.month, from: Date())
    let presentDay = Calendar.current.component(.day, from: Date())

    var uksPickerView: UKSPickerView = UKSPickerView()
        
    var years:Array<String> = {
        var array:[String] = []
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        for i in year-12...year {
            array.append(String(i))
        }
        return array
    }()
    
    // MARK: 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configDefaultInit()
        configSubviews()
        configLayoutSubviews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configDefaultInit()
        configSubviews()
        configLayoutSubviews()
    }
    
    open override func layoutSubviews() {
        superview?.layoutSubviews()
    }
    
}

// MARK: - Layout
extension UKSDatePickerView {
    
    func configDefaultInit() {
        uksPickerView.center = self.center
        uksPickerView.dataSource = self
        uksPickerView.delegate = self
        uksPickerView.backgroundColor = .white
        uksPickerView.selectionStyle = PickerView.UKSSelectionStyle.overlay
    }
    
    func configSubviews() {
        addSubview(uksPickerView)
    }
    
    func configLayoutSubviews() {
        uksPickerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: Private
extension UKSDatePickerView {

    public func daysIn(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents), let range = calendar.range(of: .day, in: .month, for: date)  {
            return range.count
        } else {
            return 0
        }
    }
    
    // Generates date object from given month and year
    public func dateFrom(month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = 0
        dateComponents.minute = 0

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }

    // Generates date object from day montha and year
    public func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone.current

        dateComponents.hour = 0
        dateComponents.minute = 0

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
    
}

// MARK: Protocol
extension UKSDatePickerView: UKSPickerViewDataSource{
    
    public func uksNumberOfComponents(in pickerView: UKSPickerView) -> Int {
        return 3
    }
    
    public func uksPickerView(_ pickerView: UKSPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.years.count
        }else if component == 1 {
            return 12
        }else if component == 2{
            return 31
        }
        return 0
    }
    
    public func uksPickerView(_ pickerView: UKSPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.years[row] + "年"
        }else if component == 1{
            return String(row + 1) + "月"
        }else{
            return String(row + 1) + "日"
        }
    }
    
}

extension UKSDatePickerView: UKSPickerViewDelegate {
 
    public func uksPickerView(_ pickerView: UKSPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView.pickerViews.count != 3 {
            return
        }
        guard pickerView.pickerViews[0].currentSelectedRow != nil else {
            return
        }
        guard pickerView.pickerViews[1].currentSelectedRow != nil else {
            return
        }
        guard pickerView.pickerViews[2].currentSelectedRow != nil else {
            return
        }
        
        guard let selectYear = Int(self.years[pickerView.pickerViews[0].currentSelectedRow]) else { return }
        let selectMonth =  pickerView.pickerViews[1].currentSelectedRow + 1
        var selectDay =  pickerView.pickerViews[2].currentSelectedRow + 1
        /// 只能选择当前年份12年前至今天
        if selectYear == presentYear - 12 {
            if selectMonth <= presentMonth {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pickerView.pickerViews[1].scrollowToRow(self.presentMonth - 1, animated: true)
                }
            }
            if selectMonth == presentMonth && selectDay <= presentDay {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pickerView.pickerViews[2].scrollowToRow(self.presentDay - 1, animated: true)
                }
            }
        }
        if selectYear == presentYear {
            if selectMonth > presentMonth {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pickerView.pickerViews[1].scrollowToRow(self.presentMonth - 1, animated: true)
                }
            }
            if selectMonth == presentMonth && selectDay > presentDay {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pickerView.pickerViews[2].scrollowToRow(self.presentDay - 1, animated: true)
                }
            }
        }
        
        let farDate = selectYear == presentYear - 12 && selectMonth == presentMonth && selectDay <= presentDay
        let nowDate = selectYear == presentYear && selectMonth == presentMonth && selectDay > presentDay
        /// 月份对应的天数
        if !farDate && !nowDate {
            let days = self.daysIn(month: selectMonth, year: selectYear)
            if  selectDay > self.daysIn(month: selectMonth, year: selectYear) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pickerView.pickerViews[2].scrollowToRow(days - 1, animated: true)
                }
                selectDay = self.daysIn(month: selectMonth, year: selectYear)
            }
        }
        
        /// 时区的问题
        let date = self.dateFrom(day: selectDay, month: selectMonth, year: selectYear)
        if date?.compare(Date()) != .orderedDescending { /// 不能超出
            self.date = self.dateFrom(day: selectDay, month: selectMonth, year: selectYear)
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
            let time = dateformatter.string(from: self.date!)
            print("time = \(time)")// 当前系统时间
        }
    }

}
