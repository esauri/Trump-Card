//
//  OverlayView.swift
//  TrumpCard
//
//  Created by Erick Sauri on 11/3/16.
//  Adapted from cwRichardKim's TinderSimpleSwipeCards
//  Github: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//  Article: https://medium.com/@cwRichardKim/adding-tinder-esque-cards-to-your-iphone-app-4047967303d1#.m2w4za62z
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import Foundation
import UIKit

/*
 * OverlayViewMode - Enum for the modes
 */
enum OverlayViewMode {
    case None
    case Left
    case Right
}

class OverlayView: UIView {
    
    var imageView = UIImageView()
    var responseLabel = UITextView()
    
    var mode = OverlayViewMode.None
    
    var choices: [String: Choice]?
    
    // Colors
    let trumpRed = UIColor(red: 0.74, green: 0.32, blue: 0.32, alpha: 1.0)
    let trumpGold = UIColor(red: 0.95, green: 0.79, blue: 0.30, alpha: 1.0)
    let trumpBoldRed = UIColor(red: 0.69, green: 0.24, blue: 0.22, alpha: 1.0)
    
    var leftChoice: Choice?
    var rightChoice: Choice?
    
    let trumpFaces: [String: String] = ["left" : "trumpSmiling", "right": "trumpPissed", "none": "trumpSerious"]
    
    /*
     * init - OverlayView initializer
     * param {CGRect} frame - view frame
     */
    override init (frame: CGRect) {
        super.init(frame: frame)
        setView()
        addImageView()
        addResponseLabel()
    }
    
    /*
     * init - OverlayView convenient initializer
     * param {CGRect} frame - view frame
     * param {Question} question - card question
     * param {[Choice]} choices - card choices
     */
    convenience init(frame: CGRect, question: Question, choices: [Choice]) {
        self.init(frame: frame)
        let face = trumpFaces["none"]
        let response = ""
        
        setChoices(choices)
        setView()
        addImageView()
        addResponseLabel()
        
        setResponseLabelText(response)
        setMyImageView(face!)
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * setView - sets up view style
     */
    func setView () {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.clear
    }
    
    /*
     * addImageView - adds the card center image (Trump face)
     */
    func addImageView () {
        setImageViewFrame()
        self.addSubview(imageView)
    }
    
    /*
     * setImageViewFrame - sets the card center image (Trump face)
     */
    func setImageViewFrame () {
        let imageWidth: CGFloat = 150
        let imageHeight = imageWidth
        let imageX = (self.frame.width / 2) - (imageWidth / 2)
        let imageY = (self.frame.height / 2) - (imageHeight / 2)
        
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
    }
    
    /*
     * setMyImageView - sets image
     * param {String} _image - image string name
     */
    func setMyImageView (_ _image: String) {
        imageView.image = UIImage(named: _image)
    }
    
    /*
     * addResponseLabel - adds the answer label
     */
    func addResponseLabel () {
        setResponseLabelFrame()
        self.addSubview(responseLabel)
    }
    
    /*
     * setResponseLabelFrame - sets the answer label frame
     */
    func setResponseLabelFrame () {
        let labelX: CGFloat = 30
        let labelY: CGFloat = 10
        let labelWidth: CGFloat = self.frame.width - ( labelX * 2)
        let labelHeight: CGFloat = self.frame.height / 4
        
        responseLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)

        responseLabel.textAlignment = .center
        responseLabel.textContainerInset = UIEdgeInsetsMake(20, 10, 10, 10)
        responseLabel.isEditable = false
        responseLabel.font = .systemFont(ofSize: 20)
        responseLabel.backgroundColor = UIColor.clear
        responseLabel.textColor = trumpRed
    }
    
    /*
     * setResponseLabelText - sets the answer label text
     * param {String} _response - choice response
     */
    func setResponseLabelText (_ _response:String) {
        responseLabel.text = _response
    }
    
    /*
     * setMode - sets the OverlayView's mode
     * param {OverlayViewMode} _mode - view mode
     */
    func setMode (_ _mode: OverlayViewMode) {
        
        // If mode is the same
        if self.mode == _mode {
            // Return
            return
        }
        
        // Otherwise
        // Set new mode
        self.mode = _mode
        
        // Check mode
        switch _mode {
        // If left mode
        case .Left:
            // Set image to left trump face
            let face = trumpFaces["left"]
            
            // Set response
            let response = leftChoice?.getResponse()
            
            setResponseLabelText(response!)
            setMyImageView(face!)
        
        // If left mode
        case .Right:
            // Set image to right trump face
            let face = trumpFaces["right"]
            // Set response
            let response = rightChoice?.getResponse()

            setResponseLabelText(response!)
            setMyImageView(face!)
            
        // Otherwise
        case .None:
            // Set face to default
            let face = trumpFaces["none"]
            let response = ""
            
            setResponseLabelText(response)
            setMyImageView(face!)
        }
    }
    
    /*
     * setChoices - sets the OverlayView's choices for left and right
     * param {[Choice]} _choices - choices
     */
    func setChoices (_ _choices: [Choice]) {
        self.leftChoice = _choices[0]
        self.rightChoice = _choices[1]
    }
}
