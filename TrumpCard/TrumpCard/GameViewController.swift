//
//  ViewController.swift
//  TrumpCard
//
//  Created by Erick Sauri on 11/1/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var referencesNavigationViewController: UINavigationController!
    var aboutViewController: UIViewController!
    
    // Cache the questions and choices in PressConference
    var pressConference = PressConference()
    
    // Create a front-end for questions
    var questions: [Question] {
        get {
            return self.pressConference.questions
        }
        set (val) {
            self.pressConference.questions = val
        }
    }
    
    // Create a front-end for choices
    var choices: [Choice] {
        get {
            return self.pressConference.choices
        }
        set (val) {
            self.pressConference.choices = val
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGame () {
        // Create a gameManager
        let gameManager = GameController(frame: self.view.frame)
        
        // Pass this ViewController
        gameManager.gameViewController = self
        
        // Give it a tag 45 for Trump
        gameManager.tag = 45
        
        // Pass in the pressConference
        gameManager.pressConference = pressConference
        
        // Start the game
        gameManager.gameStart()
        
        // Add subview
        self.view.addSubview(gameManager)
    }
    
    // Shows reference view
    func showReferences () {
        // Set transition style
        referencesNavigationViewController!.modalTransitionStyle = .flipHorizontal
        
        // Present reference view
        self.present(referencesNavigationViewController!, animated: true, completion: nil)
    }
    
    // Shows about view
    func showAbout () {
        // Set transition style
        aboutViewController!.modalTransitionStyle = .flipHorizontal
        
        // Present about view
        self.present(aboutViewController, animated: true, completion: nil)
    }
    
    // Button Actions
    @IBAction func playButtonClicked(_ sender: UIButton) {
        startGame()
    }
    
    @IBAction func aboutButtonClicked(_ sender: UIButton) {
        showAbout()
    }
    
    @IBAction func referencesButtonClicked(_ sender: UIButton) {
        showReferences()
    }
    


}

