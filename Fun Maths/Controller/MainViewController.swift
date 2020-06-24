//
//  ViewController.swift
//  Fun Maths
//
//  Created by Jinisha Savani on 10/12/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {
    
    //Pre-linked IBOutlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var randomNumber: UILabel!
    @IBOutlet weak var answerTxtField: UITextField! {
        didSet {
            answerTxtField.addDoneToolBar()
        }
    }
    
    var inputTxt = ""
    var number = ""
    var currentScore = 0
    var hud : MBProgressHUD?
    var timer : Timer?
    var seconds : Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD(view: self.view)
        if hud != nil {
            self.view.addSubview(hud!)
        }
        
        answerTxtField.delegate = self
        scoreLabel.text = String(currentScore)
        randomNumberLabel()
        textFieldDidChange()
    }
    
    
    /*MARK:- Timer Methods*/
    func startTimer() {
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(onUpdateTimer),userInfo:nil, repeats: true)
        }
    }
    
    @objc func onUpdateTimer(){
        
        if seconds > 0 &&  seconds <= 60 {
            seconds -= 1
            updateTimeLabel()
        } else if seconds == 0 {
            if timer != nil {
                timer?.invalidate()
                timer = nil
                
                let alert = UIAlertController(title: "Oops! Time Up!!", message: "Your score is \(currentScore)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Restart", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                currentScore = 0
                seconds = 60
                scoreLabel.text = "0"
                updateTimeLabel()
                randomNumberLabel()
            }
        }
    }
    
    func updateTimeLabel(){
        
        let min = (seconds/60) % 60
        let sec = seconds % 60
        let min_p = String(format: "%02d", min)
        let sec_P = String(format: "%02d", sec)
        
        timeLabel.text = "\(min_p):\(sec_P)"
    }
    
    /*MARK: Other methods*/
    func checkAnswer() {
        
        if let numbersText = Int(randomNumber.text!), let input = Int(inputTxt) {
            if (input - numbersText == 1111){
                currentScore += 1
                showHUD(isRight: true)
            } else if (input - numbersText != 1111){
                currentScore = currentScore + 0
                showHUD(isRight: false)
            }
            updateUI()
        }
    }
    
    func updateUI() {
        randomNumberLabel()
        scoreLabel.text = String(currentScore)
        answerTxtField.text = ""
        self.view.endEditing(true)
    }
    
    func randomNumberLabel() {
        for _ in 1...4 {
            let digit = String(arc4random_uniform(9))
            number.append(digit)
        }
        randomNumber.text = number
        number = ""
    }
    
    func showHUD(isRight:Bool) {
        
        var imgView : UIImageView?
        
        imgView = isRight ? UIImageView(image: UIImage (named: "thumbs-up")) : UIImageView(image: UIImage (named: "thumbs-down"))
        
        if (imgView != nil) {
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imgView
            hud?.show(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.hud?.hide(animated: true)
            }
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textFieldDidChange()
    }
    
    func textFieldDidChange() {
        
        if answerTxtField.text?.count ?? 0 < 4 {
            return
        } else if answerTxtField.text?.count == 4 {
            inputTxt = answerTxtField.text!
            checkAnswer()
        }
        
        startTimer()
    }
}

extension UITextField {
    
    func addDoneToolBar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(onDoneTapped))
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)]
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
    
    @objc func onDoneTapped() {
        self.resignFirstResponder()
    }
}
