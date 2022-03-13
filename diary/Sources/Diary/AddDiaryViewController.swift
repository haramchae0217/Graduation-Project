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
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDiaryContentTextView.delegate = self
        imagePicker.delegate = self
        
        addDiaryImageView.contentMode = .scaleAspectFill
        
        if addDiaryContentTextView.text.isEmpty {
            addDiaryContentTextView.text = "내용을 입력해주세요."
            addDiaryContentTextView.textColor = .lightGray
        }
        
//        if let addDiary = addDiary {
//            addDatePicker.date = addDiary.date
//            addDiaryContentTextView.text = addDiary.content
//            addDiaryHashTagTextField.text = addDiary.hashTag
//        }
    }
    
    func showAlertSheet() {
        let alertAction = UIAlertController(title: "사진 추가하기", message: "어떤방식으로 추가하시겠습니까?", preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "카메라", style: .default) { _ in
            print("camera on")
//            self.imagePicker.sourceType = .camera
//            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let photoLibraryButton = UIAlertAction(title: "사진첩", style: .default) { _ in
            print("photoLibrary on")
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
       
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertAction.addAction(cameraButton)
        alertAction.addAction(photoLibraryButton)
        alertAction.addAction(cancelButton)
        
        self.present(alertAction, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addPictureButton(_ sender: UIButton) {
        showAlertSheet()
    }
     
    @IBAction func addDiaryButton(_ sender: UIButton) {
        
        let addDate = addDatePicker.date
        let addContent = addDiaryContentTextView.text!
        let addHashTag = addDiaryHashTagTextField.text!
        let addPicture = addDiaryImageView.image!
        
        if addContent.isEmpty, addHashTag.isEmpty {
            UIAlertController.showAlert(message: "내용을 입력해주세요", vc: self)
            return
        }
    
        let newDiary = Diary(content: addContent, hashTag: addHashTag, date: addDate, picture: addPicture)
        Diary.diaryList.append(newDiary)
        
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension AddDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력해주세요." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요."
            textView.textColor = .lightGray
        }
    }
}

extension AddDiaryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addDiaryImageView.image = image
        } else {
            print("이미지 선택 실패")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

