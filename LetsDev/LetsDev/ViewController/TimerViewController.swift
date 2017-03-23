//
//  TimerViewController.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/23.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var nextStepLabel: UILabel!
    @IBOutlet weak var nextProcessLabel: UILabel!
    @IBOutlet weak var nextProcessTimeLabel: UILabel!
    @IBOutlet weak var nextAreaView: UIView!

    var combination = Combination(film: "", type: "", preWashMinute: 0, preWashSecond: 0, dev: "", dilution: "", devMinute: 0, devSecond: 0, temp: 0, devAgitation: .Every60Sec, stopMinute: 0, stopSecond: 0, fixMinute: 0, fixSecond: 0, fixAgitation: .Every60Sec, washMinute: 0, washSecond: 0, bufferMinute: 0, bufferSecond: 0)

    var bufferTime = 00
    var preWashTime = 00
    var devTime = 00
    var stopTime = 00
    var fixTime = 00
    var washTime = 00

    var nowStep = 1

    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpNavigationBar()
        self.setUpTimes()
        self.countDownLabel.text = timeString(time: TimeInterval(self.bufferTime))
        self.startTimer()
        print(combination)
    }

    func setUpView() {
        self.restartButton.layer.borderWidth = 1
        self.restartButton.layer.borderColor = UIColor.white.cgColor
        self.restartButton.layer.cornerRadius = 10
        self.stopButton.layer.borderWidth = 1
        self.stopButton.layer.borderColor = UIColor.white.cgColor
        self.stopButton.layer.cornerRadius = 10
        self.nextAreaView.layer.borderWidth = 1
        self.nextAreaView.layer.borderColor = UIColor.white.cgColor
        self.nextAreaView.layer.cornerRadius = 10
    }

    func setUpNavigationBar() {
//        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.title = combination.film
    }

    func setUpTimes() {
        self.bufferTime = self.timeExchanger(minute: combination.bufferMinute, second: combination.bufferSecond)
        self.preWashTime = self.timeExchanger(minute: combination.preWashMinute, second: combination.bufferSecond)
        self.devTime = self.timeExchanger(minute: combination.devMinute, second: combination.devSecond)
        self.stopTime = self.timeExchanger(minute: combination.stopMinute, second: combination.stopSecond)
        self.fixTime = self.timeExchanger(minute: combination.fixMinute, second: combination.fixSecond)
        self.washTime = self.timeExchanger(minute: combination.washMinute, second: combination.washSecond)
    }

    func cancelAction() {
        print("cancel")
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func updateTimer() {
        switch self.nowStep {
        case 1, 3, 5, 7, 9:
            if self.bufferTime < 1 {
                timer.invalidate()
                self.bufferTime = self.timeExchanger(minute: combination.bufferMinute, second: combination.bufferSecond)
                self.nowStep += 1
            } else {
                self.bufferTime -= 1
                countDownLabel.text = timeString(time: TimeInterval(self.bufferTime))
            }
        default: break
        }
    }
}

extension TimerViewController {
    func timeExchanger(minute: Int, second: Int) -> Int {
        return minute * 60 + second
    }

    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
