//
//  Game.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/11/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import Foundation
import SQLite3

struct Game {
    var id: Int32
    var content: String
}

class GameManager {
    var database: OpaquePointer?
    
    static let shared = GameManager()
    
    private init() {
    }
    
    func connect() {
        if database != nil {
            return
        }
        
        let databaseURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("games.sqlite")
        
        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        if sqlite3_exec(
            database,
            """
            CREATE TABLE IF NOT EXISTS games (
                content TEXT
            )
            """,
            nil,
            nil,
            nil
        ) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    
    func create() -> Int {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO games (content) VALUES ('Game \(Int(sqlite3_last_insert_rowid(database)) + 1)')",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting game")
            }
        }
        else {
            print("Error creating game insert statement")
        }
        
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getGames() -> [Game] {
        connect()
        
        var result: [Game] = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT rowid, content FROM games", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                result.append(Game(
                    id: sqlite3_column_int(statement, 0),
                    content: String(cString: sqlite3_column_text(statement, 1))
                ))
            }
        }
        
        sqlite3_finalize(statement)
        return result
    }
    
    func saveGame(game: Game) {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "UPDATE games SET content = ? WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: game.content).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, game.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving game")
            }
        }
        else {
            print("Error creating game update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    func delete(game: Game) {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "DELETE FROM games WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, game.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting game")
            }
        }
        else {
            print("Error creating game delete statement")
        }
        
        sqlite3_finalize(statement)
    }
}
