//
//  MainViewControllerDelegate.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/5/9.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit

//单独一个文件写代理，增加扩展性
@objc
protocol MainViewControllerDelegate {
  @objc optional func toggleLeftPanel()
  @objc optional func toggleRightPanel()
  @objc optional func collapseSidePanels()
}
