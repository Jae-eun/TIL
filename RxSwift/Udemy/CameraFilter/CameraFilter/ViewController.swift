//
//  ViewController.swift
//  CameraFilter
//
//  Created by 이재은 on 06/04/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        ignore()
        elementAt()
        filter()
        skip()
        skipWhile()
        skipUntil()
        take()
        takeWhile()
        takeUntil()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let naviC = segue.destination as? UINavigationController,
            let photosCollectionVC = naviC.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("Segue destination is not found")
        }
        photosCollectionVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func applyFilterButtonPressed() {
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        //        FilterService().applyFilter(to: sourceImage) { filteredImage in
        //            DispatchQueue.main.async {
        //                self.photoImageView.image = filteredImage
        //            }
        //        }
        
        // 27. Transforming Apply Filter into an Observable
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }


    // 28
    func ignore() {
        let strikes = PublishSubject<String>()
        strikes.ignoreElements()
            .subscribe { _ in
                print("[Subscription is called]")
        }.disposed(by: disposeBag)
        
        strikes.onNext("A") // 아무런 이벤트도 호출되지 않음
        strikes.onNext("B")
        strikes.onNext("C")
        
        strikes.onCompleted() // 완료 이벤트가 완료되었을 때만 호출됨
    }
    
    // 29
    func elementAt() {
        let strikes = PublishSubject<String>()
        strikes.elementAt(2)
            .subscribe(onNext: { _ in
                print("You are out!")
            }).disposed(by: disposeBag)
        
        strikes.onNext("X") // 0
        strikes.onNext("X") // 1
        strikes.onNext("X") // 2 호출됨
    }

    // 30
    func filter() {
        Observable.of(1,2,3,4,5,6,7)
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }

    // 31 지정한 수만큼 요소를 건너뜀
    func skip() {
        Observable.of("A", "B", "C", "D", "E", "F")
            .skip(3)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }

    // 32 조건이 충족되는 동안 건너뜀
    func skipWhile() {
        Observable.of(2,2,3,4,4)
            .skipWhile { $0 % 2 == 0 }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }

    // 33 트리거 될 때까지 건너뜀
    func skipUntil() {
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()

        subject.skipUntil(trigger)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        subject.onNext("A")
        subject.onNext("B")

        trigger.onNext("X")

        subject.onNext("C")
    }

    // 34 지정한 수만큼 요소를 가져옴
    func take() {
        Observable.of(1,2,3,4,5,6)
            .take(3)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }

    // 35 조건이 참일 때까지 구독함
    func takeWhile() {
        Observable.of(2,4,6,7,8,10)
            .takeWhile {
                $0 % 2 == 0
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }

    // 36 트리거가 발생하기 전까지 구독함
    func takeUntil() {
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()

        subject.takeUntil(trigger)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        subject.onNext("a")
        subject.onNext("b")

        trigger.onNext("X")

        subject.onNext("c")
    }
    
}

