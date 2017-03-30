//
//  QuoteViewController.swift
//  TrumpCard
//
//  Created by Erick Sauri on 12/10/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import UIKit
import AVFoundation

class QuoteViewController: UITableViewController, AudioDelegate {
    
    // Section Constants
    let RESPONSE_SECTION = 0
    let QUOTE_SECTION = 1
    let REFERENCE_SECTION = 2
    let AUDIO_SECTION = 3
    
    // Colors
    let trumpRed = UIColor(red: 0.74, green: 0.32, blue: 0.32, alpha: 1.0)
    let trumpGold = UIColor(red: 0.95, green: 0.79, blue: 0.30, alpha: 1.0)
    let trumpBoldRed = UIColor(red: 0.69, green: 0.24, blue: 0.22, alpha: 1.0)
    
    // Audio constants
    let FILE_FORMAT = "mp3"
    var audioPlayer: AVAudioPlayer?
    
    // Quote
    var quote: Choice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background
        self.view.backgroundColor = trumpRed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // If quote has an audio path
        if quote.getAudioPath() != "" {
            // Return 4 sections
            return 4
        }
            
        // Otherwise
        else {
            // Return 3 sections
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return 1 row
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Make a label
        let label: UILabel = UILabel()
        
        // Check the section and apply corresponding title
        switch section {
        case RESPONSE_SECTION:
            label.text = "Response"
        case QUOTE_SECTION:
            label.text = "Trump Quote"
        case REFERENCE_SECTION:
            label.text = "Reference"
        case AUDIO_SECTION:
            label.text = "Audio"
        default:
            break
        }
        
        // Make label style consistent with rest of the app
        label.textColor = trumpGold
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        
        // Return our label
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        // If no cell make one
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        
        // Check the section and apply corresponding text to label
        switch indexPath.section {
        case RESPONSE_SECTION:
            cell?.textLabel?.text = quote.getResponse()
        case QUOTE_SECTION:
            cell?.textLabel?.text = quote.getQuote()
        case REFERENCE_SECTION:
            cell?.textLabel?.text = quote.getReference()
        case AUDIO_SECTION:
            cell?.textLabel?.text = "Listen"
        default:
            break
        }
        
        // Change cell style to match app
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.textAlignment = .center
        cell?.backgroundColor = trumpRed
        cell?.textLabel?.textColor = trumpGold
        cell?.textLabel?.highlightedTextColor = trumpRed
        
        // Return cell
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Cell height var
        var height: CGFloat?
        
        // Check the section and apply correct height
        switch indexPath.section {
        case QUOTE_SECTION:
            height = 244.0
        case REFERENCE_SECTION:
            height = 122.0
        default:
            height = 61.0
        }
        
        // Return height
        return height!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check the section
        switch indexPath.section {
        // If reference section was tapped
        case REFERENCE_SECTION:
            // If quote is an url
            if (quote.getReference().range(of: "http") != nil) {
                // Get that url
                let url = URL(string: quote.getReference())
                // Open that url in a browser
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        // If audio section was tapped
        case AUDIO_SECTION:
            // Play that audio
            playTrumpAudioClip(quote.getAudioPath())
        default:
            break
        }
        
        // Deselect cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // audio delegate
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
}
