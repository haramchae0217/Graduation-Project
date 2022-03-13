//
//  DiaryViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var diaryTableView: UITableView!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ko-KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateStyle = .medium
        df.timeStyle = .medium
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        diaryTableView.contentMode = .scaleAspectFill
        
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
        diaryCell.diaryDateLabel.text = dateFormatter.toString(target: diary.date)
        return diaryCell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Diary.diaryList.remove(at: indexPath.row)
            // 실제 배열 안의 값을 지움
            tableView.deleteRows(at: [indexPath], with: .fade)
            // 사라지는 방향
        } else {
            print("insert")
        }
        // 어디에 있는 줄을 지울것인가
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
