//
//  TheaterListController.swift
//  iOSstudy_ch9_network_20191223
//
//  Created by 이재은 on 13/01/2020.
//  Copyright © 2020 jaeeun. All rights reserved.
//

import UIKit

class TheaterListController: UITableViewController {

    var list = [NSDictionary]()
    var startPoint = 0

    override func viewDidLoad() {
        self.callTheaterAPI()
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell

        cell.name.text = obj["상영관명"] as? String
        cell.tel.text = obj["연락처"] as? String
        cell.addr.text = obj["소재지도로명주소"] as? String

        return cell
    }

    func callTheaterAPI() {
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 100
        let type = "json"

        let urlObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        do {
            // NSString 객체를 이용하여 API를 호출하고 그 결과값을 인코딩된 문자열로 받아온다.
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
            // 문자열로 받은 데이터를 UTF-8로 인코딩처리한 Data로 변환한다.
            let encdata = stringdata.data(using: String.Encoding.utf8.rawValue)

            do {
                // Data 객체를 파싱하여 NSArray 객체로 변환한다.
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                for obj in apiArray! {
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패",
                                              message: "데이터 분석이 실패하였습니다",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false)
            }
            self.startPoint += sList
        } catch {
            let alert = UIAlertController(title: "실패",
                                          message: "데이터를 불러오는데 실패하였습니다",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
    }
}
