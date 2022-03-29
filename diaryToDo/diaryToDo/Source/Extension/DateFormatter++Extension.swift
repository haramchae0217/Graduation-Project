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
        df.locale = Locale(identifier: "ko-KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateStyle = .medium
        df.timeStyle = .medium
        return df
    }()
    
    func toDateFromString(target: String) -> Date {
        self.dateFormat = "yyyy/MM/dd"
        return self.date(from: target)!
    }
    
    func toStringFromDate(target: Date) -> String {
        self.dateFormat = "yyyy/MM/dd"
        return self.string(from: target)
    }
    
    func toTimeFromString(target: String) -> Date {
        self.dateFormat = "a hh:mm"
        return self.date(from: target)!
    }
    
    func toStringFromTime(target: Date) -> String {
        self.dateFormat = "a hh:mm"
        return self.string(from: target)
    }

}
