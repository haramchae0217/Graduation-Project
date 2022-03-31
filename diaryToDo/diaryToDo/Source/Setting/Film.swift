//
//  Film.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

struct Film {
    var filmType: UIImage
    var isSelectType: Bool = false
    
    static var filmList: [Film] = [
        Film(filmType: UIImage(named: "film1")!),
        Film(filmType: UIImage(named: "film2")!),
        Film(filmType: UIImage(named: "film3")!),
        Film(filmType: UIImage(named: "film4")!)
    ]
}
