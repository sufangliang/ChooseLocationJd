//
//  XYJAddressView.swift
//  YouDu
//
//  Created by sufangliang on 2017/10/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//

import UIKit
import XYJBaseUI

  let  HYBarItemMargin  : CGFloat = 16
    let  HYBarItemWidth  : CGFloat = 100

class XYJAddressView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.white
        let mArrar = NSMutableArray.init(array: [])
        for subview in self.subviews {
            if(subview.isKind(of: UIButton.self) ) {
                mArrar.add(subview)
            }
        }
        for i in 0..<mArrar.count {
            let view : UIView = mArrar[i] as! UIView
            if (i == 0) {
                view.frame.origin.x = HYBarItemMargin
                // view.frame = CGRect(x: HYBarItemMargin, y: 0, width: HYBarItemWidth, height: kHYTopTabbarHeight-1)   //固定模式  按钮不能动态变宽
                XYJLog(message: "viewframe: \(view)")
            }
            if (i > 0) {
                let preView : UIView = mArrar[i - 1] as! UIView
                view.frame.origin.x = HYBarItemMargin + preView.frame.origin.x + preView.frame.size.width
                // view.frame = CGRect(x: HYBarItemMargin + (HYBarItemWidth + 5) * CGFloat( i) , y: 0, width: HYBarItemWidth, height: kHYTopTabbarHeight-1)
                XYJLog(message: "viewframe: \(view)")
            }
        }
    }
}
