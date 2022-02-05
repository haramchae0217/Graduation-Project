//
//  AddDiaryViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import UIKit

class AddDiaryViewController: UIViewController {

    @IBOutlet weak var addDiaryDateTextField: UITextField!
    @IBOutlet weak var addDiaryContentTextView: UITextView!
    @IBOutlet weak var addDiaryHashTagTextField: UITextField!
    
    var addDiary: Diary?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDiaryDateTextField.text = addDiary?.date
        addDiaryContentTextView.text = addDiary?.content
        addDiaryHashTagTextField.text = addDiary?.hashTag

    }
    @IBAction func addDiaryButton(_ sender: UIButton) {
        let addDate = addDiaryDateTextField.text!
        let addContent = addDiaryContentTextView.text!
        let addHashTag = addDiaryHashTagTextField.text!
        
        if addDate.isEmpty, addContent.isEmpty, addHashTag.isEmpty {
            UIAlertController.showAlert(message: "내용을 입력해주세요", vc: self)
            return
        }
        let newDiary = Diary(content: addContent, hashTag: addHashTag, date: addDate)
        Diary.diaryList.append(newDiary)
        
        self.navigationController?.popViewController(animated: true)
    }

}
