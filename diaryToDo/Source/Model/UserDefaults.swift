//
//  UserDefaults.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/09/08.
//

import UIKit

enum SettingType: String {
    case dateFormat
    case fontSize
    case font
    case film
}

class Settings {
    static let shared = Settings()
    var dateFormat: String?
    var fontSize: CGFloat?
    var font: String?
    var film: String?
    
    private init() { }
}

//let ud = UserDefaults
