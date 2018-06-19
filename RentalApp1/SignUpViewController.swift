//
//  SignUpViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 18..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textName: UITextField!
    @IBOutlet var textPhoneNo: UITextField!
    //@IBOutlet var textUserType: UITextField!
    @IBOutlet var textUserType: UISegmentedControl!
    
    @IBOutlet var textId: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var labelStatus: UILabel!
    var userType: String? = ""
    
    @IBOutlet var userTypeLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var toMainButton: UIButton!
    
    @IBAction func selectUserType(_ sender: UISegmentedControl) {
        userType = sender.titleForSegment(at: sender.selectedSegmentIndex)
        userTypeLabel.text = userType! + " 선택"
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.textName {
            textField.resignFirstResponder()
            self.textPhoneNo.becomeFirstResponder()
        }
        else if textField == self.textPhoneNo {
            textField.resignFirstResponder()
        }
  
        else if textField == self.textId {
            textField.resignFirstResponder()
            self.textPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func buttonSave() {
        // 필요한 다섯 가지 자료가 모두 입력 되었는지 확인
        if textName.text == "" {
            labelStatus.text = "이름을 입력하세요";
            return;
        }
        if textPhoneNo.text == "" {
            labelStatus.text = "전화번호를 입력하세요";
            return;
        }
        if textId.text == "" {
            labelStatus.text = "아이디를 입력하세요";
            return;
        }
        if textPassword.text == "" {
            labelStatus.text = "비밀번호를 입력하세요";
            return;
        }
       // let urlString: String = "http://localhost:8888/rental/login/insertUser.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/login/insertUser.php"
        guard let requestURL = URL(string: urlString) else {
            print("no url")
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "&name=" + textName.text! + "&phoneNo=" + textPhoneNo.text! + "&userType=" + userType! + "&id=" + textId.text! + "&password=" + textPassword.text!
        request.httpBody = restString.data(using: .utf8)
        print("request")
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
            print("inserted")
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async { // for Main Thread Checker
                    self.labelStatus.text = utf8Data
                    print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨
                    self.displayAlertMessage(userMessage: "회원가입 완료 !")
                }
            }
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userTypeLabel.text = ""
        
        //버튼 둥글게 생성 
        signUpButton.layer.cornerRadius = 19.5
        signUpButton.clipsToBounds = true
        
        toMainButton.layer.cornerRadius = 19.5
        toMainButton.clipsToBounds = true
        
//        textUserType.layer.cornerRadius = 22.5
//        textUserType.clipsToBounds = true
        
    }

    
    /*** Alert Message ***/
    func displayAlertMessage(userMessage:String) {
        let alertView = UIAlertController(title: "알림", message: userMessage, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .destructive)
        alertView.addAction(cancel)
        present(alertView, animated: true, completion: nil)
        return
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
