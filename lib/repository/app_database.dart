// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'dart:io';

// ignore: unused_import
import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

import '../model/notes.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase db = AppDatabase._();
  Database? _database;

  static const NOTE_TABLE = "note";
  static const NOTE_COLOUM_ID = "note_id";
  static const NOTE_COLOUM_USER_ID = "user_id";
  static const NOTE_COLOUM_TITLE = "title";
  static const NOTE_COLOUM_DESC = "desc";
  static const NOTE_COLOUM_DATE = "dateTime";

  var sqlCreateTableNotes =
      "Create table $NOTE_TABLE ($NOTE_COLOUM_ID integer PRIMARY KEY , $NOTE_COLOUM_TITLE text, $NOTE_COLOUM_DESC text,$NOTE_COLOUM_DATE INTEGER )";

  Future<Database> getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDB();
    }
  }

  Future<bool> addNotes({required Notes notes}) async {
    try {
      var db = await getDB();
      var rowsEffected = await db.insert(NOTE_TABLE, notes.toMap());

      if (rowsEffected > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Notes>> fetchAllNotes() async {
    List<Notes>? notes;

    var db = await getDB();
    var notesList = await db.rawQuery('SELECT * FROM $NOTE_TABLE');

    notes = notesList.map((e) => Notes.fromMap(e)).toList();
    return notes;
  }

  Future<List<Notes>> searchNotes({required String keyword}) async {
    List<Notes>? notes;

    var db = await getDB();
    var notesList = await db.query(NOTE_TABLE,
        where: "$NOTE_COLOUM_TITLE LIKE ?", whereArgs: ['%$keyword%']);

    notes = notesList.map((e) => Notes.fromMap(e)).toList();
    return notes;
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    var dbPath = join(documentDirectory.path, "noteDB.db");
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(sqlCreateTableNotes);
      },
    );
  }

  Future<bool> updateNote(Notes note) async {
    var db = await getDB();
    var count = await db.update(
      NOTE_TABLE,
      note.toMap(),
      where: "$NOTE_COLOUM_ID =${note.note_id}",
    );
    return count > 0;
  }

  Future<bool> deleteNote(int id) async {
    var db = await getDB();
    var count = await db
        .delete(NOTE_TABLE, where: "$NOTE_COLOUM_ID = ?", whereArgs: ["$id"]);
    return count > 0;
  }
}
