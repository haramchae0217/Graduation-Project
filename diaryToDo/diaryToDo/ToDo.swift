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
    var expireDate: Date = Date()
    var expireTime: Date = Date()
    
    static var ToDoList: [ToDo] = [
        ToDo(title: "토익 - RC Day2", memo: "RC Day2", expireDate: Date()),
        ToDo(title: "과제 - 디지털논리회로", memo: "디지털논리회로", expireDate: Date()),
        ToDo(title: "과제 - 전산통계", memo: "전산통계", expireDate: Date())
    ]
}
