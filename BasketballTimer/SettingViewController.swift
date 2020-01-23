//
//  SettingViewController.swift
//  BasketballTimer
//
//  Created by 桑原望 on 2020/01/20.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //shotClockのpickerViewに表示するデータ
    let shotClocksettingArray : [Int] = [0, 12, 24, 30]
    //設定値を覚えるキーを設定。タイマー画面と共通のあキー
    let shotClockSettingKey = "shotClockTimer_value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shotClockSetting.delegate = self
        shotClockSetting.dataSource = self
       
        //let userDefaults = UserDefaults.standard
        //let shotClockTimerValue = userDefaults.integer(forKey: shotClockSettingKey)
        //Pickerの選択を合わせる
//        for row in 0..<shotClocksettingArray.count {
//            if shotClocksettingArray[row] == shotClockTimerValue {
//                shotClockSetting.selectedRow(inComponent: 0)
//            }
//        }
    }
    //UIPickerViewの列数を設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     //UIPickerViewの行数を取得
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shotClocksettingArray.count
    }
    //UIPickerViewの表示する内容を設定
    //shotClocksettingArrayから秒数を取得し、PickerViewに秒数のリストを表示させている
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(shotClocksettingArray[row])
    }
    //picker選択時に実行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //UserDefaultsの設定
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(shotClocksettingArray[row], forKey: shotClockSettingKey)
        userDefaults.synchronize()
    }
    @IBOutlet weak var shotClockSetting: UIPickerView!
 
    
}
