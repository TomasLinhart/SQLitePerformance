//
//  ViewController.swift
//  SQLitePerformance
//
//  Created by Tomas Linhart on 15/12/14.
//  Copyright (c) 2014 Tomas Linhart. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    let path = NSBundle.mainBundle().pathForResource("example", ofType: "db")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Database(path, readonly: true)
        let myTable = db["myTable"]
        
        runTest("using typed API") {
            let arr = Array(myTable)
        }
        
        let stmt = db.prepare("SELECT * FROM myTable")
        
        runTest("using db.prepare") {
            for row in stmt {
            }
        }
        
        runTest("using C native API") {
            // It also includes code to open connection but it is still faster than other methods.
            self.nativeTest()
        }
    }
    
    func nativeTest() {
        var db: COpaquePointer = nil
        if sqlite3_open(path.cStringUsingEncoding(NSUTF8StringEncoding)!, &db) != SQLITE_OK {
            println("Failed to open file")
            exit(1)
        }
        
        var query = "SELECT * FROM myTable"
        var statement: COpaquePointer = nil
        if (sqlite3_prepare_v2(db, query.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &statement, nil)
            == SQLITE_OK) {
                let columnCount = sqlite3_column_count(statement)
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    let uniqueId = sqlite3_column_int(statement, 0)
                    // Just assume everything is string so we do at least some conversion that might it slow down if we do it for every column.
                    for i in 0..<columnCount {
                        let txt = UnsafePointer<Int8>(sqlite3_column_text(statement, i))
                        let buf = NSString(CString: txt, encoding: NSUTF8StringEncoding)
                    }
                }
                sqlite3_finalize(statement)
        }
        
        sqlite3_close(db)
    }

    // Just a helper.
    private func runTest(name: String, test: () -> ()) {
        let start = NSDate()
        test()
        println("\(name) took \(-start.timeIntervalSinceNow) seconds")
    }
}

