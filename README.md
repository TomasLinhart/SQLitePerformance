SQLitePerformance
=================

A simple test to demonstrate performance of SQLite.swift

On my computer I get following performance.

SELECT * FROM "myTable"

first took 18.98943400383 (using typed)

SELECT * FROM myTable

second took 1.50744700431824 (db.prepare)
