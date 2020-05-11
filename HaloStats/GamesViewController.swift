//
//  GamesViewController.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/11/20.
//  Copyright © 2020 CS50. All rights reserved.
//
import Foundation
import UIKit

class GamesViewController: UITableViewController {
    
    var games: [Game] = []
    
    
    @IBAction func createNote() {
        let _ = GameManager.shared.create()
        reload()
    }
    
    func reload() {
        games = GameManager.shared.getGames()
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        cell.textLabel?.text = games[indexPath.row].content
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameSegue",
                let destination = segue.destination as? NewGameViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.game = games[index]
        }
    }
}
