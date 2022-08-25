//
//  DateFormatter++Extension.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/17.
//

import UIKit

extension DateFormatter {
    static let customDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ko_KR")
        return df
    }()
    
    func strToDate(str: String) -> Date {
        self.dateFormat = "yyyy/MM/dd"
        return self.date(from: str)!
    }
    
    func dateToStr(date: Date, type: DateFormatType) -> String {
        switch type {
        case .type1:
            self.dateFormat = "yyyy.MM.dd(E)"
        case .type2:
            self.dateFormat = "EEE dd MMM yyyy"
        case .type3:
            self.dateFormat = "yyyy년 MM월 dd일 EEE"
        case .type4:
            self.dateFormat = "yyyy-MM-dd-E"
        case .type5:
            self.dateFormat = "yyyy/MM/dd/E"
        }
        return self.string(from: date)
    }
    
    func strToDay(str: String) -> Date {
        self.dateFormat = "dd"
        return self.date(from: str)!
    }

    func dayToStr(date: Date) -> String {
        self.dateFormat = "dd"
        return self.string(from: date)
    }
}
