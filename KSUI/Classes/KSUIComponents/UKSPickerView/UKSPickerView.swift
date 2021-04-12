//
//  UKSPickerView.swift
//  KSUI
//
//  Created by zhu hao on 2020/9/27.
//

import UIKit
import SnapKit

// MARK: - Protocols

public protocol UKSPickerViewDataSource : NSObjectProtocol {
    
    func uksNumberOfComponents(in pickerView: UKSPickerView) -> Int
    
    func uksPickerView(_ pickerView: UKSPickerView, numberOfRowsInComponent component: Int) -> Int
}

@objc public protocol UKSPickerViewDelegate : NSObjectProtocol {
    
    @objc optional func uksPickerView(_ pickerView: UKSPickerView, widthForComponent component: Int) -> CGFloat
    
    @objc optional func uksPickerView(_ pickerView: UKSPickerView, rowHeightForComponent component: Int) -> CGFloat
    
    @objc optional func uksPickerView(_ pickerView: UKSPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    
    @objc optional func uksPickerView(_ pickerView: UKSPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    
    @objc optional func uksPickerView(_ pickerView: UKSPickerView, didSelectRow row: Int, inComponent component: Int)
}

open class UKSPickerView: UIView {
    
    /// 内容区cell
    fileprivate class UKSPickerCollectionViewCell: UICollectionViewCell {
        
        public var pickerView: PickerView = {
            let pickerView = PickerView()
            return pickerView
        }()
        
        override func layoutSubviews() {
            superview?.layoutSubviews()
            self.pickerView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        var customView: UIView?
    }
    
    fileprivate var pickerCellBackgroundColor: UIColor?
    
    // MARK: 属性 (将协议转换成属性变量)
    var numberOfComponentsByDataSource: Int {
        get {
            return dataSource?.uksNumberOfComponents(in: self) ?? 1
        }
    }
    
    var numberOfRowsByDataSource: Int {
        get {
            return dataSource?.uksPickerView(self,numberOfRowsInComponent: self.numberOfComponentsByDataSource) ?? 0
        }
    }
    
    override open var backgroundColor: UIColor? {
        didSet {
            self.pickerCellBackgroundColor = self.backgroundColor
        }
    }
    
    public var pickerViews:[PickerView] = []
    
    public var pickerSpace = 0.0
    
    fileprivate let pickerViewCellIdentifier = "UKSPickerViewCell"
    
    open weak var dataSource: UKSPickerViewDataSource?
    open weak var delegate: UKSPickerViewDelegate?
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    open var selectionStyle = PickerView.UKSSelectionStyle(rawValue: 0)!
    
    // MARK: 初始化
    override init(frame: CGRect) {
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
        collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
}

// MARK: - Layout
extension UKSPickerView {
    
    func configDefaultInit() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .white
        self.collectionView.register(UKSPickerCollectionViewCell.self, forCellWithReuseIdentifier: pickerViewCellIdentifier)
    }
    
    func configSubviews() {
        addSubview(self.collectionView)
    }
    
    func configLayoutSubviews() {
        
    }
    
}

/// public
extension UKSPickerView{
    
    open func reloadPickerView() {
        for pickerView in pickerViews {
            pickerView.reloadPickerView()
        }
    }
    
}

/// private
extension UKSPickerView{
    
    fileprivate func findIndexOfSectionOfPickerView(pickerView:PickerView) -> NSInteger{
        for i in 0...self.numberOfComponentsByDataSource {
            let cell = self.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? UKSPickerCollectionViewCell
            if cell?.pickerView == pickerView {
                return i
            }
        }
        return 0
    }
    
    /** 部分圆角
     * - corners: 需要实现为圆角的角，可传入多个
     * - radii: 圆角半径
     */
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}

// MARK: UICollectionViewProtocol
extension UKSPickerView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfComponentsByDataSource
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pickerViewCellIdentifier, for: indexPath) as? UKSPickerCollectionViewCell else { return UICollectionViewCell() }
        cell.pickerView.delegate = self
        cell.pickerView.dataSource = self
        cell.pickerView.backgroundColor = pickerCellBackgroundColor ?? .white
        cell.pickerView.selectionStyle = self.selectionStyle
        cell.backgroundColor = pickerCellBackgroundColor ?? .white
        if indexPath.item == 0 {
            let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                            width: self.collectionView.bounds.size.width/3,
                                                            height: 50),
                                        byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.topLeft],
                                        cornerRadii: CGSize(width: 8, height: 8))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.pickerView.selectionOverlay.layer.mask = maskLayer
        }else if indexPath.item == 2 {
            let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                            width: self.collectionView.bounds.size.width/3,
                                                            height: 50),
                                        byRoundingCorners: [UIRectCorner.bottomRight,UIRectCorner.topRight],
                                        cornerRadii: CGSize(width: 8, height: 8))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.pickerView.selectionOverlay.layer.mask = maskLayer
        }
        cell.contentView.addSubview(cell.pickerView)
        pickerViews.append(cell.pickerView)
        return cell
    }
    
}

