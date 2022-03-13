//
//  Diary.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import UIKit

struct Diary {
    var content: String
    var hashTag: String
    var date: Date = Date()
    var picture: UIImage = UIImage(systemName: "folder")!
    
    static var diaryList: [Diary] = []
}
