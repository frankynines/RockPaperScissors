//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Franky Aguilar on 8/1/16.
//  Copyright © 2016 99centbrains. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController  {
    
    @IBOutlet weak var ibo_myscore:UILabel!
    var summary = "Game On"
    var battleView:BattleViewController!
    
    var pitcher:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let score = UserDefaults.standard.integer(forKey: "wins_key")
        ibo_myscore.text = "My Wins: \(score)"
        
    }
    
    @IBAction func iba_choseWeapon(sender:UIButton){
        
        self.composeMessage(conversation: self.activeConversation!, type: sender.tag)
        
    }
    
    func composeMessage(conversation:MSConversation, type:Int){
        
        let messagelayout = MSMessageTemplateLayout()
        messagelayout.caption = "I challenge you"
        messagelayout.subcaption = "Rock Paper Scissors"
        messagelayout.trailingCaption = self.summary
        messagelayout.image = UIImage(named: "rock-paper-scissors.jpg")

        
        var components = URLComponents()
        
        
        let item = URLQueryItem(name: "code", value: "\(type)")
        
        // put it into an array of query items
        var items = [URLQueryItem]()
        items.append(item)
        components.queryItems = items
        
        
        guard let conversation = activeConversation else {
            fatalError("Expected a Conversation")
        }
        
        let session = conversation.selectedMessage?.session ?? MSSession()
        
        let message = MSMessage(session: session)
            message.shouldExpire = true
            message.layout = messagelayout
            message.summaryText = "Game Over"
            message.url = components.url!
        //message.susImage = UIImage(named: "model5.png")
        
        self.activeConversation?.insert(message, completionHandler: { (err:NSError?) in
            //
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Conversation Handling
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print("Tapped Transition")
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    
    }
    
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        super.willBecomeActive(with: conversation)
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        
        
        
        if presentationStyle == .compact {
            // Show a list of previously created ice creams.
            //
        } else {
            
            
            let message = conversation.selectedMessage
            guard let messageURL = message?.url else { return }
            guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return }
            
            print("URL Components", urlComponents)
            print("queryItems", queryItems)
            
            var battleTag = 0
            for item in queryItems {
                print("Received \(item.name) with value \(item.value)")
                battleTag = Int(item.value!)!
            }
            
            
            battleView = self.storyboard?.instantiateViewController(withIdentifier: "sb_BattleViewController") as! BattleViewController
            battleView.parentVC = self
            self.view.addSubview(battleView.view)
            
            battleView.view.frame = self.view.frame
            battleView.battleTag = battleTag
            
            
 
        }
        
        
    }
    
    func endGame(status:String){
        
        self.summary = status
        
    
        UIView.animate(withDuration: 0.5, animations: {
            self.battleView.view.alpha = 0
            self.requestPresentationStyle(.compact)
            //
        }) { (done:Bool) in
            self.battleView.view.removeFromSuperview()
            self.battleView = nil
        }
        
        
    }
    
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}



