//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    var questionsPerRound: Int = 0
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var question: Question = Question(question: "OOPS", answer1: "OOPS", answer2: "OOPS", answer3: "OOPS", answer4: "OOPS", correctAnswer: 1)
    
    var categoryData: [String:AnyObject]!
    
    let trivia: [[String : String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var indicatorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        usedQuestions = []
        questionsPerRound = questionsCount(categoryData["Category"] as! String)
        self.title = "Do you know \(categoryData["Category"] as! String)?"
        self.navigationItem.setHidesBackButton(true, animated:false)
        playSound(NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")!)
        // Start game
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        switch categoryData["Category"] as! String {
        case "Sports", "General":
            question = getQuestion(categoryData["Category"] as! String, used: usedQuestions)
        case "Math":
            print("create a math question")
        default:
            print("Something went wrong! Oops!")
        }
        indicatorLabel.hidden = true
        option1Button.alpha = 1
        option2Button.alpha = 1
        option3Button.alpha = 1
        option4Button.alpha = 1
        questionField.text = question.question
        option1Button.setTitle(question.answer1, forState: .Normal)
        option2Button.setTitle(question.answer2, forState: .Normal)
        option3Button.setTitle(question.answer3, forState: .Normal)
        playAgainButton.hidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        option1Button.hidden = true
        option2Button.hidden = true
        option3Button.hidden = true
        option4Button.hidden = true
        
        // Display play again button
        playAgainButton.setTitle("Play again!", forState: .Normal)
        playAgainButton.hidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        let correctAnswer = question.correctAnswer
        
        if (sender === option1Button &&  correctAnswer == 1) || (sender === option2Button && correctAnswer == 2) || (sender === option3Button && correctAnswer == 3) || (sender === option4Button && correctAnswer == 4) {
            correctQuestions += 1
            indicatorLabel.text = "Correct!"
            indicatorLabel.hidden = false
            indicatorLabel.textColor = UIColor.greenColor()
            option1Button.alpha = 0.5
            option2Button.alpha = 0.5
            option3Button.alpha = 0.5
            option4Button.alpha = 0.5
            sender.alpha = 1.0
            playSound(NSBundle.mainBundle().pathForResource("Correct", ofType: "wav")!)
        } else {
            indicatorLabel.text = "Sorry, wrong answer!"
            indicatorLabel.hidden = false
            indicatorLabel.textColor = UIColor.redColor()
            option1Button.alpha = 0.5
            option2Button.alpha = 0.5
            option3Button.alpha = 0.5
            option4Button.alpha = 0.5
            sender.alpha = 1.0
            playSound(NSBundle.mainBundle().pathForResource("False", ofType: "wav")!)
        }
        if questionsAsked == questionsPerRound {
            self.nextRound()
        } else {
            playAgainButton.setTitle("Next question", forState: UIControlState.Normal)
            playAgainButton.hidden = false
        }
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        if playAgainButton.titleLabel?.text == "Next question" {
            self.nextRound()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func questionsCount(type: String) -> Int {
        var arrayToUse: [Question]!
        switch type {
        case "Sports":
            arrayToUse = sportsQuestions
        case "General":
            arrayToUse = generalQuestions
        default:
            arrayToUse = generalQuestions
        }
        return arrayToUse.count
    }
}

