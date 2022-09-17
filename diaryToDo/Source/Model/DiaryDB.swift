//
//  DiaryDB.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/09/12.
//

import UIKit
import RealmSwift

class DiaryDB: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var content: String
    @Persisted var hashTag: List<String>
    @Persisted var date: Date
    @Persisted var textCount: Int

    convenience init(content: String, hashTag: List<String>, date: Date, textCount: Int) {
        self.init()
        self.content = content
        self.hashTag = hashTag
        self.date = date
        self.textCount = textCount
    }
}

