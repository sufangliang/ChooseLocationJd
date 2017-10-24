//
//  XYJAddressTableViewCell.swift
//  YouDu
//
//  Created by sufangliang on 2017/10/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//

import UIKit

class XYJAddressTableViewCell: UITableViewCell {
    static let cellIdentifi = "XYJAddressTableViewCell"
    var  isselect : Bool = false {
        didSet {
            nameLabel.textColor = isselect ? mainColor  : UIColor.colorHexString(colorHexString: "3b3b3b")
            rightArrowIconV.isHidden = !isselect
        }
    }
    
    var  commonImage : XYJCommonImage? {
        didSet {
            nameLabel.textColor = (commonImage?.selectItem)! ? mainColor  : UIColor.colorHexString(colorHexString: "3b3b3b")
            rightArrowIconV.isHidden = !(commonImage?.selectItem)!
            nameLabel.text = commonImage?.name
        }
    }

    
    
    var nameStr: String? {
        didSet {
        nameLabel.text = nameStr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configePage()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configePage() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(rightArrowIconV)
    }
    
    func layout() {
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(self.snp.left).offset(15)
        }
        rightArrowIconV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(nameLabel.snp.right).offset(8)
            make.width.height.equalTo(15)
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.labelWith(text: "从相册选择", font: UIFont.systemFont(ofSize: 14), color: UIColor.colorHexString(colorHexString: "3b3b3b"))
        label.textAlignment = .right
        return label
    }()
    
    lazy var rightArrowIconV: UIImageView = {
        let view = UIImageView.init()
        view.isHidden = true
        view.image = UIImage.init(named: "images_selected_ico")
        view.isUserInteractionEnabled = true
        return view
    }()
    
//    lazy var bottomLineV: UIView = {
//        let view = UIView.init()
//        view.backgroundColor = mainBackColor
//        return view
//    }()
}
