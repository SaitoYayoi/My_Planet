//
//  SidePanelViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/5/9.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import SnapKit

class SidePanelViewController: UIViewController {

    var naviBar = UINavigationBar()
    var naviItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bg()
        
    }
    
    func bg() {
        let bgImageView = UIImageView.init(image: UIImage(named: "drawerBg")!)
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints {(bg) in
            bg.top.bottom.left.right.equalTo(0)
            bg.center.equalToSuperview()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
