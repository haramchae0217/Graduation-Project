//
//  File.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import Foundation

struct FontSize {
    var fontSize: String
    var isSelectType: Bool = false
    
    static var fontsizeList: [FontSize] = [
        FontSize(fontSize: "아주 작게"),
        FontSize(fontSize: "작게", isSelectType: true),
        FontSize(fontSize: "중간"),
        FontSize(fontSize: "크게"),
        FontSize(fontSize: "아주 크게")
    ]
}
