//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 이재은 on 2021/04/27.
//

import UIKit
import RxSwift
import RxCocoa

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    private let disposeBag = DisposeBag()
    var viewModel: MemoListViewModel!
    
    @IBOutlet private weak var listTableView: UITableView!
    @IBOutlet private weak var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "memoListCell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: disposeBag)
    }
    
}
