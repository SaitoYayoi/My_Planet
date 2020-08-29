//
//  NetworkErrorFateViewController.swift
//  My Planet
//
//  Created by SaitoYayoi on 2020/4/15.
//  Copyright © 2020 KanoYuta. All rights reserved.
//

import UIKit
import SnapKit


class NetworkErrorFateViewController: UIViewController {
    
    var timer:Timer!
    let text = "似乎有人干扰你和星球的连接\n检查一下网络连接吧"
    var a = 1
    let TextLabel = UILabel()
    
    @objc func TextPrint(_ timer:Timer) {
        TextLabel.backgroundColor = UIColor.clear
        self.view.addSubview(TextLabel)
        TextLabel.textColor = UIColor.white
        TextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        TextLabel.numberOfLines = 0
        TextLabel.snp.makeConstraints {(TextLabel) in
            TextLabel.center.equalToSuperview()
        }
            if a <= text.count{
            let output = text.prefix(a)
            let paraph = NSMutableParagraphStyle()
            paraph.lineSpacing = 10
            let attributes = [NSAttributedString.Key.font: UIFont(name: "Zpix", size: 22),
                              NSAttributedString.Key.paragraphStyle: paraph]
            TextLabel.attributedText = NSAttributedString(string: String(output), attributes: attributes)
            a+=1
        }
        else {
            timer.invalidate()
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(NetworkErrorFateViewController.TextPrint(_:)), userInfo: nil, repeats: true)
        
        var background = [UIImage]()
                      for i in 1 ... 4 {
                          background.append(UIImage(named: "bg\(i)")!)
                      }
        let imageView = UIImageView()
        imageView.animationImages = background
        imageView.animationDuration = 5
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        self.view.addSubview(imageView)
            imageView.snp.makeConstraints {(bg) in
            bg.top.bottom.left.right.equalTo(0)
            bg.center.equalToSuperview()
        }
        // Do any additional setup after loading the view.
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
