//
//  StatsViewController.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/16/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController {
        
    @IBOutlet var killsField: UITextField!
    @IBOutlet var assistsField: UITextField!
    @IBOutlet var deathsField: UITextField!
    @IBOutlet var headshotsField: UITextField!
    @IBOutlet var accuracyField: UITextField!
    
    var name: String = "no name"
    var ref:DatabaseReference?
    
    func retrieveData (childName: String, fieldName: UITextField) {
        ref?.child("games").child(name.lowercased()).child(childName).observe(.value, with: { snapshot in
            let stat = snapshot.value
            fieldName.text = String(describing: stat!)
            if fieldName.text == "<null>" {
                fieldName.text = ""
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        retrieveData(childName: "Kills", fieldName: killsField)
        retrieveData(childName: "Assists", fieldName: assistsField)
        retrieveData(childName: "Deaths", fieldName: deathsField)
        retrieveData(childName: "Headshots", fieldName: headshotsField)
        retrieveData(childName: "Accuracy", fieldName: accuracyField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let kills = Int(killsField.text ?? "")
        let assists = Int(assistsField.text ?? "")
        let deaths = Int(deathsField.text ?? "")
        let headshots = Int(headshotsField.text ?? "")
        let accuracy = Double(accuracyField.text ?? "")
        ref?.child("games").child(name.lowercased()).child("Kills").setValue(kills)
        ref?.child("games").child(name.lowercased()).child("Assists").setValue(assists)
        ref?.child("games").child(name.lowercased()).child("Deaths").setValue(deaths)
        ref?.child("games").child(name.lowercased()).child("Headshots").setValue(headshots)
        ref?.child("games").child(name.lowercased()).child("Accuracy").setValue(accuracy)
        
        // 1
        let user = Auth.auth().currentUser
        let onlineRef = Database.database().reference(withPath: "online/\(user?.uid)")

        // 2
        onlineRef.removeValue { (error, _) in

          // 3
          if let error = error {
            print("Removing online failed: \(error)")
            return
          }

          // 4
          do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
          } catch (let error) {
            print("Auth sign out failed: \(error)")
          }
        }
    }
}
