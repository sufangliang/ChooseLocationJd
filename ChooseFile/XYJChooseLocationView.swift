//
//  XYJChooseLocationView.swift
//  YouDu
//
//  Created by sufangliang on 2017/10/16.
//  Copyright © 2017年 XYJ. All rights reserved.
//

import UIKit

  let   kHYTopViewHeight  : CGFloat = 40; //顶部视图的高度
  let   kHYTopTabbarHeight : CGFloat = 40; //地址标签栏的高度
class XYJChooseLocationView: UIView {

    var   topTabbar : XYJAddressView?
    var undeline : UIView?
    var selectedBtn : UIButton?
    var  contentView : UIScrollView?
    fileprivate var backBtn: UIButton?
    fileprivate var callBack: ((Int, String)->())?
    fileprivate var firstDataSource =  [XYJCommonImage]()
    var   secondConponent = XYJCommonService().getCommmonByCache()?.imageEnum
    var   thirdConponent  = [XYJCommonImageItem]()
    var  firstSelectIndex : IndexPath?
    var  secondSelectIndex : IndexPath?
    var tableViews : NSMutableArray = NSMutableArray.init(array: [])
    var topTabbarItems : NSMutableArray =   NSMutableArray.init(array: [])

    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: screenH, width: screenW, height: 300)
        let  firstModel1  =  XYJCommonImage()
        firstModel1.name =  XYJPhotoUploadPickerType.camera.rawValue
        let  firstModel2  =  XYJCommonImage()
        firstModel2.name = XYJPhotoUploadPickerType.photoLibrary.rawValue
        firstDataSource.append(firstModel1)
        firstDataSource.append(firstModel2)
        configePage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(selectCallBack:((Int, String)-> ())?) {
        let window = UIApplication.shared.keyWindow
        let backBtn = UIButton.init(frame: (window?.bounds)!)
        backBtn.backgroundColor = UIColor.init(white: 0, alpha: 0.0)
        backBtn.addTarget(self, action: #selector(XYJChooseLocationView.cancel), for: .touchUpInside)
        window?.addSubview(backBtn)
        self.backBtn = backBtn
        self.frame = CGRect(x: 0, y: screenH, width: screenW, height: self.frame.height)
        self.backBtn?.addSubview(self)
        UIView.animate(withDuration: 0.2, animations: {
            self.backBtn?.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
            self.frame = CGRect(x: 0, y: screenH - self.frame.height, width: screenW, height: self.frame.height)
        })
        self.callBack = selectCallBack
        
    }
    
    func cancel() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backBtn?.backgroundColor = UIColor.clear
            self.frame = CGRect(x: 0, y: screenH, width: screenW, height: self.frame.height)
        }, completion: { isComplete in
            self.removeFromSuperview()
            self.backBtn?.removeFromSuperview()
        })
    }
    
    func configePage() {
        let topView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: kHYTopViewHeight))
        self.addSubview(topView)
        topView.addSubview(titleLabel)
        titleLabel.addSubview(cancelbtn)
        titleLabel.frame = topView.bounds
        titleLabel.isUserInteractionEnabled = true
        cancelbtn.frame = CGRect(x: titleLabel.frame.size.width-32, y: (kHYTopViewHeight-12)/2, width: 12, height: 12)
        topView.backgroundColor = UIColor.white
        
        topTabbar = XYJAddressView.init(frame: CGRect(x: 0, y: topView.xyj_height, width: self.frame.size.width, height: kHYTopViewHeight))
        self.addSubview(topTabbar!)
        self.addTopBarItem()
        let separateLine1 = self.separateLine()
        topTabbar?.addSubview(separateLine1)
        separateLine1.frame =  CGRect(x: 0, y: (topTabbar?.xyj_height)!-1, width:  self.frame.size.width, height: 1)
        topTabbar?.layoutIfNeeded()

        undeline = UIView.init(frame: CGRect(x: 0, y:(topTabbar?.xyj_height)!-1 , width:  40, height: 1))
         topTabbar?.addSubview(undeline!)
        let btn : UIButton = self.topTabbarItems.lastObject as! UIButton
        self.changeUnderLineFrame(btn: btn)
        undeline?.center.x  = btn.center.x
        undeline?.backgroundColor = UIColor.mainColor
         contentView  = UIScrollView.init(frame: CGRect(x: 0, y: (topTabbar?.xyj_maxY)!, width: self.frame.size.width, height: self.xyj_height - kHYTopViewHeight - kHYTopTabbarHeight))
        contentView?.contentSize = CGSize(width: screenW, height: 0)
        self.addSubview(contentView!)
        contentView?.isPagingEnabled = true
        contentView?.backgroundColor = UIColor.white
        self.addTableView()
    }
    
    func addTableView() {
        let tableView: UITableView = UITableView.init(frame: CGRect(x: (CGFloat(self.tableViews.count) * screenW), y: 0, width: screenW, height:  (contentView?.xyj_height)!))
        contentView?.addSubview(tableView)
        self.tableViews.add(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        tableView.register(XYJAddressTableViewCell.self, forCellReuseIdentifier: XYJAddressTableViewCell.cellIdentifi)

    }
        func addTopBarItem() {
        let topBarItem = UIButton()
        topBarItem.setTitle("请选择", for: .normal)
        topBarItem.setTitleColor(UIColor.init(hexString: "3b3b3b"), for: .normal)
            topBarItem.titleLabel?.font = fontFourteen
        topBarItem.sizeToFit()
         topBarItem.xyj_centerY = (topTabbar?.xyj_height)! * 0.5
        self.topTabbarItems.add(topBarItem)
        self.topTabbar?.addSubview(topBarItem)
        topBarItem.addTarget(self, action: #selector(topBarItemClick(btn:)), for: .touchUpInside)
    }
    func changeUnderLineFrame(btn : UIButton) {
        selectedBtn?.isSelected = false
        btn.isSelected = true
        selectedBtn = btn
        self.undeline?.backgroundColor = mainColor
        self.undeline?.mj_size = CGSize(width: btn.frame.size.width, height: 1)
        self.undeline?.center = CGPoint(x: btn.center.x, y: CGFloat((self.topTabbar?.frame.size.height)! - 1))

    }
    
    func separateLine() -> UIView {
        let separateLine = UIView.init(frame: CGRect(x: 0, y: 0, width:  self.frame.size.width, height: 1))
            separateLine.backgroundColor = separatorLineColor
        return separateLine

    }
    
    lazy var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = mainBackColor
        return view
    }()
    lazy var cancelbtn: UIButton = {
        let btn  = UIButton.buttonWith(img: "bomb_box_off")
        btn.addTarget(self, action: #selector(XYJChooseLocationView.cancel), for: .touchUpInside)
        return btn
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(text: "添加影像", textColor: UIColor.colorHexString(colorHexString: "8e8e8e"), font: .systemFont(ofSize: 14))
        label.textAlignment = .center
        label.font = fontFifteen
        return label
    }()
 
    func topBarItemClick(btn : UIButton) {
      let index  =  self.topTabbarItems.index(of : btn)
        UIView.animate(withDuration: 0.5) {
            self.contentView?.contentOffset = CGPoint(x:CGFloat(index) * screenW, y: 0)
            self.changeUnderLineFrame(btn: btn)
            
        }
    }
}

extension XYJChooseLocationView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableViews.index(of: tableView)
        if(self.tableViews.index(of: tableView) == 0 ) {
            return 2
        } else if (self.tableViews.index(of: tableView) == 1 ) {
            return secondConponent!.count
        } else if (self.tableViews.index(of: tableView) == 2) {
            return thirdConponent.count
        }
        return 2
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XYJAddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: XYJAddressTableViewCell.cellIdentifi) as? XYJAddressTableViewCell ?? XYJAddressTableViewCell.init(style: .default, reuseIdentifier: XYJAddressTableViewCell.cellIdentifi)
        cell.selectionStyle = .none
        if(self.tableViews.index(of: tableView) == 0 ) {
            cell.commonImage =  (firstDataSource[indexPath.row])
    } else if (self.tableViews.index(of: tableView) == 1 ) {
            cell.commonImage =  (secondConponent?[indexPath.row])!
        } else if (self.tableViews.index(of: tableView) == 2) {
           cell.nameStr  =  thirdConponent[indexPath.row].name
        }
             return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if(self.tableViews.index(of: tableView) == 0) {
            secondConponent = nil
            secondConponent = XYJCommonService().getCommmonByCache()?.imageEnum
            let provinceName : String = self.firstDataSource[indexPath.row].name
            //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
            let  indexPath0 = tableView.indexPathForSelectedRow
            if (indexPath0 != nil) && indexPath0!.compare(indexPath).rawValue != ComparisonResult.orderedSame.rawValue {
                    for i in 0..<self.tableViews.count {
                        if self.tableViews.count != 1 {
                        self.removeLastItem()
                        }
                }
                self.addTopBarItem()
                self.addTableView()
                self.scrollToNextItem(preTitle: provinceName)
                 return  indexPath
            } else if (indexPath0 != nil) && indexPath0!.compare(indexPath).rawValue == ComparisonResult.orderedSame.rawValue {
                    for i in 0..<self.tableViews.count {
                        if self.tableViews.count != 1 {
                        self.removeLastItem()
                        }
                    }
                self.addTopBarItem()
                self.addTableView()
                self.scrollToNextItem(preTitle: provinceName)
                return indexPath
            }
            //之前未选中省，第一次选择省
            self.addTopBarItem()
            self.addTableView()
            self.scrollToNextItem(preTitle: provinceName)
            
        } else   if(self.tableViews.index(of: tableView) == 1) {
            let itemValue = secondConponent?[indexPath.row]
            thirdConponent  = (itemValue?.items)!
            let  indexPath0 = tableView.indexPathForSelectedRow
            if (indexPath0 != nil) && indexPath0!.compare(indexPath).rawValue != ComparisonResult.orderedSame.rawValue {
                    for _ in 0..<(self.tableViews.count - 1) {
                        if self.tableViews.count > 2 {
                            self.removeLastItem()
                        }
                }
                self.addTopBarItem()
                self.addTableView()
                self.scrollToNextItem(preTitle: (itemValue?.name)!)
                return indexPath
            }
            else if (indexPath0 != nil) && indexPath0!.compare(indexPath).rawValue == ComparisonResult.orderedSame.rawValue {
                self.scrollToNextItem(preTitle: (itemValue?.name)!)
                return indexPath
            }
            
            self.addTopBarItem()
            self.addTableView()
            let itemValu = secondConponent?[indexPath.row]
            self.scrollToNextItem(preTitle: (itemValu?.name)!)
        } else  if(self.tableViews.index(of: tableView) == 2) {
            let item = self.thirdConponent[indexPath.row]
            self.setUpAddress(address: item.name!)
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.tableViews.index(of: tableView) == 0 ) {
            firstSelectIndex = indexPath
            let  commonImage =  (firstDataSource[indexPath.row])
            commonImage.selectItem = true
            secondSelectIndex = indexPath
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else if (self.tableViews.index(of: tableView) == 1 ) {
            let  commonImage =  (secondConponent?[indexPath.row])!
            commonImage.selectItem = true
            secondSelectIndex = indexPath
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)

        } else if (self.tableViews.index(of: tableView) == 2) {
            UIView.animate(withDuration: 0.15, animations: {
                self.backBtn?.backgroundColor = UIColor.clear
                self.frame = CGRect(x: 0, y: screenH, width: screenW, height: self.frame.height)
            }, completion: { isComplete in
                self.removeFromSuperview()
                self.backBtn?.removeFromSuperview()
            })

            let firstSelect = firstDataSource[(firstSelectIndex?.row)!]
            var codeStr = ""
            let  model = secondConponent?[(secondSelectIndex?.row)!]
            codeStr = model?.code ?? ""
            if  thirdConponent.count > 0 {
                let mo  = thirdConponent[indexPath.row]
                codeStr = mo.code ?? ""
            }
            let value = ( firstSelect.name  == XYJPhotoUploadPickerType.camera.rawValue) ? 1 : 0
            self.callBack!(value, codeStr)

        }
    }
    
