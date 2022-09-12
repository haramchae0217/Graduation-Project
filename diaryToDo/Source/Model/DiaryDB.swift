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

    convenience init(content: String, hashTag: List<String>, date: Date) {
        self.init()
        self.content = content
        self.hashTag = hashTag
        self.date = date
    }
}

class SelectDiary: DiaryDB {
    
}
