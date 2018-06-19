//
//  UserMypageDetailViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 6. 12..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import Foundation

class UserMypageDetailViewController: UIViewController {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var rentDateLabel: UILabel!
    @IBOutlet var returnScheduledDateLabel: UILabel!
    @IBOutlet var howLongLeft: UILabel!
    @IBOutlet var returnButton: UIButton!
    
    
    var selectedData: RentalInfoData?
    var periodStr: String?
    var rentDateStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
//        //버튼 둥글게 생성
        returnButton.layer.cornerRadius = 5
        returnButton.clipsToBounds = true
        
        guard let selectedData = selectedData else {return}
        typeLabel.text = selectedData.type
        numberLabel.text = selectedData.number
        rentDateLabel.text = selectedData.rentDate
        //returnScheduledDateLabel.text = periodStr
        
        //날짜 형식 string -> Date로 바꾸기
        rentDateStr = selectedData.rentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: rentDateStr!)
        
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/user/getTypePeriod.php"
        
        guard let requestURL = URL(string: urlString) else {
            return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "type=" + typeLabel.text!
        request.httpBody = restString.data(using: .utf8)
        
        //appdelegate
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return }
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return }
                
                guard let success = jsonData["success"] as! String! else { print("Error: PHP failure(success)")
                    return }
                if success == "YES" {
                    if let period = jsonData["period"] as! String! {
                        DispatchQueue.main.async {
                            
                            //대여일 + period(일단위) = returnScheduledDate 게산하기
                            //label에 출력하기
                            self.periodStr = period
                            
                            //캘린더는 사용되고 있는 종류별로 미리 정의되어 있고, 주로 그레고리언 달력을 사용한다. 그레고리언 달력은 다음과 같이 생성
                            let calendar = Calendar(identifier: .gregorian)
                            
                            //기준 날짜가 있고, 기준 날짜에 더해져야 하는 컴포넌트값이 있으면 캘린더가 합산을 수행해준다.
                            let dayOffset = DateComponents(day: Int(period))
                            if let dateRes = calendar.date(byAdding: dayOffset, to: date!) {
                                //print(dateFormatter.string(from: dateRes))
                                self.returnScheduledDateLabel.text = dateFormatter.string(from: dateRes)
                                
                                //반납일까지 며칠 남았는지 계산해서 label에 출력
                                //대여일 : rentDateStr
                                //반납 예정일
                                let today = dateFormatter.string(from: Date())
                                let startDate = dateFormatter.date(from: today)
                                let endDateReturn = dateFormatter.date(from: self.returnScheduledDateLabel.text!)
                                let interval = endDateReturn?.timeIntervalSince(startDate!)
                                let days = Int(interval! / 86400)
                                
                                if days < 0 {
                                    self.howLongLeft.text = "반납예정 기준일로부터 " + String(-days) + "일이 지났습니다."
                                    self.howLongLeft.textColor = UIColor.red
                                } else {
                                    self.howLongLeft.text = "반납예정일까지 " + String(days) + "일 남았습니다."
                                    self.howLongLeft.textColor = UIColor.purple
                                }
                            }
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as! String! { DispatchQueue.main.async {
                            print(errMessage)
                        }
                    }
                }
            } catch {
                print("Error:  (error)")
            }
        }
        task.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //반납하기
    @IBAction func returnPressed() {
        //해당 type과 number로 항목 검색해서,
        //(1) status(대여중->미대여) 바꾸기
        //(2) rentDate은 NULL로 바꾸기
        //
    if selectedData?.status == "대여중" {
        
        let alert = UIAlertController(title:"반납하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/user/UserReturn.php"

        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        //type, number, status, detail, uid, rentDate
            var restString: String = "type=" + self.typeLabel.text!
            restString += "&number=" + self.numberLabel.text!
            restString += "&status=" + (self.selectedData?.status)!
//        restString += "&detail=" + (selectedData?.detail)!
            restString += "&uid=" + (self.selectedData?.uid)!
            restString += "&rentDate=" + self.rentDateLabel.text!

        request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in
            guard responseError == nil else {return}
            guard let receivedData = responseData else {return}
            if let utf8Data = String(data: receivedData, encoding: .utf8){print(utf8Data)}
        }
        task.resume()
        self.navigationController?.popViewController(animated: true)
        
    }))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    self.present(alert, animated: true)
    
} else if selectedData?.status == "대여가능" {
    
    self.displayAlertMessage(userMessage: "반납할 수 없습니다.")
    
}

    }
    
    
    /*** Alert Message ***/
    func displayAlertMessage(userMessage:String) {
        let alertView = UIAlertController(title: "알림", message: userMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .destructive)
        alertView.addAction(cancel)
        present(alertView, animated: true, completion: nil)
        return
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
