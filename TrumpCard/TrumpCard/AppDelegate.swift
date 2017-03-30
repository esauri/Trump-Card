//
//  AppDelegate.swift
//  TrumpCard
//
//  Created by Erick Sauri on 11/1/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Data File constants
    let DATA_FILE = "data"
    let DATA_FORMAT = "plist"
    
    // Game Data
    var questions: [Question] = []
    var choices: [Choice] = []
    
    var gameNavigationViewController: UINavigationController?
//    var gameViewController: GameViewController?
    
    /*
     * #MARK: Application
     * Application
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Load data
        loadData()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the gameViewController
//        gameViewController = window?.rootViewController as? GameViewController
        gameNavigationViewController = window?.rootViewController as? UINavigationController
        let gameViewController = gameNavigationViewController?.viewControllers[0] as! GameViewController
        
        let referencesNavigationViewController = storyBoard.instantiateViewController(withIdentifier: "referencesNavigationViewController") as! UINavigationController
        
        let referencesTableViewController = referencesNavigationViewController.viewControllers[0] as! TrumpQuotesTableVC
        
        let aboutViewController = storyBoard.instantiateViewController(withIdentifier: "aboutViewController")
        
        // Create a PressConference
        let pressConference = PressConference()
        
        // Pass in the data to our pressConference object
        pressConference.allQuestions = questions
        pressConference.questions = questions
        pressConference.choices = choices
        
        // Pass pressConference to the ViewController
        gameViewController.pressConference = pressConference
        gameViewController.referencesNavigationViewController = referencesNavigationViewController
        gameViewController.aboutViewController = aboutViewController
        
        referencesTableViewController.pressConference = pressConference
        
        // Return
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*
     * #MARK: Data loading
     * Data loading
     */
    
    // Load data from plist
    func loadData() {
        if let dataFilePath = Bundle.main.path(forResource: DATA_FILE, ofType: DATA_FORMAT) {
            let tempDict = NSDictionary(contentsOfFile: dataFilePath)
            let tempQuestionsArray = (tempDict!.value(forKey: "questions") as! NSArray) as Array
            let tempChoicesArray = (tempDict!.value(forKey: "choices") as! NSArray) as Array
            
            loadQuestions(tempQuestionsArray)
            loadChoices(tempChoicesArray)
        }
    }
    
    // Load questions
    func loadQuestions(_ _questionData: Array<AnyObject>) {
        //Loop through _questionData
        for q in _questionData {
            // Make sure everything is in the correct Type
            let id = q["id"]! as! Int
            let blurb = q["blurb"]! as! String
            let category = q["category"]! as! String
            let choices = q["choices"]! as! [String: Int]
            let imagePath = q["imagePath"]! as! String
            
            // Create a question
            let question = Question(id: id, blurb: blurb, choiceIds: choices, imagePath: imagePath, category: category)
            
            // Append to questions
            questions.append(question)
        }
    }
    
    // Load choicess
    func loadChoices (_ _choiceData: Array<AnyObject>) {
        //Loop through _choiceData
        for c in _choiceData {
            // Make sure everything is in the correct Type
            let id = c["id"]! as! Int
            let response = c["response"]! as! String
            let quote = c["quote"]! as! String
            let reference = c["reference"]! as! String
            let audioPath = c["audioPath"]! as! String
            let electorateEffect = c["electorateEffect"]! as! [String: Int]
            
            // Create a choice
            let choice = Choice(id: id, response: response, quote: quote, reference: reference, electorateEffect: electorateEffect, audioPath: audioPath)
            
            // Append to choices
            choices.append(choice)
        }
    }

}

