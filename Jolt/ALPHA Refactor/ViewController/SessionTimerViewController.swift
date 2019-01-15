//
//  SessionTimerViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-05.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import HGCircularSlider
import Firebase
import FirebaseAuthUI
import UserNotifications

class SessionTimerViewController: UIViewController {
    
    // DEBUG TIME LOG
    @IBOutlet weak var logTimeButton: UIButton!
    
    @IBAction func logTimePressed(_ sender: Any) {
        addSessionToFirebase()
    }
    
    // Create Firestore Database and User ID Reference
    var db: Firestore!
    let userID = Auth.auth().currentUser!.uid
    
    // MARK: Proprieties
    var habitName = String()
    var totalLoggedTime = Int()
    var joltsCount = Int()
    var sessionCount = Int()
    
    // Timer Proprieties
    var sessionLengthInMinutes = 0
    var sessionLengthInSeconds = 0
    var currentSessionTime = 0
    var timer = Timer()
    var timerIsRunning = false
    var timerIsPaused = false
    var resume = false
    
    // Timer Variables to calculate time difference when in background
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var diffMilliSecs = 0
    
    // MARK: IBOutlet
    @IBOutlet weak var habitButton: UIButton!
    @IBOutlet weak var currentActivityImage: UIImageView!
    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var sessionMessage: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        prepareView()
        setupTimer()
        
        // DEFINE
        checkForUpdate()
        
        // BACKGROUND MODE:
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterTerminate(noti:)), name: UIApplication.willTerminateNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    func prepareView() {
        habitButton.setTitle(habitName, for: .normal)
        timeLabel.text = "\(sessionLengthInMinutes) minutes"
        sessionLengthInSeconds = sessionLengthInMinutes * 60
    }
    
    func setupTimer() {
        // Timer minimum value should always be 0 minutes, hence no variables.
        circularSlider.minimumValue = 0.0
        // Timer maximum value should be determined by the user.
        circularSlider.maximumValue = CGFloat(sessionLengthInSeconds)
        circularSlider.endPointValue = (CGFloat(sessionLengthInSeconds) - 0.1)
        
        currentSessionTime = sessionLengthInSeconds
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SessionTimerViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    @objc func updateTimer() {
        if currentSessionTime < 1 {
            // Add current session to total in firebase
            addSessionToFirebase()
        } else {
            currentSessionTime -= 1
            timeLabel.text = timeString(time: TimeInterval(currentSessionTime))
            circularSlider.endPointValue = (CGFloat(currentSessionTime) - 0.1)
        }
    }
    
    func reinitiateTimer() {
        currentSessionTime = sessionLengthInMinutes * 60
        timerIsRunning = false
        timeLabel.text = "\(Int(sessionLengthInMinutes)) minutes"
        startPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        
    }
    
    func addSessionToFirebase() {
        
        sessionCount += 1
        totalLoggedTime += sessionLengthInMinutes
        
        logSessionData()
        
        self.reinitiateTimer()
        self.setupTimer()
    }
    
    func cancelCurrentIntervalAlert() {
        let alertController = UIAlertController(title: "Oops!", message: "Are you sure you want to quit the current interval?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (alert: UIAlertAction!) in
            self.timer.invalidate()
            self.timerIsRunning = false
            
            self.dismiss(animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: { (alert: UIAlertAction!) in
        })
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "new jolt",
            let destination = segue.destination as? SessionJoltViewController {
            destination.habitName = habitName
            destination.joltCount = joltsCount
        }
        
        if segue.identifier == "edit habit",
            let destination = segue.destination as? SessionEditViewController {
            destination.habitName = habitName
            destination.sessionTime = sessionLengthInMinutes
            destination.onSave = onSave
        }
    }

    // MARK: IBAction
    @IBAction func backButton(_ sender: Any) {
        if timerIsRunning || timerIsPaused {
            cancelCurrentIntervalAlert()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func editHabitButton(_ sender: Any) {
    }
    
    @IBAction func sessionTimerButtonPressed(_ sender: UIButton) {
        
        if !timerIsRunning {
            // Timer has started
            runTimer()
            timerIsRunning = true
            scheduleLocal()
            sessionMessage.text = "Activity Tracking In Progress..."
            sender.setImage(UIImage(named: "Pause"), for: .normal)
        } else {
            // Timer is paused
            timer.invalidate()
            timerIsRunning = false
            timerIsPaused = true
            sessionMessage.text = "Timer is paused..."
            sender.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    @IBAction func joltButtonPressed(_ sender: Any) {
        print("Pressed")
    }
    
}

extension SessionTimerViewController {
    
    // Firebase Stuff
    func checkForUpdate() {
        let collectionRef = db.document("users/\(userID)").collection("Habits")
        let query = collectionRef.whereField("Name", isEqualTo: "\(habitName)")
        
        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.joltsCount = document["Jolt Count"] as! Int
                    self.totalLoggedTime = document["Total Time Logged"] as! Int
                    self.sessionCount = document["Session Count"] as! Int
                }
            }
        }
    }
    
    // Log New Session in Firebase
    func logSessionData() {
        
        let name = habitName
        let collectionReference = db.document("users/\(userID)").collection("Habits")
        let query = collectionReference.whereField("Name", isEqualTo: name)
        query.getDocuments(completion: { (snapshot, error) in
            if let error =  error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {

                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").updateData([
                        "Total Time Logged" : (self.totalLoggedTime),
                        "Session Count" : (self.sessionCount)
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated for \(name)")
                            print("Total Logged Time data: \(self.totalLoggedTime)")
                            print("Session count data: \(self.sessionCount)")
                        }
                    }
                    
                    let sessionData = Session(sessionLength: self.sessionLengthInMinutes, createdOn: Date()).dictionary
                    
                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").collection("Session").addDocument(data: sessionData)
                    
                }
            }
        })
    }
    
    // User edit on habit
    func onSave(_ time: Int, _ name: String) {
        
        // Update Session Length in Firebase
        let name = habitName
        let collectionReference = db.document("users/\(userID)").collection("Habits")
        let query = collectionReference.whereField("Name", isEqualTo: name)
        query.getDocuments(completion: { (snapshot, error) in
            if let error =  error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    
                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").updateData([
                        "Session Length" : time
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    
                    let sessionData = Session(sessionLength: self.sessionLengthInMinutes, createdOn: Date()).dictionary
                    
                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").collection("Session").addDocument(data: sessionData)
                    
                }
            }
        })
        
        // find out what is current time expanded on session
        let currentSessionTimeInminutes = sessionLengthInMinutes - (currentSessionTime / 60)
        print("Current Session Time = \(currentSessionTimeInminutes)")
        // if the new session length is smaller than the current session time expanded, then save the session and reset the timer
        if currentSessionTimeInminutes > time {
            print("Current Session Time is less than new Time")
            
        } else {
            print("Current Session Time is more than new Time")
            sessionLengthInMinutes = time
            timer.invalidate()
            reinitiateTimer()
            
        }
        
        // if the new session length is higher than current session time expanded, then change session lenght and keep current session running
        
    }
    
}

