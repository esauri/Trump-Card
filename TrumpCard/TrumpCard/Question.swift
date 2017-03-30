//
//  Question.swift
//  TrumpCard
//
//  Created by Erick Sauri on 11/1/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import Foundation

class Question {
    
    /*
     * Fields
     */
    
    // identifier
    private var id: Int?
    
    // question
    private var blurb: String?
    
    // choices tied to current question 
    // string is either Left/Positive or Right/Negative
    // int is choice identifier
    private var choiceIds: [String: Int]?
    
    // path for the image to be displayed on card
    private var imagePath: String?
    
    // category for question (subject to change)
    private var category: String?
    
    /*
     * Constructors
     */
    
    // initializer
    init(id: Int, blurb: String, choiceIds: [String: Int], imagePath: String, category: String) {
        self.setId(id)
        self.setBlurb(blurb)
        self.setChoiceIds(choiceIds)
        self.setImagePath(imagePath)
        self.setCategory(category)
    }
    
    // convenience initializer
    convenience init() {
        self.init(id: -1, blurb: "Unknown", choiceIds: ["Unknown": -1], imagePath: "Unknown", category: "Unknown")
    }
    
    /*
     * Methods
     */
    
    // Get Methods
    func getId() -> Int {
        return id!
    }
    
    func getBlurb() -> String {
        return blurb!
    }
    
    func getChoiceIds() -> [String: Int] {
        return choiceIds!
    }
    
    func getImagePath() -> String {
        return imagePath!
    }
    
    func getCategory() -> String {
        return category!
    }
    
    func getChoiceIdOf (_ _direction: String) -> Int {
        return choiceIds![_direction]!
    }
    
    // Set Methods
    func setId(_ _value: Int) {
        id = _value
    }
    
    func setBlurb(_ _value: String) {
        blurb = _value
    }
    
    func setChoiceIds(_ _value:[String: Int]) {
        choiceIds = _value
    }
    
    func setImagePath(_ _value:String) {
        imagePath = _value
    }
    
    func setCategory(_ _value:String) {
        category = _value
    }
    
}
