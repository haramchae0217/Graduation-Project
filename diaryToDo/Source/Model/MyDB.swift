//
//  MyDB.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/04/04.
//

import UIKit
import RealmSwift

struct MyDB {
    
    static var selectDiary: DiaryDB?
    static var selectToDo: ToDoDB?
    static var selectImage: (UIImage, Int)?
}
