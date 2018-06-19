//
//  UserMainViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 27..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class UserMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerRenting: UIPickerView!
    @IBOutlet var showRentButton: UIButton!
    var renting:String?
    
    //let rentingArray: [String] = ["햄스터로봇", "엔트리보드", "MacBook Air", "삼성노트북"]
    
    var fetchedArray: [TypePeriodData] = Array()
    
    var rentingArray: [String] = []
    var rentType: String?
    
    //대여조회 버튼
    @IBAction func showRenting(_ sender: UIButton) {
        
        renting = rentingArray[self.pickerRenting.selectedRow(inComponent: 0)]
        
        //선택한 대여 품목을 AppDelegate에서 저장
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.type = renting
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserList" {
            let destVC = segue.destination as! UserListTableViewController
            
            //선택된 품목 종류를 다음 이동하는 테이블 뷰로 넘기기
            destVC.title = renting
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return rentingArray.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        renting = rentingArray[row]
        return renting
    }
    
    
    @IBAction func buttonLogout(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/login/logout.php"
            
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "Login")
            self.present(loginView, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        showRentButton.layer.cornerRadius = 20
        showRentButton.clipsToBounds = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = "사용자 " + appDelegate.ID! +  " 대여"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedArray = []                 // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
        self.pickerRenting.reloadAllComponents()
    }
    
    func downloadDataFromServer() -> Void {
        //let urlString: String = "http://localhost:8888/rental/getTypeToPicker.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/admin/getTypeToPicker.php"

        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
            print("Error: calling POST");
            return;
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data");
                return;
            }
            let response = response as! HTTPURLResponse
            
            if !(200...299 ~= response.statusCode) { print("HTTP response Error! \(response.statusCode)"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] {
                    print(jsonData)
                    let newData: TypePeriodData = TypePeriodData()
                    self.rentingArray.removeAll()
                    
                    for i in 0...jsonData.count-1 {
                        var jsonElement = jsonData[i]
                        
                        self.rentType = jsonElement["type"] as? String
                        newData.type = self.rentType!
                        print(newData.type)
                        self.rentingArray.append(newData.type)
                        
                        newData.period = jsonElement["period"] as! String
                        
                        //self.fetchedArray.append(newData)
                        
                        //rentingArray에 TypePeriod 테이블의 type을 넣어서 배열 채우기.
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                    }
                }
            } catch { print("Error:") }
        }
        task.resume()
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
