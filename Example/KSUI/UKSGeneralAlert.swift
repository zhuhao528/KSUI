//
//  UKSGeneralAlert.swift
//  KSUI
//
//  Created by zhu hao on 2020/10/13.
//

import UIKit
import KSUI
import SnapKit

/// 弹窗
public class UKSGeneralAlert {
    
    /// 通用样式弹窗
    public static func showAlertView(title _: String, desc _: String?, subDesc _: String?,surePressed:@escaping ()->Void) {
        let appearance = UKSAlertView.SCLAppearance(
            kButtonWidth : 100,
            kContentViewBorderWidth : 0,
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .vertical
        )
        let alert = UKSAlertView(appearance: appearance)
        _ = alert.addButton("确定", backgroundImage: UIImage(named: "setting_btn_continue_logout"),backgroundColor: .clear) {
            print("Second button tapped")
            surePressed()
        }
        let icon = UIImage(named: "common_pic_pop_bg_planet")
        let color = UIColor.orange
        
        /// 背景图片
        alert.backgroundView = UIImageView.init(image: icon)
        alert.backgroundView?.frame = CGRect(x: -50, y: -110, width: 350, height: 300)
        
        _ = alert.showCustom("账户异常", subTitle: "您的账户已注销，如有疑问，请联系客服", color: color)
    }
    
    /// 会员弹窗
    public static func showVIPAlertView(title _: String, desc _: String?, subDesc _: String?,surePressed:@escaping ()->Void) {
        let appearance = UKSAlertView.SCLAppearance(
            kButtonWidth : 100,
            kContentViewBorderWidth : 0,
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: false,
            buttonsLayout: .vertical
        )
        let alert = UKSAlertView(appearance: appearance)
        _ = alert.addButton("确定", backgroundImage: UIImage(named: "setting_btn_continue_logout"),backgroundColor: .clear) {
            print("Second button tapped")
            surePressed()
        }
        let icon = UIImage(named: "vip_pic_pop_bg_benefits")
        let color = UIColor.orange
        
        let view = UIView()
        
        let button = UIButton()
//        button.backgroundColor = UIColor(hex: "#C8DEFF")
//        button.cornerRadius = 16.adaptor
        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        button.titleLabel?.font = 20.adaptor_Int.font_bold
        button.setTitle("立即开通", for: .normal)
        view.addSubview(button)
        
        let label = UILabel()
        label.text = "—————— 会员尊享权益 ——————"
        view.addSubview(label)
//        label.snp.makeConstraints {(make) in
//            make.centerX.equalTo(view)
//            make.top.equalTo(view).offset(100)
//        }
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        for i in 0..<3 {
            let imageView = UIImageView()
            view.addSubview(imageView)
//            imageView.snp.makeConstraints { (make) in
//                make.top.equalTo(view.snp_bottom)
//                make.left.equalTo(view).offset(50 + 50*i)
//                make.width.height.equalTo(50)
//            }
            label.frame = CGRect(x: 50+50*i, y: 0, width: 100, height: 100)

            let label = UILabel()
            label.text = "故事畅听"
            view.addSubview(label)
//            label.snp.makeConstraints { (make) in
//                make.top.equalTo(imageView.snp_bottom)
//                make.left.right.equalTo(imageView)
//                make.height.equalTo(20)
//            }
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        }
        
        let adView = UIView()
        adView.backgroundColor = .red
        view.addSubview(adView)
//        adView.snp.makeConstraints { (make) in
//            make.top.equalTo(label.snp_bottom).offset(70)
//            make.left.right.equalTo(view).offset(10)
//            make.height.equalTo(50)
//        }
        adView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        alert.customSubview = view
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        /// 背景图片
        alert.backgroundView = UIImageView.init(image: icon)
        alert.backgroundView?.frame = CGRect(x: -50, y: -110, width: 350, height: 300)
        
        _ = alert.showCustom("", subTitle: "你还不是会员哦\n开通会员畅享专属头像吧", color: color)
    }
    
}

@objc public class UKSGeneralAlertOC: NSObject {
    @objc static func showAlertView(title: String, desc: String?, subDesc: String?,surePressed:@escaping ()->Void) {
        UKSGeneralAlert.showAlertView(title: title, desc: subDesc, subDesc: subDesc, surePressed: surePressed)
    }
}

