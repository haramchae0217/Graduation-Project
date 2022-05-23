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
    
    func dateToStr(date: Date) -> String {
        self.dateFormat = "MMM d, yyyy"
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
