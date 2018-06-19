//
//  AdminMainViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 23..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class AdminMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var pickerRenting: UIPickerView!
    @IBOutlet var rentShow: UIButton!
    var renting:String?
    var fetchedArray: [TypePeriodData] = Array()
    
    //let rentingArray: [String] = ["햄스터로봇", "엔트리보드", "MacBook Air", "삼성노트북"]
    var rentingArray: [String] = []
    var rentType: String?
    
    //로그아웃 버튼 
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
    
    
    @IBAction func showRenting(_ sender: UIButton) {
        
        //선택한 품목 종류가 type으로 저장되어, 조회 페이지로 넘어간다
        renting = rentingArray[self.pickerRenting.selectedRow(inComponent: 0)]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.type = renting
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdminList" {
            let destVC = segue.destination as! AdminListTableViewController
        
            destVC.title = renting
            //destVC.stuffDetailList = Array(rentingArray)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        fetchedArray = []                 // 배열을 초기화하고 서버에서 자료를 다시 가져옴
//        self.downloadDataFromServer()
//
      
        //버튼 둥글게 생성
        rentShow.layer.cornerRadius = 20
        rentShow.clipsToBounds = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = appDelegate.ID! + " 관리자 대여조회"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //default
       // if appDelegate.viewAppearCount == 0 {
            fetchedArray = []                 // 배열을 초기화하고 서버에서 자료를 다시 가져옴
            self.downloadDataFromServer()

            self.pickerRenting.reloadAllComponents()
       // }
        
        
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
 
                        //대여물품 추가한 경우
                        self.rentingArray.append(newData.type)
   
                        newData.period = jsonElement["period"] as! String
                        //self.fetchedArray.append(newData)
                    }
//                    DispatchQueue.main.async {
//                    }
                }
            } catch { print("Error:") }
        }
        task.resume()
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
