//
//  SnipetView.swift
//  Button_G's
//
//  Created by 中村太一 on 2017/11/18.
//  Copyright © 2017年 中村太一. All rights reserved.
//

import UIKit

class SnipetView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("SnipetView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.gray.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: view.layer.frame.width, height: 1)
        view.layer.addSublayer(borderLayer)
        
        self.addSubview(view)
    }
    func setTitle(title:String){
        self.titleLabel.text = title
    }

}
