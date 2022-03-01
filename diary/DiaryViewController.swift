//
//  DiaryViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var diaryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        diaryTableView.reloadData()
    }

}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Diary.diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let diaryCell = tableView.dequeueReusableCell(withIdentifier: "diaryTableCell", for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        let diary = Diary.diaryList[indexPath.row]
        diaryCell.diaryContentLabel.text = diary.content
        diaryCell.diaryHashTagLabel.text = diary.hashTag
        diaryCell.diaryDateLabel.text = DateFormatter.customDateFormatter.string(from: Date())
        
        return diaryCell
        
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editDiaryVC = self.storyboard?.instantiateViewController(withIdentifier: "editDiaryVC") as? EditDiaryViewController else { return }
        editDiaryVC.editDiary = Diary.diaryList[indexPath.row]
        editDiaryVC.row = indexPath.row
        self.navigationController?.pushViewController(editDiaryVC, animated: true)
    }
}
