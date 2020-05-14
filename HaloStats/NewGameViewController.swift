//
//  NewGameViewController.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/11/20.
//  Copyright © 2020 CS50. All rights reserved.
//
import Foundation
import UIKit

var testing: String = "" // TESTING

class NewGameViewController: UIViewController {

    @IBOutlet var contentTextField: UITextField!
    
    @IBOutlet var testField: UITextField! // TESTING
    
    var game: Game? = nil

    @IBAction func deleteGame() {
        let _ = GameManager.shared.delete(game: game!)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextField.text = game!.content
        
        testField.text = testing // TESTING
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        game!.content = contentTextField.text ?? ""
        GameManager.shared.saveGame(game: game!)
        testing = testField.text ?? "" // TESTING
    }
}
