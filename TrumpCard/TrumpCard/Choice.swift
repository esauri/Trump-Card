//
//  Choice.swift
//  TrumpCard
//
//  Created by Erick Sauri on 11/1/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import Foundation

class Choice {
    
    /*
     * Fields
     */
    
    // choice identifier
    private var id: Int?
    
    // response
    private var response: String?
    
    // actual DJT quote
    private var quote: String?
    
    // bibliography or reference to quote
    private var reference: String?
    
    // path for audio clip
    private var audioPath: String?
    
    
    // effect of choice on electorate
    // string is for the demographic group
    // int is for the impact number, can be either negative or positive impact
    // current demographics:
    // * african-americans
    // * asian-americans
    // * latinos/hispanics
    // * white college educated
    // * white non-college educated
    private var electorateEffect: [String: Int]?
    
    /*
     * Constructors
     */
    
    // initializer
    init(id: Int, response: String, quote: String, reference: String, electorateEffect: [String: Int], audioPath: String) {
        self.setId(id)
        self.setResponse(response)
        self.setQuote(quote)
        self.setReference(reference)
        self.setElectorateEffect(electorateEffect)
        self.setAudioPath(audioPath)
    }
    
    // convenience initializer
    convenience init() {
        self.init(id: -1, response: "Unknown", quote: "Unknown", reference: "Unknown", electorateEffect: ["Unknown": 0], audioPath: "Unknown")
    }
    
    /*
     * Methods
     */
    // Get Methods
    func getId() -> Int {
        return id!
    }
    
    func getResponse() -> String {
        return response!
    }
    
    func getQuote() -> String {
        return quote!
    }

    func getReference() -> String {
        return reference!
    }
    
    func getElectorateEffect() -> [String: Int] {
        return electorateEffect!
    }
    
    func getAudioPath() -> String {
        return audioPath!
    }
    
    // Set Methods
    func setId(_ _value: Int) {
        id = _value
    }
    
    func setResponse(_ _value: String) {
        response = _value
    }
    
    func setQuote(_ _value: String) {
        quote = _value
    }
    
    func setReference(_ _value:String) {
        reference = _value
    }
    
    func setElectorateEffect(_ _value:[String: Int]) {
        electorateEffect = _value
    }
    
    func setAudioPath(_ _value:String) {
        audioPath = _value
    }
    
}
