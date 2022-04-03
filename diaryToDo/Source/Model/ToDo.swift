//
//  ToDo.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/12.
//

import Foundation

struct ToDo {
    var title: String
    var memo: String
    var isChecked: Bool = false
    var startDate: Date = Date()
    var expireDate: Date = Date()
    var expireTime: Date = Date()
    
}
