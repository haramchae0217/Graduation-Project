//
//  Font.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import Foundation

struct Font {
    var fontName: String
    var isSelectType: Bool = false
    
    static var fontList: [Font] = [
        Font(fontName: "Apple SD 산돌고딕 Neo"),
        Font(fontName: "Apple Gothic"),
        Font(fontName: "Apple Myungjo"),
        Font(fontName: "D2 Coding"),
        Font(fontName: "D2 Coding ligature"),
        Font(fontName: "GungSeo"),
        Font(fontName: "HeadLine A")
    ]
}
