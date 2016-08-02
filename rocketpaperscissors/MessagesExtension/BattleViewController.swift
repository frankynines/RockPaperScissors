//
//  BattleViewController.swift
//  rocketpaperscissors
//
//  Created by Franky Aguilar on 8/1/16.
//  Copyright © 2016 99centbrains. All rights reserved.
//

import Foundation
import UIKit

class BattleViewController: UIViewController {
    
    var battleTag:Int!
    @IBOutlet weak var ibo_slotView:UIImageView!
    var parentVC:MessagesViewController!
    
    var statusLabel:UILabel!
    
    var weapons = [UIImage(named:"rock.png")!,
                   UIImage(named:"paper.png")!,
                   UIImage(named:"scissors.png")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func iba_choseWeapon(sender:UIButton){
        
        if sender.tag == 0 {//rock
            
            switch battleTag {
            case 0:
                print("Draw")
                self.show_draw()
            case 1:
                print("Lose")
                self.show_loss()
            case 2:
                print("Win")
                self.show_win()
            default:
                print("DRAW")
            }
            
        }
        
        if sender.tag == 1{//paper

            switch battleTag {
            case 0:
                print("Win")
                self.show_win()
            case 1:
                print("Draw")
                self.show_draw()
            case 2:
                print("Lose")
                self.show_loss()
            default:
                print("DRAW")
            }
            
        }
        
        if sender.tag == 2{//scissors

            switch battleTag {
            case 0:
                print("Lose")
                self.show_loss()
            case 1:
                print("Win")
                self.show_win()
            case 2:
                print("Draw")
                self.show_draw()
            default:
                print("DRAW")
            }
            
        }
        
        ibo_slotView.stopAnimating()
        ibo_slotView.image = weapons[battleTag]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ibo_slotView.animationImages = weapons
        ibo_slotView.animationDuration = 0.25
        ibo_slotView.animationRepeatCount = 0
        ibo_slotView.startAnimating()
        
        
        statusLabel = UILabel(frame: self.view.frame)
        statusLabel.font = UIFont(name: "Helvetica", size: 82)
        self.view.addSubview(statusLabel)
        statusLabel.alpha = 0
        statusLabel.textAlignment = .center
    }
    
    
    func show_win(){
        
        var score = UserDefaults.standard.integer(forKey: "wins_key")
        score += 1
        UserDefaults.standard.set(score, forKey: "wins_key")

        
        statusLabel.text = "WIN"
        UIView.animate(withDuration: 0.5, animations: { 
            //
            self.statusLabel.alpha = 1
        }) { (done:Bool) in
            self.parentVC.endGame(status:"I Win")
        }
        
        
    }
    
    func show_draw(){
        
        statusLabel.text = "Draw"
        UIView.animate(withDuration: 0.5, animations: {
            //
            self.statusLabel.alpha = 1
        }) { (done:Bool) in
            self.parentVC.endGame(status:"I'ts a Draw")
        }
        
        
        
    }
    
    func show_loss(){
        
        var score = UserDefaults.standard.integer(forKey: "wins_key")
        if score <= 0{
            score = 0
        } else  {
            score -= 1
        }
        
        UserDefaults.standard.set(score, forKey: "wins_key")
        
        statusLabel.text = "Loss"
        UIView.animate(withDuration: 0.5, animations: {
            //
            self.statusLabel.alpha = 1
        }) { (done:Bool) in
            self.parentVC.endGame(status:"You Beat Me!")
        }
        
        
        
        
  
    }
}
