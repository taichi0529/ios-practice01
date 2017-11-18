//
//  ViewController.swift
//  Button_G's
//
//  Created by 中村太一 on 2017/09/02.
//  Copyright © 2017年 中村太一. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: UIView!

    
    /// 構造体
    struct CurrentSnipet {
        var animator: UIViewPropertyAnimator
        var view: SnipetView
        var status: SnipetStatus
        var title: String
    }
    
    /// snipetViewのステータス
    ///
    /// - shown: <#shown description#>
    /// - hidden: <#hidden description#>
    /// - running: <#running description#>
    enum SnipetStatus {
        case shown,hidden,running
    }
    
    var currentSnipet: CurrentSnipet? = nil
    
    @IBAction func didTouchStartButton(_ sender: Any) {
        self.toggleSnipet(title: "A")
    }
    @IBAction func didTouchPauseButton(_ sender: Any) {
        self.toggleSnipet(title: "B")
    }
    @IBAction func didTouchStopButton(_ sender: Any) {
        self.toggleSnipet(title: "C")
    }
    
    /// snipetのViewを切り替える
    ///
    /// - Parameter title: snipetViewに表示するタイトル
    func toggleSnipet (title: String) {
        if self.currentSnipet == nil {
                self.showSnipet(title: title)
        } else {
            if self.currentSnipet?.title == title {
                self.hideSnipet(completion: nil)
            } else {
                self.hideSnipet(completion:{
                    self.showSnipet(title: title)
                })
            }
        }
    }
    
    func createPropertyAnimator () -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(
            duration: 0.1,
            timingParameters: UICubicTimingParameters(animationCurve: .linear)
        )
    }
    
//    func createSnipetView(title:) -> UIView {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.frame = CGRect(x:0,y:self.mapView.frame.height,width:self.view.bounds.width,height:100)
//        border-top: 1px solid gray
//        let borderLayer = CALayer()
//        borderLayer.backgroundColor = UIColor.gray.cgColor
//        borderLayer.frame = CGRect(x: 0, y: 0, width: view.layer.frame.width, height: 1)
//
//        let label = UILabel()
//        label.text = title
//        label.frame = CGRect(x:10,y:10,width:100,height:20)
//        view.addSubview(label)
//        view.layer.addSublayer(borderLayer)
//        return view
//    }
    
    func showSnipet(title: String) {
        if self.currentSnipet == nil || self.currentSnipet?.status == .hidden {
            let snipetView = SnipetView(frame: CGRect(x:0,y:self.mapView.frame.height,width:self.view.bounds.width,height:100))
            snipetView.setTitle(title: title)
            self.currentSnipet = CurrentSnipet(
                animator: self.createPropertyAnimator(),
                view: snipetView,
                status: .hidden,
                title: title
            )
            self.view.addSubview((self.currentSnipet?.view)!)
            self.currentSnipet?.animator.addAnimations{[weak self] in
                self?.currentSnipet?.view.center.y -= 100.0
            }
            self.currentSnipet?.animator.addCompletion{(position: UIViewAnimatingPosition) in
                self.currentSnipet?.status = .shown
            }
            self.currentSnipet?.status = .running
            self.currentSnipet?.animator.startAnimation()
            
        }
    }
    
    /// snipetを隠す
    ///
    /// - Parameter completion: 隠し終わった後に起動したい関数
    func hideSnipet(completion: (() -> Void)?){
        if self.currentSnipet == nil || self.currentSnipet?.status == .shown {
            self.currentSnipet?.animator.addAnimations{[weak self] in
                self?.currentSnipet?.view.center.y += 100.0
            }
            self.currentSnipet?.animator.addCompletion{[weak self] (position: UIViewAnimatingPosition) in
                self?.currentSnipet?.view.removeFromSuperview()
                self?.currentSnipet?.status = .hidden
                self?.currentSnipet = nil
                completion?()
            }
            self.currentSnipet?.status = .running
            self.currentSnipet?.animator.startAnimation()
        }
    }
}

