//
//  MyDB.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/04/04.
//

import UIKit

struct MyDB {
    static var filmList: [(filmName: FilmType, isSelectd: Bool)] = [(.film1, true), (.film2, false), (.film3, false), (.film4, false)]
    
    static var selectDiary: Diary?
    
    static var diaryItem: [Diary] = [
        Diary(content: "카페", hashTag: ["카페","강화도","여행"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/11"), picture: UIImage(named: "cafe1")!),
        Diary(content: "카페", hashTag: ["카페","운정"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/16"), picture: UIImage(named: "cafe2")!),
        Diary(content: "카페", hashTag: ["카페","건대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/21"), picture: UIImage(named: "cafe3")!),
        Diary(content: "새로 이사온 자취방. 1년 동안 잘 살아보장", hashTag: ["자취방","침대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/05/26"), picture: UIImage(named: "home1")!)
    ]
    
    static var toDoList: [ToDo] = [
        ToDo(title: "점심먹기", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/29"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/29")),
        ToDo(title: "발표하기", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/29"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/29")),
        ToDo(title: "피드백 받기", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/30"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/30")),
        ToDo(title: "과제", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/30"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/06/30")),
        ToDo(title: "스터디", memo: "iOS Programming", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/01"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/01")),
        ToDo(title: "과외", memo: "Swift Programming", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/01"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/01")),
        ToDo(title: "자격증 시험", memo: "모스 ppt", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/02"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/02")),
        ToDo(title: "독서", memo: "프로그래밍실습 과제", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/02"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/02")),
        ToDo(title: "MOS", memo: "중간고사", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/02"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/02")),
        ToDo(title: "과제", memo: "전산통계", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/03"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/03")),
        ToDo(title: "본가가기", memo: "파주로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/03"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/03")),
        ToDo(title: "점심먹기", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/03"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/03")),
        ToDo(title: "발표하기", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/04"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/04")),
        ToDo(title: "피드백 받기", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/04"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/04")),
        ToDo(title: "과제", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/04"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/04")),
        ToDo(title: "점심먹기", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/05"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/05")),
        ToDo(title: "발표하기", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/05"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/05")),
        ToDo(title: "피드백 받기", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/06"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/06")),
        ToDo(title: "과제", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/06"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/06")),
        ToDo(title: "스터디", memo: "iOS Programming", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/07"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/07")),
        ToDo(title: "과외", memo: "Swift Programming", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/07"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/07")),
        ToDo(title: "자격증 시험", memo: "모스 ppt", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/08"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/08")),
        ToDo(title: "독서", memo: "프로그래밍실습 과제", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/08"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/08")),
        ToDo(title: "MOS", memo: "중간고사", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/08"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/08")),
        ToDo(title: "과제", memo: "전산통계", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/09"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/09")),
        ToDo(title: "본가가기", memo: "파주로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/09"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/09")),
        ToDo(title: "점심먹기", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/09"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/09")),
        ToDo(title: "발표하기", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/10"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/10")),
        ToDo(title: "피드백 받기", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/10"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/10")),
        ToDo(title: "과제", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/10"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/07/10"))

    ]
}
