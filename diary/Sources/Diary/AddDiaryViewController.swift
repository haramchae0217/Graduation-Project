//
//  AddDiaryViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import UIKit

class AddDiaryViewController: UIViewController {

    @IBOutlet weak var addDiaryContentTextView: UITextView!
    @IBOutlet weak var addDiaryHashTagTextField: UITextField!
    @IBOutlet weak var addDatePicker: UIDatePicker!
    @IBOutlet weak var addDiaryImageView: UIImageView!
    
    var addDiary: Diary?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let addDiary = addDiary {
            addDatePicker.date = addDiary.date
            addDiaryContentTextView.text = addDiary.content
            addDiaryHashTagTextField.text = addDiary.hashTag
        }
    }
    
    @IBAction func addDiaryButton(_ sender: UIButton) {
        
        let addDate = addDatePicker.date
        let addContent = addDiaryContentTextView.text!
        let addHashTag = addDiaryHashTagTextField.text!
        
        if addContent.isEmpty, addHashTag.isEmpty {
            UIAlertController.showAlert(message: "내용을 입력해주세요", vc: self)
            return
        }
    
        let newDiary = Diary(content: addContent, hashTag: addHashTag, date: addDate)
        Diary.diaryList.append(newDiary)
        
        self.navigationController?.popViewController(animated: true)
    }

}
// 해시태그 배열로 : 글자수의 제한 10자리, 총 해시태그 수 제한 5개 이하
