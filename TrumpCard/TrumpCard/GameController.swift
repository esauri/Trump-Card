//
//  GameController.swift
//  TrumpCard
//
//  Created by Erick Sauri on 11/3/16.
//  In part, adapted from cwRichardKim's TinderSimpleSwipeCards
//  Github: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//  Article: https://medium.com/@cwRichardKim/adding-tinder-esque-cards-to-your-iphone-app-4047967303d1#.m2w4za62z
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import UIKit
import AVFoundation

class GameController: UIView, DraggableViewDelegate, AudioDelegate {
    
    // Data File constants
    let DATA_FILE = "data"
    let DATA_FORMAT = "plist"
    
    let cardSwipeAudio = "cardSwipe"
    let loserAudio = "DJT-Loser"
    let winnerAudio = "DJT-MAGA"
    
    // Player
    var player: Trump?
    
    // Press Conference
    var pressConference = PressConference()
    
    var gameViewController: GameViewController!
    
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
    
    // Card constants
    var maximumNumberOfQuestions = 0
    let CARD_HEIGHT = CGFloat(380)
    let CARD_WIDTH = CGFloat(300)
    
    // UI constants
    var MARGIN = CGFloat(20)
    var BAR_HEIGHT = CGFloat(100)
    var BAR_HEIGHT_LARGE = CGFloat(100)
    var CARD_MARGIN_TOP = CGFloat(0)
    var CARD_MARGIN_LEFT = CGFloat(0)
    
    // UI constants
    let exitButton = UIButton()
    let messageButton = UIButton()
    let checkButton = UIButton()
    let xButton = UIButton()
    
    // UI Element constants
    let backgroundImage = UIImageView()
    let questionLabel = UILabel()
    let categoryLabel = UILabel()
    
    let demographicsBar = UIView()
    let trumpOMeterContainer = UIView()
    let navigationBar = UIView()
    
    var temperamentBar = UIProgressView()
    let trumpHappyImage = UIImageView()
    let trumpNeutralImage = UIImageView()
    let trumpMadImage = UIImageView()
    
    let scoreLabel = UILabel()
    
    var blocImage = UIImageView()
    var blocImages = [UIImageView()]
    let africanAmericanImage = UIImageView()
    let asianAmericanImage = UIImageView()
    let latinoAmericanImage = UIImageView()
    let whiteCollegeEducatedImage = UIImageView()
    let whiteNonCollegeEducatedImage = UIImageView()
    
    // Audio constants
    let FILE_FORMAT = "mp3"
    
    var audioPlayer: AVAudioPlayer?

    // Card information
    var loadedCards: [DraggableView] = []
    var allCards: [DraggableView] = []
    var cardsLoadedIndex = 0
    var numLoadedCardsCap = 0
    
    // Colors
    let trumpRed = UIColor(red: 0.74, green: 0.32, blue: 0.32, alpha: 1.0)
    let trumpGold = UIColor(red: 0.95, green: 0.79, blue: 0.30, alpha: 1.0)
    let trumpBoldRed = UIColor(red: 0.69, green: 0.24, blue: 0.22, alpha: 1.0)
    
    let trumpRedLowAlpha = UIColor(red: 0.74, green: 0.32, blue: 0.32, alpha: 0.75)
    let trumpGoldLowAlpha = UIColor(red: 0.95, green: 0.79, blue: 0.30, alpha: 0.75)
    let trumpBoldRedLowAlpha = UIColor(red: 0.69, green: 0.24, blue: 0.22, alpha: 0.75)
    
    // Trump temper
    let trumpTemperBoilingPoint = 90
    
    /*
     * #MARK: Initializers
     * Initializers
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * init - GameController initializer
     * param {CGRect} frame - view frame
     */
    override init (frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        
        // Calculate sizes for "responsiveness"
        calculateSizes(frame)
    }
    
    /*
     * #MARK: UI Setup
     * UI Setup
     */
    
