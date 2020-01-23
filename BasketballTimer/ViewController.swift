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
    var matchTimeTimer:[Int] = [5, 00]
    //matchTimeLabelの表示を初期化
    var timer1 = Timer()
    var timer2: Timer?
    var matchTimeCount = 0
    var count = 0
    let userDefaults = UserDefaults.standard
    //shotClockの設定値を扱うキーを設定
    let shotClockSettingKey = "shotClockTimer_value"
    //matchTimeの設定値を扱うキーを設定
    // let matchTimeSettingKey = "matchTimeTimer_value"
    //ブザーの音源ファイルを指定
    let buzzerPath = Bundle.main.bundleURL.appendingPathComponent("BuzzerSounding.mp3")
    var buzzerPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初期表示はリセットボタンを非表示
        matchTimeResetBtn.isHidden = true
        shotClockResetBtn.isHidden = true
        //shotClockの初期値を24秒に設定
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: [shotClockSettingKey:24])
    }
    
    
    @IBOutlet weak var matchTimeStartBtn: UIButton!
    @IBOutlet weak var matchTimeResetBtn: UIButton!
    @IBOutlet weak var matchTimeLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    @IBOutlet weak var shotClockStartBtn: UIButton!
    @IBOutlet weak var shotClockResetBtn: UIButton!
    
    @IBAction func settingButtonAction(_ sender: Any) {
        //timer2をアンラップしてnowTimerに代入
        if let nowTimer = timer2 {
            //もしタイマーが実行中だったら停止
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    @IBAction func matchTimeStartReset(_ sender: Any) {
        
        self.timer1 = Timer.scheduledTimer(timeInterval: 1.0,
                                           target: self,
                                           selector: #selector(self.matchTimer),
                                           userInfo: nil,
                                           repeats: true)
        matchTimeStartBtn.isHidden = true
        matchTimeResetBtn.isHidden = false
    }
    
    @IBAction func matchTimeResetBtn(_ sender: Any) {
        //タイマー停止
        self.timer1.invalidate()
        //タイマーを設定値に戻す
        let matchTimer = userDefaults.integer(forKey:"matchTimeTimer_value")
        matchTimeTimer = [matchTimer,0]
        matchTimeLabel.text = String(matchTimer) + ":00"
        matchTimeStartBtn.isHidden = false
        matchTimeResetBtn.isHidden = true
    }
    
    @IBAction func shotClockStartReset(_ sender: Any) {
        if let nowTimer = timer2 {
            //もしタイマーが実行中だったらスタートしない
            if nowTimer.isValid == true {
                //何も処理しない
                return
            }
        }
        timer2 = Timer.scheduledTimer(timeInterval: 1.0,
                                      target: self,
                                      selector: #selector(self.timerInterrupt(_:)),
                                      userInfo: nil,
                                      repeats: true)
        shotClockStartBtn.isHidden = true
        shotClockResetBtn.isHidden = false
    }
    
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
            
            do {
                buzzerPlayer = try AVAudioPlayer(contentsOf: buzzerPath, fileTypeHint: nil)
                buzzerPlayer.play()
            } catch {
                print("ブザーでエラーが発生しました")
            }
        }
    }
    //試合時間の経過時間の処理
    @objc func matchTimer(_ timer: Timer) {
        //残り時間が0になったらタイマーを止める + 試合終了ブザーを鳴らす
        if matchTimeTimer[0] == 0 && matchTimeTimer[1] == 0 {
            timer.invalidate()
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

