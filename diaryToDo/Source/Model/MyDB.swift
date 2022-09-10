//
//  MyDB.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/04/04.
//

import UIKit
import RealmSwift

class DiaryDB: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var content: String
    @Persisted var hashTag: List<String>
    @Persisted var date: Date
    @Persisted var picture: String

    convenience init(content: String, hashTag: List<String>, date: Date, picture: String) {
        self.init()
        self.content = content
        self.hashTag = hashTag
        self.date = date
        self.picture = picture
    }
}

class ToDoDB: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var isChecked: Bool = false
    
    convenience init(title: String, memo: String, startDate: Date, endDate: Date) {
        self.init()
        self.title = title
        self.memo = memo
        self.startDate = startDate
        self.endDate = endDate
    }
}


struct MyDB {
    
    static var selectDiary: DiaryDB?
    
    static var selectToDo: ToDoDB?
    
//    static var diaryItem: [Diary] = [
//        Diary(content: "8년지기 친구들과 함께 강화도 여행중 간 카페! 고구마 케잌이 시그니처 메뉴였는데 맛있었다.", hashTag: ["카페","강화도","여행"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/08/11"), picture: UIImage(named: "cafe1")!),
//        Diary(content: "집앞에 좋은 카페가 있어서 다녀왔다 맛도 있고 사장님도 친절하셨다. 칼모양도 도끼처럼 신기했다.", hashTag: ["카페","운정"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/08/16"), picture: UIImage(named: "cafe2")!),
//        Diary(content: "카페", hashTag: ["카페","건대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/08/21"), picture: UIImage(named: "cafe3")!),
//        Diary(content: "새로 이사온 자취방. 1년 동안 잘 살아보장", hashTag: ["자취방","침대"], date: DateFormatter.customDateFormatter.strToDate(str: "2022/08/25"), picture: UIImage(named: "home1")!)
//    ]
    
//    static var toDoList: [ToDo] = [
//        ToDo(title: "점심먹기9", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/09"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/09")),
//        ToDo(title: "발표하기9", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/09"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/09")),
//        ToDo(title: "피드백 받기10", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/10"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/10")),
//        ToDo(title: "과제10-13", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/10"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/13")),
//        ToDo(title: "스터디11", memo: "iOS Programming", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/11"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/11")),
//        ToDo(title: "과외11", memo: "Swift Programming", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/11"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/11")),
//        ToDo(title: "자격증 시험12", memo: "모스 ppt", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/12"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/12")),
//        ToDo(title: "독서12", memo: "프로그래밍실습 과제", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/12"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/12")),
//        ToDo(title: "MOS12", memo: "중간고사", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/12"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/12")),
//        ToDo(title: "과제13-16", memo: "전산통계", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/13"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/16")),
//        ToDo(title: "본가가기13", memo: "파주로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/13"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/13")),
//        ToDo(title: "점심먹기13", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/13"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/13")),
//        ToDo(title: "발표하기14", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/14"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/14")),
//        ToDo(title: "피드백 받기14", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/14"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/14")),
//        ToDo(title: "과제14-17", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/14"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/17")),
//        ToDo(title: "점심먹기15", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/15"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/15")),
//        ToDo(title: "발표하기15", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/15"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/15")),
//        ToDo(title: "피드백 받기16", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/16"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/16")),
//        ToDo(title: "과제16-19", memo: "디지털 논리회로", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/16"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/19")),
//        ToDo(title: "스터디17", memo: "iOS Programming", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/17"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/17")),
//        ToDo(title: "과외17", memo: "Swift Programming", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/17"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/17")),
//        ToDo(title: "자격증 시험18", memo: "모스 ppt", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/18"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/18")),
//        ToDo(title: "독서18", memo: "프로그래밍실습 과제", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/18"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/18")),
//        ToDo(title: "MOS18", memo: "중간고사", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/18"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/18")),
//        ToDo(title: "과제19", memo: "전산통계", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/19"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/19")),
//        ToDo(title: "본가가기19", memo: "파주로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/19"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/19")),
//        ToDo(title: "점심먹기19", memo: "친구와 밥약", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/19"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/19")),
//        ToDo(title: "발표하기20", memo: "졸업작품 발표", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/20"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/20")),
//        ToDo(title: "피드백 받기20", memo: "졸작 피드백", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/20"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/20")),
//        ToDo(title: "과제20-23", memo: "디지털 논리회로", isChecked: true, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/20"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/23")),
//        ToDo(title: "졸업작품21-06", memo: "다이어리", isChecked: false, startDate: DateFormatter.customDateFormatter.strToDate(str: "2022/08/21"), endDate: DateFormatter.customDateFormatter.strToDate(str: "2022/09/06"))
//    ]
}
