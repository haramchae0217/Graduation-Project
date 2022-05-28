//
//  MyDB.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/04/04.
//

import UIKit

struct MyDB {
    static var diaryItem: [Diary] = [
        Diary(content: "카페", hashTag: ["#카페","#강화도","#여행"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11"), picture: UIImage(named: "cafe1")!),
        Diary(content: "카페", hashTag: ["#카페","#운정"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/16"), picture: UIImage(named: "cafe2")!),
        Diary(content: "카페", hashTag: ["#카페","#건대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/21"), picture: UIImage(named: "cafe3")!),
        Diary(content: "집", hashTag: ["#자취방","#침대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/26"), picture: UIImage(named: "home1")!)
    ]
    
    static var toDoList: [ToDo] = [
        ToDo(title: "점심먹기", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11")),
        ToDo(title: "발표하기", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11")),
        ToDo(title: "피드백 받기", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11")),
        ToDo(title: "과제", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/14"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/14")),
        ToDo(title: "스터디", memo: "iOS Programming", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/14"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/14")),
        ToDo(title: "과외", memo: "Swift Programming", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/16"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/16")),
        ToDo(title: "자격증 시험", memo: "모스 ppt", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/21"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/21")),
        ToDo(title: "독서", memo: "프로그래밍실습 과제", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/23"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/23")),
        ToDo(title: "MOS", memo: "중간고사", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/25"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/25")),
        ToDo(title: "과제", memo: "전산통계", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/26"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/26")),
        ToDo(title: "본가가기", memo: "파주로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/30"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/05/30"))

    ]
}
