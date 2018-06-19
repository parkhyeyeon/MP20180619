//
//  AdminListDetailViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 6. 1..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//
import UIKit

class AdminListDetailViewController: UIViewController {
    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var lenderNameLabel: UILabel!
    @IBOutlet var phoneNoLabel: UILabel!
    @IBOutlet var checkPersonButton: UIButton!

    
    var selectedData: RentalInfoData?
    var fetchedArray2: [UserInfoData] = Array()
    var fetchedArray: [RentalInfoData] = Array()

    var uid: String?
    var name: String?
    var phoneNo: String?
    var status: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let selectedData = selectedData else {return}
        typeLabel.text = selectedData.type
        numberLabel.text = selectedData.number
        self.status = selectedData.status
      
        checkPersonButton.layer.cornerRadius = 16
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }

    func downloadDataFromServer() -> Void {
        //let urlString: String = "http://localhost:8888/rental/Admin/AdminMypageListDetail.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/admin/AdminMypageListDetailUid.php"

        guard let requestURL = URL(string: urlString) else { return }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

      
        var restString:String = "&type=" + (selectedData?.type)!
        restString += "&number=" + (selectedData?.number)!
        
        //-> $sql = "select uid from rentalInfo where rentalInfo.type='$type' and rentalInfo.number='$number'";

        request.httpBody = restString.data(using: .utf8)


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
                
               // guard let success = jsonData["success"] as! String! else { print("Error: PHP failure(success)")
                 //   return }
                
                    if let uid = jsonData["uid"] as! String! {
                        DispatchQueue.main.async {
                            //self.lenderNameLabel.text = uid
                            //self.uid = uid
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.uid = uid
                        }
                    }
                
            } catch {
                print("Error:  (error)")
            }
        }
        task.resume()
 
    }
 
    @IBAction func checkPersonInfo() {
        //대여자 정보 확인하기
        
        if self.status == "대여중" {
        
        let alert = UIAlertController(title:"대여자 정보 확인하기",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/admin/AdminMypageListDetail.php"
            
            guard let requestURL = URL(string: urlString) else { return }
            
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let restString:String = "&uid=" + appDelegate.uid!
            
            // -> $sql = "select name, phoneNo from Login where id='$uid'";
            
            request.httpBody = restString.data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
                guard let receivedData = responseData else {
                    print("Error: not receiving Data"); return; }
                let response = response as! HTTPURLResponse
                
                if !(200...299 ~= response.statusCode) { print("HTTP response Error!");
                    print(response.statusCode);
                    return }
                print(response)
                do {
                    
                    if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] {
                        print(jsonData)
                        
                        DispatchQueue.main.async {
                        
                        for i in 0...jsonData.count-1 {
                            let userInfoDetail: UserInfoData = UserInfoData()
                            var jsonElement = jsonData[i]
                            
                                userInfoDetail.name = jsonElement["name"] as! String
                                userInfoDetail.phoneNo = jsonElement["phoneNo"] as! String
                            
                                print(userInfoDetail.name)
                            
                            
                                self.lenderNameLabel.text =  userInfoDetail.name
                                self.phoneNoLabel.text = userInfoDetail.phoneNo
                            
                            
                                self.fetchedArray2.append(userInfoDetail)
                            
                        }
                        
                        }
                        
                    }
                } catch { print("Error:") }
            }
            task.resume()
         
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
            
        } else {
            self.displayAlertMessage(userMessage: "대여자 정보를 확인할 수 없습니다.")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
