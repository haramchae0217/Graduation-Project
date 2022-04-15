//
//  MyDB.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/04/04.
//

import Foundation
import UIKit

struct MyDB {
    static var diaryItem: [Diary] = [
        Diary(content: "카페", hashTag: ["#카페","#강화도"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/04/01"), picture: UIImage(named: "cafe1")!),
        Diary(content: "카페", hashTag: ["#카페","#운정"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/04/06"), picture: UIImage(named: "cafe2")!),
        Diary(content: "카페", hashTag: ["#카페","#건대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/04/11"), picture: UIImage(named: "cafe3")!),
        Diary(content: "집", hashTag: ["#자취방","#침대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/04/16"), picture: UIImage(named: "home1")!)
    ]
    
    static var toDoList: [ToDo] = [
        ToDo(title: "점심먹기", memo: "친구와 밥약", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/01")),
        ToDo(title: "발표하기", memo: "졸업작품 발표", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/01")),
        ToDo(title: "피드백 받기", memo: "졸작 피드백", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/01")),
        ToDo(title: "과제", memo: "디지털 논리회로", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/04")),
        ToDo(title: "스터디", memo: "iOS Programming", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/04")),
        ToDo(title: "과외", memo: "Swift Programming", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/06")),
        ToDo(title: "자격증 시험", memo: "모스 ppt", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/11")),
        ToDo(title: "독서", memo: "프로그래밍실습 과제", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/13")),
        ToDo(title: "MOS", memo: "중간고사", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/15")),
        ToDo(title: "과제", memo: "전산통계", startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/04/16"))

    ]
}