    /*
     * calculateSizes - calculates the size of elements based on phone
     * param {CGRect} frame - view frame
     */
    func calculateSizes (_ _frame: CGRect) {
        let topMargin = getStatusBarHeight()

        BAR_HEIGHT_LARGE = (_frame.size.height / 12) + topMargin
        
        if BAR_HEIGHT_LARGE > 100 {
            BAR_HEIGHT_LARGE = 100
        }
        
        BAR_HEIGHT = BAR_HEIGHT_LARGE - (BAR_HEIGHT_LARGE / 3)
        
        MARGIN = ((_frame.size.width - CARD_WIDTH) / 2) - 10
        
        if MARGIN < 10 {
            MARGIN = 10
        }
        
        CARD_MARGIN_TOP = (_frame.size.height - CARD_HEIGHT) / 2
        CARD_MARGIN_LEFT = (_frame.size.width - CARD_WIDTH) / 2
    }
    
    /*
     * setupView - calls functions to setup the view
     */
    func setupView () {
        self.backgroundColor = trumpRed
        addBlockImageViews()
        setNavigationBar()
        addTemperamentBar()
        addExitButton()
        addQuestionLabel()
        addCategoryLabel()
        addScoreLabel()
        addXButton()
        addCheckButton()
    }
    
    /*
     * setBackgroundImage - sets background image
     * param {CGRect} _frame - view frame
     * not used
     */
    func setBackgroundImage (_ _frame: CGRect) {
        self.backgroundColor = trumpRed
        backgroundImage.frame = _frame
        backgroundImage.image = UIImage(named: "TrumpCardBackground")
        self.addSubview(backgroundImage)
    }
    