extension SessionTimerViewController {
    // Notification Center to calculate timer when app is closed
    @objc func pauseWhenBackground(noti: Notification) {
        self.timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
    }
    
    @objc func willEnterForeground(noti: Notification) {
        
        if timerIsRunning {
            if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
                (diffHrs, diffMins, diffSecs) = SessionTimerViewController.getTimeDifference(startDate: savedDate)
            }
            
            self.refreshTimer(hours: diffHrs, mins: diffMins, secs: diffSecs)
        }
    }
    
    @objc func willEnterTerminate(noti: Notification) {
        print("App has been terminated")
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refreshTimer(hours: Int, mins: Int, secs: Int) {
        
        let minsInSecs = mins * 60
        currentSessionTime -= (minsInSecs + secs)
        
        if currentSessionTime < 1 {
            
            self.addSessionToFirebase()
            
            let alertController = UIAlertController(title: "Session finished!", message: "Your session ended while you were away", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Perfect!", style: .default) { (UIAlertAction) in
                print("Ok button was pressed")
            }
            alertController.addAction(okButton)
            self.present(alertController, animated: true)
            
        } else {
            timerIsRunning = true
            runTimer()
        }
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
}

extension SessionTimerViewController {
    // Local Notification
    func scheduleLocal() {
        
        print("Trying to schedule local notification")
        print("Total Logged Time before data: \(self.totalLoggedTime)")
        print("Session count before data: \(self.sessionCount)")
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Your \(habitName) session just finished"
        content.body = "Good job!"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(sessionLengthInSeconds), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }
}
