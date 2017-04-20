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

    var combination = Combination()

    var bufferTime = 00
    var preWashTime = 00
    var devTime = 00
    var stopTime = 00
    var fixTime = 00
    var washTime = 00
    var processTimes: [Int] = []
    var nextStepTime: [Int] = []
    let processTitle = ["Get Ready", "Pre-Wash", "Get Ready", "Development", "Get Ready", "Stop", "Get Ready", "Fix", "Get Ready", "Wash"]
    let nextStepTitle = ["Pre-Wash", "Development", "Development", "Stop", "Stop", "Fix", "Fix", "Wash", "Wash", ""]

    var nowStep = 0

    var timer = Timer()
    var timer2 = Timer()

    var resumeTapped = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpNavigationBar()
        self.setUpTimes()
        self.processingLabel.text = self.processTitle[self.nowStep]
        self.nextProcessLabel.text = self.processTitle[self.nowStep + 1]
        self.countDownLabel.text = timeString(time: TimeInterval(self.processTimes[self.nowStep]))
        self.nextProcessTimeLabel.text = timeString(time: TimeInterval(self.processTimes[self.nowStep + 1]))
        self.startTimer()
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
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.title = combination.film
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        self.navigationItem.leftBarButtonItem = cancelButton
    }

    func setUpTimes() {
        self.bufferTime = self.combination.bufferTime
        self.preWashTime = self.combination.preWashTime
        self.devTime = self.combination.devTime
        self.stopTime = self.combination.stopTime
        self.fixTime = self.combination.fixTime
        self.washTime = self.combination.washTime
        self.processTimes = [self.bufferTime, self.preWashTime, self.bufferTime, self.devTime, self.bufferTime, self.stopTime, self.bufferTime, self.fixTime, self.bufferTime, self.washTime]
        self.nextStepTime = [self.preWashTime, self.devTime, self.devTime, self.stopTime, self.stopTime, self.fixTime, self.fixTime, self.washTime, self.washTime, 00]
    }

    @IBAction func stopAction(_ sender: Any) {
        if self.resumeTapped == false {
            self.timer.invalidate()
            self.resumeTapped = true
            self.stopButton.setTitle("Resume", for: .normal)
        } else {
            self.startTimer()
            self.resumeTapped = false
            self.stopButton.setTitle("Pause", for: .normal)
        }
    }

    @IBAction func restartAction(_ sender: Any) {
        self.showRestartAlert()
    }

    func cancelAction() {
        print("cancel")
        self.showCancelAlert()
    }

    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func updateTimer() {

        if self.nowStep == 9 {
            if self.processTimes[self.nowStep] < 1 {
                self.timer.invalidate()
                self.showFinishAlert()
            } else {
                self.processTimes[self.nowStep] -= 1
                self.countDownLabel.text = timeString(time: TimeInterval(self.processTimes[self.nowStep]))
            }
        } else {
            if self.processTimes[self.nowStep] < 1 {
                self.timer.invalidate()
                self.nowStep += 1
                self.processingLabel.text = self.processTitle[self.nowStep]
                self.countDownLabel.text = timeString(time: TimeInterval(self.processTimes[self.nowStep]))
                self.nextProcessLabel.text = self.nextStepTitle[self.nowStep]
                if self.nowStep == 9 {
                    self.nextProcessTimeLabel.text = ""
                } else {
                    self.nextProcessTimeLabel.text = timeString(time: TimeInterval(self.nextStepTime[self.nowStep]))
                }
                self.startTimer()
            } else {
                self.processTimes[self.nowStep] -= 1
                self.countDownLabel.text = timeString(time: TimeInterval(self.processTimes[self.nowStep]))
            }
        }
    }

    func showRestartAlert() {
        let alertController = UIAlertController(title: "Reset Timer?", message: "Do you want to stop the timer and restart?", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.timer.invalidate()
            self.setUpTimes()
            self.nowStep = 0
            self.processingLabel.text = self.processTitle[self.nowStep]
            self.countDownLabel.text = self.timeString(time: TimeInterval(self.processTimes[self.nowStep]))
            self.nextProcessLabel.text = self.nextStepTitle[self.nowStep]
            self.nextProcessTimeLabel.text = self.timeString(time: TimeInterval(self.nextStepTime[self.nowStep]))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.startTimer()
            })
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func showCancelAlert() {
        let alertController = UIAlertController(title: "Cancel Process?", message: "Do you want to cancel the timer?", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.timer.invalidate()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func showFinishAlert() {
        let alertController = UIAlertController(title: "Congratulations!", message: "Your development have just finished!\nLet’s go to record page and add some notes.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let recordTableVC = self.storyboard?.instantiateViewController(withIdentifier: "RecordTableViewController") as? RecordTableViewController {
                recordTableVC.combination = self.combination
                recordTableVC.isFromNewProcess = true
                RecordManager.shared.uploadRecord(with: self.combination, success: { (databaseRef) in
//                    print("\(String(describing: databaseRef.parent?.key))")
                    guard let recordKey = databaseRef.parent?.key else { return }
                    recordTableVC.recordKey = recordKey

                    self.navigationController?.pushViewController(recordTableVC, animated: true)
                }, fail: { (error) in
                    print(error)
                })

            }
        }

        alertController.addAction(doneAction)

        self.present(alertController, animated: true, completion: nil)
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
