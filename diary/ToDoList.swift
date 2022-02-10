//
//  ToDoList.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/04.
//

import Foundation

struct ToDo {
    var title: String
    var memo: String
    var isChecked: Bool = false
    
    // 메모를 담을 배열을 static으로 선언
    static var toDoList: [ToDo] = []
}

