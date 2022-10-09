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
//        df.locale = Locale(identifier: "ko_KR")
        return df
    }()
    
    func strToDate(str: String) -> Date {
        self.dateFormat = "yyyy/MM/dd"
        return self.date(from: str)!
    }
    
    func dateToString(date: Date) -> String {
        self.dateFormat = "yyyy/MM/dd"
        return self.string(from: date)
    }
    
    func dateToStr(date: Date, type: DateFormatType.RawValue) -> String {
        switch type {
        case "type1":
            self.dateFormat = "yyyy/MM/dd"
        case "type2":
            self.dateFormat = "yyyy.MM.dd"
        case "type3":
            self.dateFormat = "yyyy-MM-dd"
        case "type4":
            self.dateFormat = "dd MMM, yyyy"
        default:
            self.dateFormat = "yyyy/MM/dd"
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
