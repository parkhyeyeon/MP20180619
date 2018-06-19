//
//  LoginViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 18..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var loginUserid: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var createButton: UIButton!
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginUserid {
            textField.resignFirstResponder()
            self.loginPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginPressed() {
        if loginUserid.text == "" {
            labelStatus.text = "ID를 입력하세요";
            return; }
        if loginPassword.text == "" {
            labelStatus.text = "비밀번호를 입력하세요";
            return; }
        //let urlString: String = "http://localhost:8888/rental/login/loginUser.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/login/loginUser.php"

        guard let requestURL = URL(string: urlString) else {
            return }
        self.labelStatus.text = " "
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + loginUserid.text! + "&password=" + loginPassword.text!
        request.httpBody = restString.data(using: .utf8)
        
        //appdelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.ID = loginUserid.text
        
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
                    if let type = jsonData["type"] as! String! {
                        DispatchQueue.main.async {
                            if type == "일반사용자" {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let userView = storyboard.instantiateViewController(withIdentifier: "UserTab")
                                self.present(userView, animated: true, completion: nil)
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.ID = self.loginUserid.text
                            }
                            else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let adminView = storyboard.instantiateViewController(withIdentifier: "AdminTab")
                                self.present(adminView, animated: true, completion: nil)
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.ID = self.loginUserid.text
                            }
                        }
                    }
                    
                    
//                    if let name = jsonData["name"] as! String! {
//                        DispatchQueue.main.async {
//                           // self.labelStatus.text = name + "님 안녕하세요?"
//                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.ID = self.loginUserid.text
//                            appDelegate.userName = name
//                            self.labelStatus.text = appDelegate.userName
//                            self.performSegue(withIdentifier: "toLoginSuccess", sender: self)
//                        }
//                    }
                } else {
                    if let errMessage = jsonData["error"] as! String! { DispatchQueue.main.async {
                        self.labelStatus.text = errMessage
                        }
                    }
                }
            } catch {
                print("Error:  (error)")
            }
        }
        task.resume()
        
        //2번째 task 시작
//
//        //let urlString: String = "http://localhost:8888/rental/login/loginUser.php"
//        let urlString2: String = "http://condi.swu.ac.kr/student/T08iphone/login/loginUserGetName.php"
//
//        guard let requestURL2 = URL(string: urlString2) else {
//            return }
//        self.labelStatus.text = " "
//        var request2 = URLRequest(url: requestURL2)
//        request2.httpMethod = "POST"
//        let restString2: String = "id=" + loginUserid.text! + "&password=" + loginPassword.text!
//        request2.httpBody = restString2.data(using: .utf8)
//
//        //appdelegate
//        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.ID = loginUserid.text
//
//        let session2 = URLSession.shared
//        let task2 = session2.dataTask(with: request2) {
//            (responseData2, response2, responseError2) in
//            guard responseError2 == nil else {
//                print("Error: calling POST")
//                return }
//            guard let receivedData2 = responseData2 else {
//                print("Error: not receiving Data")
//                return }
//            do {
//                let response2 = response2 as! HTTPURLResponse
//                if !(200...299 ~= response2.statusCode) {
//                    print ("HTTP Error!")
//                    return }
//                guard let jsonData2 = try JSONSerialization.jsonObject(with: receivedData2, options:.allowFragments) as? [String: Any] else {
//                    print("JSON Serialization Error!")
//                    return }
//
//                guard let success = jsonData2["success"] as! String! else { print("Error: PHP failure(success)")
//                    return }
//                if success == "YES" {
//                    if let name = jsonData2["name"] as! String! {
//                       DispatchQueue.main.async {
//                            appDelegate.userName = name
//                            print(name)
//                       }
//                    }
//                    //                    if let name = jsonData["name"] as! String! {
//                    //                        DispatchQueue.main.async {
//                    //                           // self.labelStatus.text = name + "님 안녕하세요?"
//                    //                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    //                            appDelegate.ID = self.loginUserid.text
//                    //                            appDelegate.userName = name
//                    //                            self.labelStatus.text = appDelegate.userName
//                    //                            self.performSegue(withIdentifier: "toLoginSuccess", sender: self)
//                    //                        }
//                    //                    }
//                } else {
//                    if let errMessage2 = jsonData2["error"] as! String! { DispatchQueue.main.async {
//                        self.labelStatus.text = errMessage2
//                        }
//                    }
//                }
//            } catch {
//                print("Error:  (error)")
//            }
//        }
//        task2.resume()
//
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 버튼 둥글게 생성
        buttonLogin.layer.cornerRadius = 19
        buttonLogin.clipsToBounds = true
        
        createButton.layer.cornerRadius = 19
        createButton.clipsToBounds = true
        
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
