//
//  ViewController.swift
//  Guess the flag
//
//  Created by Michele Galvagno on 19/02/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    // MARK: - Outlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // MARK: - Properties
    var countries = [String]()
    var score = 0
    var highScore = 0
    var correctAnswer = 0
    var askedQuestions = 0
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
        registerLocal()
        scheduleWeek()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        
        if let highScore = defaults.value(forKey: "highScore") as? Int {
            self.highScore = highScore
            print("Successfully loaded high score! It is a \(highScore)!")
        } else {
            print("Failed to load high score or score not yet saved. High score is \(highScore)...")

        }
        
        askQuestion()
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }, completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { _ in
                self.checkAnswer(answer: sender.tag)
            })
        })
    }
    
    // MARK: - Methods
    // Show three random flag images on the screen
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        let uppercasedCountry = countries[correctAnswer].uppercased()
        title = uppercasedCountry
        askedQuestions += 1
    }
    
    // Start a new game
    func startNewGame(action: UIAlertAction) {
        score = 0
        askedQuestions = 0
        
        askQuestion()
    }
    
    // Show the score on tapping the Bar Button Item
    @objc func showScore() {
        let scoreAlert = UIAlertController(title: "SCORE", message: nil, preferredStyle: .actionSheet)
        scoreAlert.addAction(UIAlertAction(title: "Your current score is \(score)!", style: .default))
        scoreAlert.addAction(UIAlertAction(title: "Your current highest score is \(highScore)!", style: .default))
        
        present(scoreAlert, animated: true)
    }
    
    // Save the high score
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
        print("Successfully saved score!")
    }
    
    // Manage the different alert controllers
    func checkAnswer(answer: Int) {
        var title: String
        
        if answer == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[answer].uppercased())"
            score -= 1
        }
        
        if askedQuestions < 10 {
            let alertController = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(alertController, animated: true)
        } else {
            if score > highScore {
                highScore = score
                save()
                let highScoreAC = UIAlertController(title: "Game over! New High Score", message: "Your score is \(score).", preferredStyle: .alert)
                highScoreAC.addAction(UIAlertAction(title: "Start new game!", style: .default, handler: startNewGame))
                present(highScoreAC, animated: true)
            } else {
                let finalAlertController = UIAlertController(title: "Game over!", message: "Your score is \(score).", preferredStyle: .alert)
                finalAlertController.addAction(UIAlertAction(title: "Start new game!", style: .default, handler: startNewGame))
                present(finalAlertController, animated: true)
            }
        }
    }
    
    // MARK: - Notifications
    // Request user permissions
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Urrah!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    func scheduleWeek() {
        for weekday in 1 ... 7 {
            schedule(for: weekday)
        }
    }
    
    func schedule(for weekday: Int) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        let content = createContent()
        let dateComponents = setDate(at: 9, and: 30, on: weekday)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func createContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "It's flag time!"
        content.body = "Your favourite flags collection is missing you!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "It's game time!"]
        content.sound = .default
        
        return content
    }
    
    func setDate(at hour: Int?, and minutes: Int?, on weekday: Int?) -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minutes
        dateComponents.weekday = weekday
        
        return dateComponents
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Let's play!", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later...", options: [])
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                center.removeAllPendingNotificationRequests()
            case "show":
                center.removeAllPendingNotificationRequests()
                let tapAC = UIAlertController(title: "Welcome back!", message: "Your flags have missed you! Ready to play?", preferredStyle: .alert)
                tapAC.addAction(UIAlertAction(title: "Yes, let's play!", style: .default))
                
                present(tapAC, animated: true)
            case "remind":
                response.notification.snoozeNotification(for: 0, minutes: 10, seconds: 0)
            default:
                break
            }
        }
    }
}

// Credit to Simon Ljungberg
extension UNNotification {
    func snoozeNotification(for hours: Int, minutes: Int, seconds: Int) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "It's flag time!"
        content.body = "We are waiting for you!"
        content.userInfo = ["customData": "It's game time!"]
        content.sound = .default
        
        let identifier = self.request.identifier
        guard let oldTrigger = self.request.trigger as? UNCalendarNotificationTrigger else {
            debugPrint("Cannot reschedule notification without calendar trigger.")
            
            return
        }
        
        var components = oldTrigger.dateComponents
        components.hour = (components.hour ?? 0) + hours
        components.minute = (components.minute ?? 0) + minutes
        components.weekday = (components.weekday ?? 0)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                debugPrint("Rescheduling failed", error.localizedDescription)
            } else {
                debugPrint("Rescheduling succeeded")
            }
        }
    }
}

