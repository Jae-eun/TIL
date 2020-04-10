//
//  MemoListVC.swift
//  MyMemory
//
//  Created by 이재은 on 26/03/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return self.appDelegate.memolist.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let memoData = self.appDelegate.memolist[indexPath.row]
        let cellId = memoData.image == nil ? "memoCell" : "memoCellWithImage"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MemoCell else { return UITableViewCell() }
        
        cell.subject?.text = memoData.title
        cell.contents?.text = memoData.contents
        cell.img?.image = memoData.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: memoData.regdate!)
        
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        let selectedMemoData = self.appDelegate.memolist[indexPath.row]
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else { return }
        
        vc.param = selectedMemoData
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
