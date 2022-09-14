//
//  ToDoDB.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/09/12.
//

import UIKit
import RealmSwift

class ToDoDB: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var isChecked: Bool = false
    
    convenience init(title: String, memo: String, startDate: Date, endDate: Date) {
        self.init()
        self.title = title
        self.memo = memo
        self.startDate = startDate
        self.endDate = endDate
    }
}
