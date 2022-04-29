//
//  ToDOTableViewCell.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/12.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    static let identifier = "ToDo"
    
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var toDoExpireDateLabel: UILabel!
    @IBOutlet weak var toDoExpireTimeLabel: UILabel!
    @IBOutlet weak var toDoCheckButton: UIButton!
    
}
