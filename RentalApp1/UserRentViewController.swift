//
//  UserRentViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 27..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class UserRentViewController: UIViewController {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    var selectedData: RentalInfoData?
    var userId: String?
    let formatter = DateFormatter()
    var myDate: String? = nil
    
    //대여하기 버튼 (서버 데이터 바꾸기/업데이트)
    @IBAction func rentButton(_ sender: UIBarButtonItem) {
        
     //버튼 눌렀을 때,
        //대여상태 == 대여가능 일 경우에만
        //alert창 : "대여하시겠습니까?" -> "네"일 경우
            //내용 저장 및 업데이트
            //"아니오"일 경우 alert창 닫기
        
        //대여상태 == 대여중 일 경우에는
            //alert message "현재 대여할 수 없습니다"
        
        //대여가능일 경우
        if self.statusLabel.text == "대여가능" {
            
        let alert = UIAlertController(title:"대여하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            //let urlString: String = "http://localhost:8888/rental/user/UserRent.php"
            let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/user/UserRent.php"

            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            
            //let formatter = DateFormatter()
            self.formatter.dateFormat = "yyyy-MM-dd"
            self.myDate = self.formatter.string(from: Date())
            
            var restString: String = "type=" + self.typeLabel.text!
            restString += "&number=" + self.numberLabel.text!
            restString += "&status=" + self.statusLabel.text!
            restString += "&detail=" + self.detailLabel.text!
            
            restString += "&uid=" + self.userId!
            restString += "&rentDate=" + self.myDate!
 
            
            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
                
            }
            task.resume()
            self.navigationController?.popViewController(animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        } else if self.statusLabel.text == "대여중" {
            
            self.displayAlertMessage(userMessage: "대여할 수 없습니다.")
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let selectedData = selectedData else {return}
        typeLabel.text = selectedData.type
        numberLabel.text = selectedData.number
        detailLabel.text = selectedData.detail
        statusLabel.text = selectedData.status
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        userId = appDelegate.ID
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
