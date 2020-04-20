//
//  TaskListViewController.swift
//  GoodList
//
//  Created by 이재은 on 15/04/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    //    private var tasks = Variable<[Task]>([]) // DEPRECATED
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        toArray()
        map()
        flatMap()
        flatMapLatest()

        //        prioritySegmentedControl.rx
        //            .selectedSegmentIndex
        //            .asObservable()
        //            .subscribe(onNext: { index in
        //                print(index)
        //            }).disposed(by: disposeBag)

        Observable.combineLatest(tasks.asObservable(), prioritySegmentedControl.rx
            .selectedSegmentIndex.asObservable())
            .subscribe(onNext: { [weak self] list, index in
                let priority = Priority(rawValue: index - 1)
                if priority == nil {
                    self?.filteredTasks = list
                } else {
                    self?.filteredTasks = list.filter { $0.priority == priority }
                }
                print(list)
                self?.updateTableView()
            }).disposed(by: disposeBag)
    }

    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        //        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        //        filterTasks(by: priority)
    }

    //    private func filterTasks(by priority: Priority?) {
    //
    //        if priority == nil {
    //            self.filteredTasks = self.tasks.value
    //            self.updateTableView()
    //        } else {
    //            self.tasks.map { tasks in
    //                return tasks.filter { $0.priority == priority! }
    //            }.subscribe(onNext: { [weak self] tasks in
    //                self?.filteredTasks = tasks
    //                self?.updateTableView()
    //                print(tasks)
    //            }).disposed(by: disposeBag)
    //        }
    //    }

    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "TaskTableViewCell") else {
                return UITableViewCell()
        }
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let navC = segue.destination as? UINavigationController,
            let addTVC = navC.viewControllers.first as? AddTaskViewController else {
                fatalError("Controller not found...")
        }

        addTVC.taskSubjectObservable
            .subscribe(onNext: { task in
                //                self.tasks.value.append(task) // DEPRECATED

                //                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)

                //                        self.filterTasks(by: priority)

            }).disposed(by: disposeBag)
    }


}

extension TaskListViewController {
    func toArray() {
        Observable.of(1,2,3,4,5)
            .toArray()
            .subscribe(onSuccess: {
                print($0)
            }).disposed(by: disposeBag)
    }
    // [1,2,3,4,5]

    func map() {
        Observable.of(1,2,3,4,5)
            .map {
                return $0 * 2
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    //    2
    //    4
    //    6
    //    8
    //    10

    struct Student {
        var score: BehaviorRelay<Int>
    }

    func flatMap() {
        let john = Student(score: BehaviorRelay(value: 75))
        let mary = Student(score: BehaviorRelay(value: 95))

        let student = PublishSubject<Student>()

        student.asObservable()
            .flatMap {  $0.score.asObservable() }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        student.onNext(john)
        //        john.score.value = 100 // Error: Cannot assign value of type 'Int' to type 'BehaviorRelay<Int>'
        john.score.accept(100)

        student.onNext(mary)
        mary.score.accept(80)

        john.score.accept(40)

    }
    //    75
    //    100
    //    95
    //    80
    //    40

    func flatMapLatest() {
        let john = Student(score: BehaviorRelay(value: 75))
        let mary = Student(score: BehaviorRelay(value: 95))

        let student = PublishSubject<Student>()

        student.asObservable()
            .flatMapLatest {  $0.score.asObservable() }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        student.onNext(john)
        john.score.accept(100)

        student.onNext(mary)
        john.score.accept(45)
    }
    // 75
    // 100
    // 95
}
