//
//  MatchTimeSettingViewController.swift
//  BasketballTimer
//
//  Created by 桑原望 on 2020/01/21.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit

class MatchTimeSettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let matchTimerSettingArray : [Int] = [3,5,6,8,10,12,20]
    
    let matchTimerSettingKey = "matchTimeTimer_value"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchTimerSetting.delegate = self
        matchTimerSetting.dataSource = self
        
        let userDefaults = UserDefaults.standard
        let matchTimeTimerValue = userDefaults.integer(forKey: matchTimerSettingKey)
        
        for row in 0..<matchTimerSettingArray.count {
            if matchTimerSettingArray[row] == matchTimeTimerValue {
                matchTimerSetting.selectedRow(inComponent: 0)
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return matchTimerSettingArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(matchTimerSettingArray[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(matchTimerSettingArray[row], forKey: matchTimerSettingKey)
        userDefaults.synchronize()
    }
    
    @IBOutlet weak var matchTimerSetting: UIPickerView!
    
}
