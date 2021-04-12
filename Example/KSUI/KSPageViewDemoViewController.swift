//
//  KSPageViewDemoViewController.swift
//  KSBook
//
//  Created by zhu hao on 2020/9/21.
//  Copyright © 2020 kaishu. All rights reserved.
//

import UIKit
import KSUI

//class KSPageViewDemoViewController: UIViewController{
//
//    var titles:[String] = ["凯叔推荐", "最受欢迎", "经典故事"]
//    var pageView =  KSPageTitleImageView()
//    var lineView = KSPageIndicatorBackgroundView()
//    var container : KSPageListContainerView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func configDefaultInit(){
//        container = KSPageListContainerView(type: KSPageListContainerType(rawValue:1)!,delegate: self)
//        pageView.titles = titles
//        pageView.imageSize = .zero
//        pageView.titleFont = 14.font_hyzy_regular
//        pageView.titleSelectedFont = 14.font_hyzy_medium
//        pageView.titleColor = UIColor(hex: "#767C88")
//        pageView.titleSelectedColor = UIColor(hex: "#FFFFFF")
//        pageView.cellBackgroundUnselectedColor = UIColor(hex: "#E7F1FF")
//        pageView.cellBackgroundSelectedColor = .red
//        pageView.isContentScrollViewClickTransitionAnimationEnabled = false
//        /// 禁止滚动
//        container?.scrollView.isScrollEnabled = false
//        var array:[UIView & KSPageIndicatorProtocol] = []
//        lineView.indicatorWidth = 80
//        lineView.indicatorColor = UIColor(hex: "#6AA8FE")
//        lineView.indicatorHeight = 30.adaptor
////      if let lineView = lineView as? (UIView & KSPageIndicatorProtocol) {
//            array.append(lineView)
////      }
//        pageView.indicators = array
//        pageView.delegate = self
//        pageView.listContainer = container
//    }
//
//    override func configSubviews(){
//        view.addSubview(pageView)
//        view.addSubview(container!)
//    }
//
//    override func configLayoutSubviews(){
//        pageView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view).offset(250)
//            make.right.equalTo(self.view).offset(-250)
//            make.top.equalTo(self.view)
//            make.height.equalTo(50.adaptor)
//        }
//
//        container?.snp.makeConstraints({ (make) in
//            make.top.equalTo(pageView.snp.bottom)
//            make.left.right.equalTo(self.view)
//            make.bottom.equalTo(self.view)
//        })
//    }
//
//}
//
///// pageView代理
//extension KSPageViewDemoViewController : KSPageViewDelegate{
//
//}
//
///// 内容区协议
//extension KSPageViewDemoViewController : KSPageListContainerViewDelegate{
//
//    func number(ofListsInlistContainerView listContainerView: KSPageListContainerView) -> Int {
//        return self.titles.count
//
//    }
//
//    func listContainerView(_ listContainerView: KSPageListContainerView, initListFor index: Int) -> KSPageListContentViewDelegate {
//        return KSListViewController()
//    }
//
//}
//
///// 内容控制器
//class KSListViewController:  KSBaseViewController, KSPageListContentViewDelegate {
//    func listView() -> UIView {
//        return self.view
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func configDefaultInit(){
//        self.view.backgroundColor = UIColor(red: CGFloat(arc4random()%256) / 255.0, green: CGFloat(arc4random()%256) / 255.0, blue: CGFloat(arc4random()%256) / 255.0, alpha: 1)
//    }
//
//    override func configSubviews(){
//
//    }
//
//    override func configLayoutSubviews(){
//
//    }
//}