    /*
     * setOverlayBlur - sets overlay over background image
     * not used
     */
    func setOverlayBlur () {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    /*
     * addBlockImageViews - adds the image for the demographic faces
     */
    func addBlockImageViews () {
        let count = 5
        let imageWidth = 40
        let imageHeight = imageWidth
        let imageY = 10
        var imageX = Int(self.frame.size.width / 2) - (imageWidth * count / 2)
        
        // AsAm
        asianAmericanImage.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        asianAmericanImage.image = UIImage(named: "asianAmericanNeutral")
        asianAmericanImage.alpha = 0
        self.addSubview(africanAmericanImage)
        
        imageX = imageX + imageWidth
        
        // WC
        whiteCollegeEducatedImage.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        whiteCollegeEducatedImage.image = UIImage(named: "whiteCollegeEducatedNeutral")
        whiteCollegeEducatedImage.alpha = 0
        self.addSubview(asianAmericanImage)
        
        imageX = imageX + imageWidth

        
        //LatAm
        latinoAmericanImage.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        latinoAmericanImage.image = UIImage(named: "latinoAmericanNeutral")
        latinoAmericanImage.alpha = 0
        self.addSubview(latinoAmericanImage)

        imageX = imageX + imageWidth

        
        //AfAm
        africanAmericanImage.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        africanAmericanImage.image = UIImage(named: "africanAmericanNeutral")
        africanAmericanImage.alpha = 0
        self.addSubview(whiteCollegeEducatedImage)

        imageX = imageX + imageWidth
        
        //WNC
        whiteNonCollegeEducatedImage.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        whiteNonCollegeEducatedImage.image = UIImage(named: "whiteNonCollegeEducatedNeutral")
        whiteNonCollegeEducatedImage.alpha = 0
        self.addSubview(whiteNonCollegeEducatedImage)
    }
    
    /*
     * setBlockImages - sets the image for the demographic faces 
     * based on their reaction to the answer
     * param {[String: Int]} _reactions - reactions of demographics
     */
    func setBlockImages (_ _reactions: [String: Int]) {
        var tempArray: [String] = []
        
        for (bloc, num) in _reactions {
            var tempStr = bloc
            
            if num > 2 {
                tempStr += "Happy"
            }
            else if num > -2 {
                tempStr += "Neutral"
            }
            else {
                tempStr += "Mad"
            }
            
            tempArray.append(tempStr)
        }
        
        self.asianAmericanImage.image = UIImage(named: tempArray[1])
        self.whiteCollegeEducatedImage.image = UIImage(named: tempArray[3])
        self.latinoAmericanImage.image = UIImage(named: tempArray[2])
        self.africanAmericanImage.image = UIImage(named: tempArray[0])
        self.whiteNonCollegeEducatedImage.image = UIImage(named: tempArray[4])
        
        beginBlocAnimations()
    }
    
    /*
     * beginBlocAnimations - begins the animation for the demographic faces
     */
    func beginBlocAnimations () {
        let centerY = CGFloat(120)
        
        self.africanAmericanImage.alpha = 1
        self.asianAmericanImage.alpha = 1
        self.latinoAmericanImage.alpha = 1
        self.whiteCollegeEducatedImage.alpha = 1
        self.whiteNonCollegeEducatedImage.alpha = 1
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            // Animation
            self.africanAmericanImage.center.y = centerY
            self.asianAmericanImage.center.y = centerY
            self.latinoAmericanImage.center.y = centerY
            self.whiteCollegeEducatedImage.center.y = centerY
            self.whiteNonCollegeEducatedImage.center.y = centerY
        }, completion: { (finished: Bool) in
            self.resetBlockAnimations(0.4)
        })
    }
    
    /*
     * resetBlockAnimations - resets the animation for the demographic faces
     * param {Double} _delay - animation delay
     */
    func resetBlockAnimations (_ _delay: Double) {
        let centerY = CGFloat(25)
        
        UIView.animate(withDuration: 0, delay: _delay, animations: {
            // Animation
            self.africanAmericanImage.alpha = 0
            self.asianAmericanImage.alpha = 0
            self.latinoAmericanImage.alpha = 0
            self.whiteCollegeEducatedImage.alpha = 0
            self.whiteNonCollegeEducatedImage.alpha = 0
            
            self.africanAmericanImage.center.y = centerY
            self.asianAmericanImage.center.y = centerY
            self.latinoAmericanImage.center.y = centerY
            self.whiteCollegeEducatedImage.center.y = centerY
            self.whiteNonCollegeEducatedImage.center.y = centerY
        }, completion:nil)
    }
    
    /*
     * addExitButton - adds exit button to the view
     */
    func addExitButton () {
        let btnWidth: CGFloat = 30
        let btnX: CGFloat = self.frame.size.width - btnWidth - 10
        let btnY: CGFloat = self.frame.size.height - BAR_HEIGHT_LARGE
        
        exitButton.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: BAR_HEIGHT_LARGE)
        exitButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        exitButton.addTarget(self, action: #selector(GameController.exitButtonClicked), for: .touchUpInside)
        addSubview(exitButton)
    }
    
    /*
     * addQuestionLabel - adds question label to the view
     */
    func addQuestionLabel () {
        let topMargin = BAR_HEIGHT + BAR_HEIGHT_LARGE
        let maxHeight = ((self.frame.size.height - CARD_HEIGHT) / 2) - topMargin + BAR_HEIGHT_LARGE
        
        questionLabel.frame = CGRect(x: MARGIN, y: topMargin, width: self.frame.width - (MARGIN * 2), height: maxHeight)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.textColor = UIColor.black
        addSubview(questionLabel)
    }
    
    /*
     * setQuestionLabelText - sets question label text
     * param {String} _questionText - question text
     */
    func setQuestionLabelText (_ _questionText: String) {
        self.questionLabel.text = _questionText
    }
    
    /*
     * addCategoryLabel - adds category label to the view
     */
    func addCategoryLabel () {
        let topMargin = CARD_MARGIN_TOP + CARD_HEIGHT + BAR_HEIGHT_LARGE
        let maxHeight = self.frame.size.height - topMargin
        
        categoryLabel.frame = CGRect(x: MARGIN, y: topMargin, width: self.frame.width - (MARGIN * 2), height: maxHeight)
        categoryLabel.textAlignment = .center
        categoryLabel.numberOfLines = 1
        categoryLabel.textColor = UIColor.black
        addSubview(categoryLabel)
    }
    
    /*
     * setCategoryLabelText - sets category label text
     * param {String} _categoryText - category text
     */
    func setCategoryLabelText (_ _categoryText: String) {
        self.categoryLabel.text = _categoryText
    }
    
    /*
     * addXButton - adds X button to the view
     */
    func addXButton () {
        let btnX = MARGIN * 2
        let btnY = CARD_MARGIN_TOP + BAR_HEIGHT_LARGE + CARD_HEIGHT + 10
        
        xButton.frame = CGRect(x: btnX, y: btnY, width: BAR_HEIGHT, height: BAR_HEIGHT)
        xButton.setImage(UIImage(named: "xButton"), for: .normal)
        xButton.addTarget(self, action: #selector(GameController.swipeLeft), for: .touchUpInside)
        addSubview(xButton)
    }
    
    /*
     * addCheckButton - adds check button to the view
     */
    func addCheckButton () {
        let btnX = self.frame.width - BAR_HEIGHT - ( MARGIN * 2 )
        let btnY = CARD_MARGIN_TOP + BAR_HEIGHT_LARGE + CARD_HEIGHT + 10
        
        checkButton.frame = CGRect(x: btnX, y: btnY, width: BAR_HEIGHT, height: BAR_HEIGHT)
        checkButton.setImage(UIImage(named: "checkButton"), for: .normal)
        checkButton.addTarget(self, action: #selector(GameController.swipeRight), for: .touchUpInside)
        addSubview(checkButton)
    }
    
    /*
     * setDemographicsBar - adds demographics bar to the view
     */
    func setDemographicsBar () {
        demographicsBar.frame = CGRect(x: 0, y: self.frame.size.height - BAR_HEIGHT_LARGE, width: self.frame.size.width, height: BAR_HEIGHT_LARGE)
        demographicsBar.backgroundColor = UIColor.lightGray
        addSubview(demographicsBar)
    }
    
    /*
     * addTemperamentBar - adds Trump-o-meter progressbar to the view
     */
    func addTemperamentBar () {
        let imageHeight: CGFloat = 32
        let imageWidth: CGFloat = imageHeight
        let imageY: CGFloat = BAR_HEIGHT_LARGE - (imageHeight / 2)
        let barWidth: CGFloat = self.frame.width - 65
        let barHeight: CGFloat = 10
        let barX: CGFloat = 50
        let barY: CGFloat = BAR_HEIGHT_LARGE - 1
    
        temperamentBar = UIProgressView(progressViewStyle: .default)
        temperamentBar.frame = CGRect(x: barX, y: barY, width: barWidth, height: barHeight)
        temperamentBar.progress = Float(player!.getTemperament())
        temperamentBar.trackTintColor = trumpRedLowAlpha
        temperamentBar.progressTintColor = trumpGold
        temperamentBar.progress = 0.0
        addSubview(temperamentBar)
        
        trumpHappyImage.frame = CGRect(x: 20, y: imageY, width: imageWidth, height: imageHeight)
        trumpHappyImage.image = UIImage(named: "trumpHappy")
        trumpHappyImage.contentMode = .scaleAspectFit
        addSubview(trumpHappyImage)
        
        trumpMadImage.frame = CGRect(x: self.frame.width - imageWidth - 15, y: imageY, width: imageWidth, height: imageHeight)
        trumpMadImage.image = UIImage(named: "trumpMad")
        trumpMadImage.contentMode = .scaleAspectFit
        addSubview(trumpMadImage)
    }
    
    /*
     * setTemperamentProgress - sets the Trump-o-meter progress
     */
    func setTemperamentProgress () {
        let progressPercent: Float = Float(player!.getTemperament()) / 100.0

        temperamentBar.progress = progressPercent
    }
    
    /*
     * addScoreLabel - adds score label to the view
     */
    func addScoreLabel() {
        scoreLabel.frame = CGRect(x: 0, y: 20, width: self.frame.size.width, height: BAR_HEIGHT)
        scoreLabel.textColor = trumpGold
        scoreLabel.text = "Swipe the Trump Card left or right to begin."
        scoreLabel.numberOfLines = 0
        scoreLabel.textAlignment = .center
        addSubview(scoreLabel)
    }
    
    /*
     * setScoreText - sets score text
     */
    func setScoreText () {
        self.scoreLabel.text = "Vote Percentage: \(player!.getScore())%"
    }
    
    /*
     * setNavigationBar - adds top bar
     */
    func setNavigationBar () {
        navigationBar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: BAR_HEIGHT_LARGE)
        
        navigationBar.backgroundColor = trumpBoldRed
        addSubview(navigationBar)
    }
    
    /*
     * #MARK: Card helpers
     * Card helpers
     */
    
    /*
     * getMaxiumumNumberOfQuestions - returns the max number of questions
     * return {Int} maximumNumberOfQuestions - maximum number of questions
     */
    func getMaxiumumNumberOfQuestions () -> Int {
        return maximumNumberOfQuestions
    }
    
    /*
     * setMaxiumumNumberOfQuestions - sets the max number of questions
     * param {Int} _value - maximum number of questions
     */
    func setMaxiumumNumberOfQuestions (_ _value: Int) {
        maximumNumberOfQuestions = _value
    }
    
    /*
     * setLoadedCardsCap - sets the max number of cards we can load
     */
    func setLoadedCardsCap () {
        numLoadedCardsCap = 0
        
        if questions.count > maximumNumberOfQuestions {
            numLoadedCardsCap = maximumNumberOfQuestions
        }
        else {
            numLoadedCardsCap = questions.count
        }
    }
    
    /*
     * stillQuestionsToLoad - returns if we still have questions to load
     * return {Bool}
     */
    func stillQuestionsToLoad () -> Bool {
        return questions.count > 0
    }
    
    /*
     * moreCardsToLoad - returns if we still have cards to load
     * return {Bool}
     */
    func moreCardsToLoad () -> Bool {
        return cardsLoadedIndex < allCards.count
    }
    
    /*
     * stillCardsToShow - returns if we still have cards to display
     * return {Bool}
     */
    func stillCardsToShow () -> Bool {
        return loadedCards.count > 0
    }
    
    /*
     * #MARK: Card Creation
     * Card Creation
     */
    
    /*
     * createCards - creates cards
     */
    func createCards () {
        if numLoadedCardsCap > 0 {
            
            let cardFrame = CGRect(x: CARD_MARGIN_LEFT, y: CARD_MARGIN_TOP + BAR_HEIGHT_LARGE, width: CARD_WIDTH, height: CARD_HEIGHT)
            
            for _ in 0..<numLoadedCardsCap {
                let newCard = DraggableView(frame: cardFrame)
                newCard.delegate = self
                allCards.append(newCard)
            }
        }
    }
    
    /*
     * displayCards - displays cards
     */
    func displayCards () {
        for i in 0..<numLoadedCardsCap {
            loadCardAt(i)
        }
    }
    
    /*
     * loadNextCard - loads next card
     */
    func loadNextCard () {
        loadCardAt(cardsLoadedIndex)
    }
    
    /*
     * loadCardAt - loads card
     * param {Int} _index - index of card to load
     */
    func loadCardAt (_ _index: Int) {
        let currentCard = allCards[_index]
        
        loadedCards.append(currentCard)
        
        if loadedCards.count > 1 {
            let previousCard = loadedCards.count - 1
            let antecedentPreviousCard = loadedCards.count - 2
            
            insertSubview(loadedCards[previousCard], belowSubview: loadedCards[antecedentPreviousCard])
        }
            
        else {
            addSubview(loadedCards[0])
        }
        
        cardsLoadedIndex += 1
    }
    
    /*
     * #MARK: Current Card
     * Current Card
     */
    
    /*
     * displayCurrentCard - displays current card
     */
    func displayCurrentCard () {
        let currentCard = loadedCards[0]
        var questionResponses: [Choice] = []
        let question = questions[0]
        let choiceIndexes = question.getChoiceIds()
        let questionResponseLeft = choices[choiceIndexes["left"]!]
        let questionResponseRight = choices[choiceIndexes["right"]!]
        
        questionResponses.append(questionResponseLeft)
        questionResponses.append(questionResponseRight)
        
        setQuestionLabelText(question.getBlurb())
        setCategoryLabelText(question.getCategory())
        currentCard.loadView(question: question, choices: questionResponses)
    }

    /*
     * #MARK: Swipe Interaction
     * Swipe Interactions
     */
    
    /*
     * exitButtonClicked - exit button was clicked
     */
    func exitButtonClicked () {
        let alert = UIAlertController(title: "Return to Home", message: "Do you wish to return to home? If you exit from the game all of your data will be lost!", preferredStyle: .alert)
        
        let exitAction = UIAlertAction(title: "Exit Game", style: .destructive, handler: { (action) in
            self.gameOver()
        })
        
        let cancelAction = UIAlertAction(title: "Keep Playing", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(exitAction)
        
        gameViewController.present(alert, animated: true, completion: nil)
    }
    
    /*
     * exitButtonClicked - displays alert for when trump is pissed
     */
    func pissedTrump () {
        let alert = UIAlertController(title: "Unhinged", message: "Trump can't handle controlled so much. Reduce Trump's anger by swiping right a couple of times. Use the bar above the question to gauge his temperament.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        gameViewController.present(alert, animated: true, completion: nil)

    }
    /*
     * swipeLeft - swipes a card left
     */
    func swipeLeft () {
        let dragView = loadedCards[0]

        // If Trump is pacified
        if player!.getTemperament() < trumpTemperBoilingPoint {
            dragView.leftClickAction()
        }
            // Otherwise Trump is pissed
        else {
            // Show alert
            pissedTrump()
        }
    }
    
    /*
     * swipeRight - swipes a card right
     */
    func swipeRight () {
        let dragView = loadedCards[0]
        
        dragView.rightClickAction()
    }
    
    /*
     * processCardSwipe - process for when a card has been swiped
     * param {String} _direction - direction a card was swiped in
     */
    func processCardSwipe (_ _direction: String) {
        
        resetBlockAnimations(0.2)
        
        // using direction get choice id
        let choiceId = questions[0].getChoiceIdOf(_direction)
        
        // using choice id get choice
        let choice = choices[choiceId]
        
        switch _direction {
        case "left":
            playerSwipedLeft(choice)
        case "right":
            playerSwipedRight(choice)
        default:
            break
        }
        
        afterCardSwipe()
    }
    
    /*
     * afterCardSwipe - process for when a card has been swiped
     */
    func afterCardSwipe () {
        // Remove current card and question
        loadedCards.remove(at: 0)
        questions.remove(at: 0)
        setQuestionLabelText("")
        setCategoryLabelText("")
        
        // If we still have cards to show
        if stillCardsToShow() {
            // Display them
            displayCurrentCard()
        }
        // Otherwise
        else {
            // End the game
            gameOver()
        }
        
        if moreCardsToLoad() {
            loadNextCard()
        }
    }

    /*
     * cardSwipedLeft - processes the left swipe
     * param {DraggableView} _card - card
     */
    func cardSwipedLeft (_ _card: DraggableView) {
        // If Trump is pacified
        if player!.getTemperament() < trumpTemperBoilingPoint {
            // animate card to the left
            _card.animateCardToTheLeft()
            
            // Process card swipe
            processCardSwipe("left")
        }
        // Otherwise Trump is pissed
        else {
            // Animate card back
            _card.animateCardBack()
            pissedTrump()
        }
    }
    
    /*
     * cardSwipedRight - processes the right swipe
     * param {DraggableView} _card - card
     */
    func cardSwipedRight (_ _card: DraggableView) {
        processCardSwipe("right")
    }
    
    /*
     * #MARK: Game
     */
    
    /*
     * gameStart - loads everything and starts the game
     */
    func gameStart () {
        // If some questions have been removed
        if questions.count == 0 || questions.count != pressConference.allQuestions.count {
            // Reset questions
            questions = pressConference.allQuestions
        }
        // Start the player
        player = Trump(numberOfLevels: questions.count)
        
        setupView()
        setMaxiumumNumberOfQuestions(questions.count)
        setLoadedCardsCap()
        createCards()
        displayCards()
        displayCurrentCard()
    }
    
    /*
     * gameOver - method for ending the game
     */
    func gameOver () {
        var electionResultTitleText = ""
        var electionResultBlurbText = ""
        
        if player!.getScore() > 50 {
            electionResultTitleText = "MAKE AMERICA GREAT AGAIN!"
            electionResultBlurbText = "Congratulations, you are now President-Elect! The responsability of leading the United States of America now rests in your shoulders. May God have mercy on us all."
            playTrumpAudioClip(winnerAudio)
        }
        else {
            electionResultTitleText = "SAD!"
            electionResultBlurbText = "The haters and losers have deemed you unworthy of being President. Go hang your head in shame and don't talk to me. I like people who aren't losers. What a waste of time and energy!"
            playTrumpAudioClip(loserAudio)
        }
        
        let alert = UIAlertController(title: electionResultTitleText, message: electionResultBlurbText, preferredStyle: .alert)
        
        let exitAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            if let gameView = self.gameViewController.view.viewWithTag(45) {
                gameView.removeFromSuperview()
            }
        })
        
        alert.addAction(exitAction)
        
        gameViewController.present(alert, animated: true, completion: nil)
    }
    
    /*
     * playerSwipedLeft - method for when player swipes left
     * param {Choice} _choice - choice chosen
     */
    func playerSwipedLeft (_ _choice: Choice) {
        // Enrage Donald J. Trump
        player!.enrageTrump()
        setTemperamentProgress()

        setBlockImages(_choice.getElectorateEffect())

        player!.recalculateScore(_choice)
        setScoreText()

        // Play audio
        if _choice.getAudioPath() != "" {
            playTrumpAudioClip(_choice.getAudioPath())
        }
        else {
            playTrumpAudioClip(cardSwipeAudio)
        }
    }
    
    /*
     * playerSwipedRight - method for when player swipes right
     * param {Choice} _choice - choice chosen
     */
    func playerSwipedRight (_ _choice: Choice) {
        // Alleviate Donald J. Trump
        player!.alleviateTrump()
        setTemperamentProgress()

        setBlockImages(_choice.getElectorateEffect())

        // Calculate DJT's favorability with voting blocks
        for (group, value) in _choice.getElectorateEffect() {
            player!.calculateFavorablesOfGroup(group, value)
            player!.calculateBlocVoteOf(group)
        }
        
        player!.calculateScore()
        setScoreText()
        
        // Play audio
        if _choice.getAudioPath() != "" {
            playTrumpAudioClip(_choice.getAudioPath())
        }
        else {
            playTrumpAudioClip(cardSwipeAudio)
        }
    }
    
    /*
     * #MARK: Audio
     * Audio
     */
    
    /*
     * playTrumpAudioClip - delegate method for playing a sound file
     * param {String} - audio file name
     */
    func playTrumpAudioClip(_ _audioFile: String) {
        if _audioFile != "" {
            let soundFilePath = Bundle.main.path(forResource: _audioFile, ofType: FILE_FORMAT)!
            let fileUrl = URL(fileURLWithPath: soundFilePath)
            
            do {
                let audio = try AVAudioPlayer(contentsOf: fileUrl)
                audioPlayer = audio
                audio.play()
            }
            catch _ as NSError{
            }
        }
    }
    
    /*
     * #MARK: Helper Methods
     * Helper Methods
     */
    
    /*
     * getStatusBarHeight - gets the height of the status bar
     * return {CGFloat} - status bar height
     */
    func getStatusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    
}
