//
//  DateFormat.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import Foundation

struct DateFormat {
    var typeDateFormat: String
    var isSelectType: Bool = false
    
    static var dateFormatList: [DateFormat] = [
        DateFormat(typeDateFormat: "2022.01.24(월)", isSelectType: true),
        DateFormat(typeDateFormat: "Mon 24 Jan 2022"),
        DateFormat(typeDateFormat: "2022년 01월 24일"),
        DateFormat(typeDateFormat: "2022-01-24")
    ]
}