func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        if(self.tableViews.index(of: tableView) == 0 ) {
            let  commonImage =  (firstDataSource[indexPath.row])
            commonImage.selectItem = false
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if (self.tableViews.index(of: tableView) == 1 ) {
            let  commonImage =  (secondConponent?[indexPath.row])!
            commonImage.selectItem = false
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if (self.tableViews.index(of: tableView) == 2) {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
      
    }
    
    func removeLastItem() {
        let tab : UITableView =  self.tableViews.lastObject as! UITableView
        let   btn : UIButton =  self.topTabbarItems.lastObject as! UIButton
        tab.removeFromSuperview()
        btn.removeFromSuperview()
        self.tableViews.removeLastObject()
        self.topTabbarItems.removeLastObject()
    }
    
    func scrollToNextItem(preTitle : String ) {
        let index = (self.contentView?.contentOffset.x)! / screenW
        let btn : UIButton  = self.topTabbarItems[Int(index)] as! UIButton
        btn.setTitle(preTitle, for: .normal)
        btn.sizeToFit()
        topTabbar?.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.contentView?.contentSize = CGSize(width:  CGFloat(self.tableViews.count) * screenW, height: 0)
            let offset : CGPoint = (self.contentView?.contentOffset)!
            self.contentView?.contentOffset = CGPoint(x: offset.x + screenW, y: offset.y)
            self.changeUnderLineFrame(btn: self.topTabbar?.subviews.last as! UIButton)
        }
}
    
    //完成地址选择,执行chooseFinish代码块
    func setUpAddress(address : String) {
        let index = (self.contentView?.contentOffset.x)! / screenW
        let btn  : UIButton   = self.topTabbarItems[Int(index)] as! UIButton
        btn.sizeToFit()
        topTabbar?.layoutIfNeeded()
    }
}
