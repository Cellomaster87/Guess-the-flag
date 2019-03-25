//
//  ViewController.swift
//  Guess the flag
//
//  Created by Michele Galvagno on 19/02/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
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
        
        do {
            defaults.set(highScore, forKey: "highScore")
            print("Successfully saved score!")
        } catch {
            print("Failed to save high score")
        }
    }
}

