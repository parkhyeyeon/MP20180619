//
//  AdminMypageViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 6. 1..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

//관리자 마이페이지
class AdminMypageViewController: UIViewController {

    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var periodTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var uiView: UIView!
    
    //var typeAddStatus: Bool = false
    
    //대여품목 추가 (admin 마이페이지) 
    @IBAction func addTypePeriod(_ sender: UIButton) {
        
        if typeTextField.text == "" {
            displayAlertMessage(userMessage: "추가할 대여 품목을 입력하세요")
            return;
        }
        if periodTextField.text == "" {
            displayAlertMessage(userMessage: "추가할 대여 품목의 대여기간(단위: 일)을 설정하세요")
            return;
        }
        
        //let urlString: String = "http://localhost:8888/rental/Admin/AdminMyPageAddTypePeriod.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/admin/AdminMyPageAddTypePeriod.php"

        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "type=" + typeTextField.text! + "&period=" + periodTextField.text!
        
        
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
    }
    
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async { // for Main Thread Checker
                    
                    //대여품목 추가 완료 메시지창 띄우기
                    self.displayAlertMessage(userMessage: "대여 품목 추가가 완료되었습니다. 품목 종류를 추가해주세요")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.viewAppearCount = 1
                    
                    print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
        }
        task.resume()
    }
    
    
    
    //로그아웃 버튼
    @IBAction func buttonLogout(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in let urlString: String = "http://localhost:8888/rental/login/logout.php"
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = appDelegate.ID! + " 관리자 마이페이지"

        appDelegate.viewAppearCount = 0
        
        //버튼 둥글게 생성
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
        
        uiView.layer.cornerRadius = 22.5
        
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
