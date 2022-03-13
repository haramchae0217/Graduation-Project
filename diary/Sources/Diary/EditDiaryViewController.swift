//
//  EditDiaryViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import UIKit

class EditDiaryViewController: UIViewController {

    @IBOutlet weak var editDiaryContentTextView: UITextView!
    @IBOutlet weak var editDiaryHashTagTextField: UITextField!
    @IBOutlet weak var editDatePicker: UIDatePicker!
    @IBOutlet weak var editDiaryImageView: UIImageView!
    
    var editDiary: Diary?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightBarButtonItem()
        
        if let editDiary = editDiary {
            editDatePicker.date = editDiary.date
            editDiaryContentTextView.text = editDiary.content
            editDiaryHashTagTextField.text = editDiary.hashTag
        }
        
    }
    
    func createRightBarButtonItem() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "edit", style: .done, target: self, action: #selector(updateButtonClicked))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func updateButtonClicked() {
        
        let editDate = editDatePicker.date
        let editContent = editDiaryContentTextView.text!
        let editHashTag = editDiaryHashTagTextField.text!
        
        guard let diary = editDiary else { return }
        if diary.content == editContent || diary.hashTag == editHashTag {
            UIAlertController.showAlert(message: "변경 후 다시 시도해주세요.", vc: self)
            return
        }
        let editDiary = Diary(content: editContent, hashTag: editHashTag, date: editDate)
        if let row = row {
            Diary.diaryList[row] = editDiary
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
