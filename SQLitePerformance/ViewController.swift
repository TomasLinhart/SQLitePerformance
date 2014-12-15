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

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = NSBundle.mainBundle().pathForResource("example", ofType: "db")!
        let db = Database(path, readonly: true)
        db.trace(println)
        let myTable = db["myTable"]
        
        runTest("first") {
            let arr = Array(myTable)
        }
        
        let stmt = db.prepare("SELECT * FROM myTable")
        
        runTest("second") {
            for row in stmt {
            }
        }
    }

    // Just a helper.
    private func runTest(name: String, test: () -> ()) {
        let start = NSDate()
        test()
        println("\(name) took \(-start.timeIntervalSinceNow)")
    }
}

