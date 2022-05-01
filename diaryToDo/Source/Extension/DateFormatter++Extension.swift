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
        //df.timeZone = TimeZone(abbreviation: "KST")
        //df.dateStyle = .medium
        //df.timeStyle = .medium
        return df
    }()
    
    func dayDate(date: Date) -> String {
        self.dateFormat = "dd"
        return self.string(from: date)
    }
    
    func strToDate(str: String) -> Date {
        self.dateFormat = "yyyy/MM/dd"
        return self.date(from: str)!
    }
    
    func dateToStr(date: Date) -> String {
        self.dateFormat = "MMM d, yyyy"
        return self.string(from: date)
    }
    
    func strToTime(str: String) -> Date {
        self.dateFormat = "a hh:mm"
        return self.date(from: str)!
    }
    
    func timeToStr(date: Date) -> String {
        self.dateFormat = "a hh:mm"
        return self.string(from: date)
    }
}
