//
//  Diary.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import Foundation

struct Diary {
    var content: String
    var hashTag: String
    var date: Date = Date()
    
    static var diaryList: [Diary] = []
}
