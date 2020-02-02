//
//  ViewController.swift
//  BasketballTimer
//
//  Created by 桑原望 on 2020/01/18.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //matchTimer初期設定
    var matchTimeTimer: [Int] = [10, 0]
    //matchTimeLabelの表示を初期化
    var timer1 = Timer()
    var timer2: Timer?
    //var timer14: Timer?
    var count = 0
    //var count14 = 0
    let userDefaults = UserDefaults.standard
    //shotClockの設定値を扱うキーを設定
    let shotClockSettingKey = "shotClockTimer_value"
    let matchTimerSettingKey = "matchTimeTimer_value"
    
    //ブザーの音源ファイルを指定
    let buzzerPath = Bundle.main.bundleURL.appendingPathComponent("BuzzerSounding.mp3")
    var buzzerPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初期表示はリセットボタンを非表示
        matchTimeResetBtn.isHidden = true
        shotClockResetBtn.isHidden = true
        fourteenResetBtn.isHidden = true
        stopBtn.isHidden = true
        //matchTImerの初期値を10分に設定
        //shotClockの初期値を24秒に設定
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [matchTimerSettingKey:10])
        userDefaults.register(defaults: [shotClockSettingKey:24])
    }
    
    @IBOutlet weak var matchTimeStartBtn: UIButton!
    @IBOutlet weak var matchTimeResetBtn: UIButton!
    @IBOutlet weak var matchTimeLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    @IBOutlet weak var shotClockResetBtn: UIButton!
    @IBOutlet weak var fourteenResetBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    @IBAction func MatchTimerSettingBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "goMatchTimerSetting", sender: nil)
    }
    //shotClockのタイマー設定画面へ
    @IBAction func settingButtonAction(_ sender: Any) {
        //timer2をアンラップしてnowTimerに代入
        if let nowTimer = timer2 {
            //もしタイマーが実行中だったら停止
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        performSegue(withIdentifier: "goShotClockSetting", sender: nil)
    }
    //タイマー再生
    @IBAction func matchTimeStartReset(_ sender: Any) {
        //試合時間のタイマー
        self.timer1 = Timer.scheduledTimer(timeInterval: 1.0,
                                           target: self,
                                           selector: #selector(self.matchTimer),
                                           userInfo: nil,
                                           repeats: true)
        //ShotClockのタイマー
        timer2 = Timer.scheduledTimer(timeInterval: 1.0,
                                      target: self,
                                      selector: #selector(self.timerInterrupt(_:)),
                                      userInfo: nil,
                                      repeats: true)
        //shotClockを12秒にした時のボタン表示
         let timerValue = userDefaults.integer(forKey: shotClockSettingKey)
        if timerValue == 12 {
            matchTimeStartBtn.isHidden = true
            matchTimeResetBtn.isEnabled = false
            shotClockResetBtn.isHidden = false
            fourteenResetBtn.isHidden = true
            stopBtn.isHidden = false
        } else {
        //shotClockが=12秒以外の時のボタン表示
        matchTimeStartBtn.isHidden = true
        matchTimeResetBtn.isEnabled = false
        shotClockResetBtn.isHidden = false
        fourteenResetBtn.isHidden = false
        stopBtn.isHidden = false
        }
    }
    @IBAction func matchTimeResetBtn(_ sender: Any) {
        //タイマー停止
        self.timer1.invalidate()
        //タイマーを設定値に戻す
        let matchTimer = userDefaults.integer(forKey:"matchTimeTimer_value")
     
        matchTimeLabel.text = String(matchTimer) + ":00"
        
        count = 0
        _ = displayUpdate()        //スタートボタンを再表示、リセットボタンは非表示
        matchTimeStartBtn.isHidden = false
        matchTimeResetBtn.isHidden = true
    }
    //停止ボタンで全タイマーを停止させる
    @IBAction func StopButton(_ sender: Any) {
        self.timer1.invalidate()
      
        //もしタイマーが実行中だったら停止
        if let nowTimer = timer2 {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        //停止ボタンを押したら、スタートボタンを表示、リセットボタンを非表示
        matchTimeResetBtn.isHidden = true
        matchTimeStartBtn.isHidden = false
        shotClockResetBtn.isHidden = false
        stopBtn.isHidden = true
    }
    @IBAction func shotClockResetBtn(_ sender: Any) {
        
//        if let nowTimer = timer2 {
//            //もしタイマーが実行中だったらスタートしない
//            if nowTimer.isValid == true {
//                //何も処理しない
//                nowTimer.invalidate()
//            }
//        }
        //タイマーを設定値に戻す
        count = 0
        _ = displayUpdate()
//        //タイマー再開
       // timer2 = Timer.scheduledTimer(timeInterval: 1.0,
//                                      target: self,
//                                      selector: #selector(self.timerInterrupt(_:)),
//                                      userInfo: nil,
//                                      repeats: true)
//        shotClockResetBtn.isHidden = false
    }
    
    @IBAction func fourteenResetBtn(_ sender: Any) {
        //14秒タイマーのセット
    let timerValue = userDefaults.integer(forKey: shotClockSettingKey)
        //24秒ルール時
        if timerValue == 24 {
        count = 10
            _ = displayUpdate()
            //30秒ルール時
        } else if timerValue == 30 {
            count = 16
            _ = displayUpdate()
        }
    }
    //shotClockタイマーの画面を更新する(戻り値：remainCount:残り時間)
    func displayUpdate() -> Int {
        let userDefaults = UserDefaults.standard
        let timerValue = userDefaults.integer(forKey: shotClockSettingKey)
        let remainCount = timerValue - count
        shotClockLabel.text = "\(remainCount)"
        //残り時間を戻り値に設定
        return remainCount
    }
 
    //shotClockタイマーの経過時間の処理
    @objc func timerInterrupt(_ timer: Timer) {
        //count(経過時間)に+1していく
        count += 1
        // remainCountが0のときタイマーを止める
        if displayUpdate() <= 0 {
            count = 0
            timer.invalidate()
            matchTimeStartBtn.isHidden = false
            shotClockResetBtn.isHidden = false
            stopBtn.isHidden = true
            do {
                buzzerPlayer = try AVAudioPlayer(contentsOf: buzzerPath, fileTypeHint: nil)
                buzzerPlayer.play()
            } catch {
                print("ブザーでエラーが発生しました")
            }
            self.timer1.invalidate()
        }
    }
    //試合時間の経過時間の処理
    @objc func matchTimer(_ timer: Timer) {
        //残り時間が0になったらタイマーを止める + 試合終了ブザーを鳴らす
        if matchTimeTimer[0] == 0 && matchTimeTimer[1] == 0 {
            self.timer1.invalidate()
            if let nowTimer = timer2 {
                //もしタイマーが実行中だったらスタートしない
                if nowTimer.isValid == true {
                    //何も処理しない
                    nowTimer.invalidate()
                }
            }
            //リセットボタンを押せないようにする
            stopBtn.isHidden = true
            matchTimeStartBtn.isHidden = true
            matchTimeResetBtn.isHidden = false
            matchTimeResetBtn.isEnabled = true
            shotClockResetBtn.isHidden = true
            fourteenResetBtn.isHidden = true
            do {
                buzzerPlayer = try AVAudioPlayer(contentsOf: buzzerPath, fileTypeHint: nil)
                buzzerPlayer.play()
            } catch {
                print("ブザーでエラーが発生しました")
            }
        } else {
            // 秒数が0以上のとき、秒数を-1
            if matchTimeTimer[1] > 0 {
                matchTimeTimer[1] -= 1
            } else {
                //秒数が0のとき、59へ
                matchTimeTimer[1] += 59
                //1分以上のとき-1分
                if matchTimeTimer[0] > 0 {
                    matchTimeTimer[0] -= 1
                } else {
                    timer.invalidate()
                }
            }
        }
        matchTimeLabel.text = String(matchTimeTimer[0]) + ":" + String(format: "%02d", matchTimeTimer[1])
    }
    //画面切り替えのタイミングで処理を行う
    override func viewDidAppear(_ animated: Bool) {
        //カウントを0にする
        count = 0
        //タイマーの表示を更新
        _ = displayUpdate()
        //matchTimeの表示
        let matchTimer = userDefaults.integer(forKey:"matchTimeTimer_value")
        matchTimeTimer = [matchTimer,0]
        matchTimeLabel.text = String(matchTimer) + ":00"
    }
}

