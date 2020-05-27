//
//  SummaryViewController.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/27/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit
import Firebase

class SummaryViewController: UIViewController {

    @IBOutlet var killsLabel: UILabel!
    @IBOutlet var assistsLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var headshotsLabel: UILabel!
    @IBOutlet var accuracyLabel: UILabel!
    
    var names: [String] = []
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameCount: Int = names.count
        var avg: Float = 0
        var loop: Int = 0
        ref = Database.database().reference()
        
        func summaryCalc (childName: String, labelName: UILabel!) {
            for name in names {
                ref?.child("games").child(name.lowercased()).child(childName).observe(.value, with: { snapshot in
                    let stat = snapshot.value
                    avg += Float(String(describing: stat!)) ?? 0.0
                    loop += 1
                    if loop == nameCount {
                        avg /= Float(nameCount)
                        let roundedAvg = String(format: "%.2f", avg)
                        labelName.text = "\(childName): \(roundedAvg)"
                        if labelName.text == "<null>" {
                            labelName.text = ""
                        }
                        avg = 0
                        loop = 0
                    }
                })
            }
        }
        
        summaryCalc(childName: "Kills", labelName: killsLabel)
        summaryCalc(childName: "Assists", labelName: assistsLabel)
        summaryCalc(childName: "Deaths", labelName: deathsLabel)
        summaryCalc(childName: "Headshots", labelName: headshotsLabel)
        summaryCalc(childName: "Accuracy", labelName: accuracyLabel)
    }
}
