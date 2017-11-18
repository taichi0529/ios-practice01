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
    
    /// 表示中snipetView用の構造体
    struct CurrentSnipet {
        var animator: UIViewPropertyAnimator
        var view: SnipetView
        var status: SnipetStatus
        var title: String
    }
    
    /// snipetViewのステータス
    ///
    /// - shown: 表示中
    /// - hidden: 非表示中。ただし消した後nilっちゃうのであまり意味の無いステータス
    /// - running: アニメーション中
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
        
        //guard使いたいだけですｗ
        //http://programming-beginner-memo.com/?p=398
        guard let currentSnipet = self.currentSnipet else {
            self.showSnipet(title: title)
            return
        }
        
        if currentSnipet.title == title {
            self.hideSnipet(completion: nil)
        } else {
            self.hideSnipet(completion:{
                self.showSnipet(title: title)
            })
        }
        
    }
    
    /// アニメーションを制御するUIViewPropertyAnimatorのインスタンスを作る
    /// https://qiita.com/KEN-chan/items/f80c17c583ac44d67a58
    ///
    /// - Returns:
    func createPropertyAnimator () -> UIViewPropertyAnimator{
        return UIViewPropertyAnimator(
            duration: 0.1,//アニメーションの全長が0.1秒
            timingParameters: UICubicTimingParameters(animationCurve: .linear)//等速度運動
        )
    }
    
    /// snipetViewを作る。xibファイルを使わない場合はこれを使う。今回はこの関数は作ったけど使っていない。
    /// AutoLayoutとか面倒なのでxibファイルの方がいい気がする・・・・
    ///
    /// - Parameter title: 表示する文字列。これで同じsnipetかどうか判断している。
    /// - Returns: snipet用のView
    func createSnipetView(title:String) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        // ↓Viewのサイズを設定
        view.frame = CGRect(x:0,y:self.mapView.frame.height,width:self.view.bounds.width,height:100)
        
        //border-top: 1px solid gray 枠線全てを書くのはstoryboard上で出来るけどTopだけとか結構面倒くさい
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.gray.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: view.layer.frame.width, height: 1)
        view.layer.addSublayer(borderLayer)
        
        //ラベルを配置している。xib使えばいらないけど、コードの方が便利なこともありそう
        let label = UILabel()
        label.text = title
        label.frame = CGRect(x:10,y:10,width:100,height:20)
        view.addSubview(label)
        
        return view
    }
    
    /// snipetViewを下からニュッと表示
    ///
    /// - Parameter title: 表示する文字
    func showSnipet(title: String) {
        if self.currentSnipet == nil || self.currentSnipet?.status == .hidden {
            //let snipetView = self.createSnipetView(title: title)
            //xibをつかったUIViewを継承したクラスを作ってある
            //SnipetView.xibで左側のFile's ownerを開いて一番右の設定でCustom classをSnipetViewにする。（SnipetViewはあらかじめ作っておく）
            let snipetView = SnipetView(frame: CGRect(x:0,y:self.mapView.frame.height,width:self.view.bounds.width,height:100))
            snipetView.setTitle(title: title)
            
            // 構造体
            self.currentSnipet = CurrentSnipet(
                animator: self.createPropertyAnimator(),
                view: snipetView,
                status: .hidden,
                title: title
            )
            self.view.addSubview((self.currentSnipet?.view)!)
            
            //weak selfは要らないかも知れないけど念のため
            //snipetViewを0.1秒間で（UIViewPropertyAnimatorのduration）100ピクセル上に動かす
            self.currentSnipet?.animator.addAnimations{[weak self] in
                self?.currentSnipet?.view.center.y -= 100.0
            }
            
            //アニメーションが終わったら呼び出す
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
            
            //隠すアニメーション
            self.currentSnipet?.animator.addAnimations{[weak self] in
                self?.currentSnipet?.view.center.y += 100.0
            }
            
            //終わったら引数に設定してあるコールバック関数を呼び出している
            //addCompletionで設定した関数を呼び出している時点ではanimator.isRunningがtrueになってしまう。つまりまだアニメーションが終わっていない扱い。
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

