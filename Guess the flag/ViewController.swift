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
    var correctAnswer = 0
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
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
        title = "Tap on \(uppercasedCountry)'s flag. Your current score is: \(score)."
    }
    
    
}
