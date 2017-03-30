//
//  Trump.swift
//  TrumpCard
//
//  Created by Erick Sauri on 11/4/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import Foundation

class Trump {
    
    /*
     * Constants
     */
    let maxRandomRange: UInt32 = 6
    
    /*
     * Fields
     */
    private var favorability: [String: Int]?
    private var score: Int?
    private var temperament: Int?
    private var vote = ["africanAmerican": 0, "asianAmerican": 0, "latinoAmerican": 0, "whiteCollegeEducated": 0, "whiteNonCollegeEducated": 0]
    
    /*
     * This data is based on Dave Wasserman's (@Redistrict) map of demographics in the 2016 election found here:
     * http://projects.fivethirtyeight.com/2016-swing-the-election/?ex_cid=story-twitter#NCEW:0.708;0.584,CEW:0.439;0.77,Black:0.083;0.54,Latino:0.23;0.54,A/O:0.187;0.549,3:0.055
     */
    let votingBloc = ["africanAmerican": 10.8, "asianAmerican": 6, "latinoAmerican": 10.0, "whiteCollegeEducated": 30.2, "whiteNonCollegeEducated": 43]
    
    private var numberOfQuestions: Int?
    
    /*
     * Constructor
     */
    init(numberOfLevels: Int) {
        let groupFavorables = ["africanAmerican": 0, "asianAmerican": 0, "latinoAmerican": 0, "whiteCollegeEducated": 0, "whiteNonCollegeEducated": 0]
        let initialTemperament = 0
        
        self.setNumberOfQuestion(numberOfLevels)
        self.calculateScore()
        self.setTemperament(initialTemperament)
        self.setFavorability(groupFavorables)
    }
    
    /*
     * Methods
     */
    
    /*
     * Get Methods
     */
    func getTemperament () -> Int {
        return temperament!
    }
    
    func getScore () -> Int {
        return score!
    }
    
    func getFavorability () -> [String: Int] {
        return favorability!
    }
    
    func getVote () -> [String: Int] {
        return vote
    }
    
    func getVoteByGroup (_ _group: String) -> Int {
        return vote[_group]!
    }
    
    func getNumberOfQuestions() -> Int {
        return numberOfQuestions!
    }
    
    /*
     * Set Methods
     */
    func setTemperament (_ _temperament: Int) {
        temperament = _temperament
    }
    
    func setFavorability (_ _favorables: [String: Int]) {
        favorability = _favorables
    }
    
    func setVoteByGroup (_ _group: String, _ _favorability: Int) {
        vote[_group]! = 0
    }
    
    func setNumberOfQuestion (_ _numberOfQuestions: Int) {
        numberOfQuestions = _numberOfQuestions
    }
    
    /*
     * Helper Methods
     */
    
    func alleviateTrump () {
        let randomNum = arc4random_uniform(10) + 1
        let randomInt = Int(randomNum)

        temperament! -= randomInt
        
        if temperament! < 0 {
            temperament = 0
        }
        
    }
    
    func enrageTrump () {
        let randomNum = arc4random_uniform(30) + 1
        let randomInt = Int(randomNum)

        temperament! += randomInt
        
        if temperament! > 100 {
            temperament = 100
        }
    }
    
    func getFavorablesOfGroup (_ _group: String) -> Int {
        return favorability![_group]!
    }
    
    func setFavorableOfGroup (_ _group: String, _  _favorables: Int) {
        favorability![_group]! = _favorables
    }
    
    func calculateFavorablesOfGroup (_ _group: String, _ _favorables: Int) {
        let maxRange = UInt32(abs(_favorables))
        
        let randomNum = arc4random_uniform(maxRange)
        let randomInt = Int(randomNum)
        
        if _favorables > 0 {
            favorability![_group]! += randomInt
        }
        else {
            favorability![_group]! -= randomInt
        }
    }
    
    func calculateScore () {
        var newScore = 0
        
        for (bloc, _) in vote {
           newScore += vote[bloc]!
        }
        
        score = newScore
    }
    
    func calculateBlocVoteOf (_ _bloc: String) {
        // Get favorability
        let blocFavorability = Double((favorability?[_bloc])!)
        
        let totalPercent = 100.0
        
        // Calculate the ceiling/floor of a bloc's favorability toward the player
        let favorabilityCeiling = Double(numberOfQuestions!)

        // map values
        let mappedFavorability = mapValuesToRange(value: blocFavorability, fromMin: (-favorabilityCeiling), fromMax: favorabilityCeiling, toMin: 1, toMax: 100)
        
        // calculate percent voting for player
        let peopleVotingForPlayer = mappedFavorability
        
        let percentageVotingForPlayer = peopleVotingForPlayer / totalPercent
        
        vote[_bloc] = Int(percentageVotingForPlayer * votingBloc[_bloc]!)
        
        if vote[_bloc]! < 0 {
            vote[_bloc]! = 0
        }        
    }
    
    func mapValuesToRange (value: Double, fromMin: Double, fromMax: Double, toMin: Double, toMax: Double) -> Double {
        let from = fromMax - fromMin
        let to = toMax - toMin
        let mappedValue = toMin + ((value - fromMin) * to) / from
        
        return mappedValue
    }
    
    func recalculateScore (_ _choice: Choice) {
        // Calculate DJT's favorability with voting blocks
        for (group, value) in _choice.getElectorateEffect() {
            calculateFavorablesOfGroup(group, value)
            calculateBlocVoteOf(group)
        }
        calculateScore()
    }
    

}
