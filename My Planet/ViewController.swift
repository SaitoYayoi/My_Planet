//
//  ViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/5/8.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftyJSON

class ViewController: UIViewController, MainViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
  //当前滑出框的状态
  enum SlideOutState {
    case bothCollapsed
    case leftPanelExpanded
    case changing
  }
  //中心视图和其导航（在didload里面赋值）
  var centerNaviController: UINavigationController!
  var centerVC: MainViewController!
  
  //当前状态，并做观察者以便处理阴影效果
  var currentState: SlideOutState = .bothCollapsed
  //左边栏
  var leftViewController: SidePanelViewController?
  
  let centerPanelExpandedOffset: CGFloat = 35//在展开边栏后中心视图还剩多少可见
    
    let identifier = "NibTableViewCell"
    @IBOutlet weak var drawerNavigationBar: UINavigationBar!
    var tableView : UITableView?
    
    var dataArray:Array<TableCellContent>?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        firstLaunchOrNot()
        
        let content1 = TableCellContent()
        content1.image = "drawerIcon"
        let path = NSHomeDirectory() + "/Documents/date.plist"
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: path)!
        let dataDic = data as Dictionary
        var date = "一个神秘日期"
        for (_, value) in dataDic {
            date = value as! String
        }
        print(date)
        
        
        content1.title = "你的星球诞生于\(date)"
        
        tableView = UITableView(frame:CGRect(x: 0, y: drawerNavigationBar.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-drawerNavigationBar.bounds.height), style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .clear
        tableView?.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCellId")
        
        self.view.addSubview(tableView!)
        
        dataArray = [content1]
        
    
    centerVC = UIStoryboard.MainViewController() //获取到center控制器实例
    centerVC.delegate = self
    
    //实力化一个导航控制器-->把center控制器放入导航控制器中，以便往center控制器里面push边栏以及展示导航按钮
    centerNaviController = UINavigationController(rootViewController: centerVC)
    centerNaviController.navigationBar.isHidden = true
    
    //为本容器控制器加上视图及导航控制器
    view.addSubview(centerNaviController.view)
    self.addChild(centerNaviController)
    centerNaviController.didMove(toParent: self)//加了子控制器之后必须这一步
    
        
    //手势--实例化一个手指平移,交由handlePan函数处理（在下方的extension中）
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:)))
    centerNaviController.view.addGestureRecognizer(pan)

  }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId", for: indexPath) as! TableViewCell
        let model = dataArray![indexPath.row]
        cell.imageName.image = UIImage(named: model.image!)
        cell.title.text = model.title
        cell.title.textColor = .white
        cell.title.numberOfLines = 0
        cell.title.lineBreakMode = .byWordWrapping
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }

    
    func firstLaunchOrNot() {
        let EVERLAUNCHED = "everLaunched"
        let FIRSTLAUNCH = "firstLaunch"
        
        if(!UserDefaults.standard.bool(forKey: EVERLAUNCHED)){
            UserDefaults.standard.set(true, forKey: EVERLAUNCHED)
            UserDefaults.standard.set(true, forKey: FIRSTLAUNCH)
            UserDefaults.standard.synchronize()
        }
        else {
            UserDefaults.standard.set(false, forKey: FIRSTLAUNCH)
            UserDefaults.standard.synchronize()
        }
        var isLaunched = false
        if(!UserDefaults.standard.bool(forKey: FIRSTLAUNCH)) {
            isLaunched = true
        }
        if isLaunched == false {
            let date = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy年MM月dd日"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setObject(strNowTime, forKey: "date" as NSCopying)
            
            let filePath = NSHomeDirectory() + "/Documents/date.plist"
            dic.write(toFile: filePath, atomically: true)
        }
    }
    

}

//实现代理里面的方法，以便委托者在自己的controller里面直接调用
//里面有些方法并不是协议规定的
extension ViewController {
  
  //弹出左边框
  func toggleLeftPanel() {
    let isCollapse = (currentState != .leftPanelExpanded)
    //如果左边没展开，则添加左边控制器
    if isCollapse {
      addLeftPanelViewController()
    }
    //无论有没有展开，都需要弹出或弹进动画
    animateLeftPanel(shouldExpand: isCollapse)
    
  }

  
  
  //上面两个函数要到的共有方法
  func addLeftPanelViewController() {
    //如果左控制器已有值，则返回。没值则继续
    guard leftViewController == nil else { return }
    //获取到左边控制器实例，并获取数据--并调用下一个函数
    if let vc = UIStoryboard.leftViewController() {
      addChildSidePanelController(sidePanelController:vc)
      leftViewController = vc
    }
  }

  //上面两个函数中用到的共有方法---此方法和上面didload中增加导航视图及控制器相似
  func addChildSidePanelController(sidePanelController:UIViewController){
    view.insertSubview(sidePanelController.view, at: 0)//0代理子视图是位于center视图的下方
    self.addChild(sidePanelController)
    sidePanelController.didMove(toParent: self)
  }
  
  
  
  //动画部分--两个toggle函数要到的共有方法
  func animateLeftPanel(shouldExpand: Bool) {
    if shouldExpand{
      currentState = .leftPanelExpanded
      //展示x轴拉伸至什么位置
      animateX(targetPosition: centerNaviController.view.frame.width - centerPanelExpandedOffset)
    }else{
      animateX(targetPosition: 0){ finished in
        //做一些移除处理
        self.currentState = .bothCollapsed
        self.leftViewController?.view.removeFromSuperview()
        self.leftViewController = nil
      }
    }
  }

  //上面两个函数中用到的共有方法
  func animateX(targetPosition: CGFloat,completion: ((Bool)->Void)? = nil){

    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut, animations: {
                    self.centerNaviController.view.frame.origin.x = targetPosition
    }, completion: completion)
    
  }
}

extension ViewController:UIGestureRecognizerDelegate{
  @objc func handlePan(pan:UIPanGestureRecognizer){
    
    //平移的三种状态要分别处理
    switch pan.state {
      
    case .began:
      if currentState == .bothCollapsed {
        addLeftPanelViewController()
      }
      
    case .changed:
        if pan.velocity(in: view).x > 0 {
            if let rview = pan.view {
                rview.center.x = rview.center.x + pan.translation(in: view).x
                pan.setTranslation(CGPoint.zero, in: view)
                currentState = .changing
            }
        }
        else if pan.velocity(in: view).x < 0 && currentState == .changing || currentState == .leftPanelExpanded {
            if let rview = pan.view {
                rview.center.x = rview.center.x + pan.translation(in: view).x
                pan.setTranslation(CGPoint.zero, in: view)
                currentState = .changing
            }
        }
        
    case .ended:
      if let _ = leftViewController,
        let rview = pan.view {
            //看边栏平移是否超过一半来决定-->手指松开之后是收起边栏还是展开边栏
            let hasHalfway = rview.center.x > view.bounds.size.width
            animateLeftPanel(shouldExpand: hasHalfway)
      }
      
    default:
      break
    }
  }
}

private extension UIStoryboard {
  
  static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
  
  static func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
    }
  
  static func MainViewController() -> MainViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
  }
}