extension UKSPickerView: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// 这里的size有点-50有点奇怪
        return CGSize(width: self.collectionView.bounds.size.width/3, height: self.bounds.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return .zero
    //    }
    //
    //    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        return .zero
    //    }
    
}

// MARK: PickerViewProtocol
extension UKSPickerView: PickerViewDataSource{
    
    public func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        let index = self.findIndexOfSectionOfPickerView(pickerView: pickerView)
        return dataSource?.uksPickerView(self, numberOfRowsInComponent: index) ?? 0
    }
    
    public func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        let index = self.findIndexOfSectionOfPickerView(pickerView: pickerView)
        return delegate?.uksPickerView?(self, titleForRow: row, forComponent: index) ?? ""
    }
    
}

extension UKSPickerView: PickerViewDelegate{
    
    public func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat{
        let index = self.findIndexOfSectionOfPickerView(pickerView: pickerView)
        return delegate?.uksPickerView?(self, rowHeightForComponent: index) ?? 50
    }
    
    public func pickerView(_ pickerView: PickerView, didSelectRow row: Int){
        let index = self.findIndexOfSectionOfPickerView(pickerView: pickerView)
        delegate?.uksPickerView?(self, didSelectRow: row, inComponent: index)
    }
    
    public func pickerView(_ pickerView: PickerView, didTapRow row: Int){
        
    }
    
    public func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool){
        
        label.textAlignment = .center
        if #available(iOS 8.2, *) {
            if (highlighted) {
                //              label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
                label.font = UIFont(name: "HYZhengYuan-GEW", size: 15)
            } else {
                //              label.font = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)
                label.font = UIFont(name: "HYZhengYuan-GEW", size: 12)
            }
        } else {
            if (highlighted) {
                //              label.font = UIFont(name: "HelveticaNeue-Light", size: 13.0)
                label.font = UIFont(name: "HYZhengYuan-GEW", size: 15)
                
            } else {
                //              label.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
                label.font = UIFont(name: "HYZhengYuan-GEW", size: 12)
            }
        }
        
        if (highlighted) {
            //          label.textColor = self.tintColor
            label.textColor = UIColor(red: 63/255, green: 76/255, blue: 83/255, alpha: 1)
            
        } else {
            label.textColor = UIColor(red: 140/255, green: 142/255, blue: 152/255, alpha: 1)
        }
        
    }
    
    public func pickerView(_ pickerView: PickerView, viewForRow row: Int, highlighted: Bool, reusingView view: UIView?) -> UIView?{
        let index = self.findIndexOfSectionOfPickerView(pickerView: pickerView)
        return delegate?.uksPickerView?(self, viewForRow: row, forComponent: index, reusing: view)
    }
    
}


