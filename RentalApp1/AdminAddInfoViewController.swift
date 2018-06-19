//
//  AdminAddInfoViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 27..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class AdminAddInfoViewController: UIViewController {

    @IBOutlet var textNumber: UITextField!
    @IBOutlet var textDetail: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    @IBAction func addInfo(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let type = appDelegate.type
        let id = appDelegate.ID
        
        let number = textNumber.text!
        let status = "미대여"                    //초기값
        let detail = textDetail.text!
        
        if(number == "" || detail == "") {
            let alert = UIAlertController(title: "추가할 항목 정보를 모두 입력하세요", message: "Add Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        //let urlString: String = "http://localhost:8888/Rental/Admin/addInfo.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T08iphone/admin/addInfo.php"

        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
     
        var restString: String = "type=" + type!
        restString += "&number=" + number
        restString += "&status=" + status
        restString += "&detail=" + detail
        restString += "&uid" + id!
        
        request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {(responseData, response, responseError) in
            guard responseError == nil else {return}
            guard let receivedData = responseData else {return}
            if let utf8Data = String(data: receivedData, encoding: .utf8) {print(utf8Data)}
        }
        task.resume()
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = appDelegate.type
        
        //버튼 둥글게 생성 
        saveButton.layer.cornerRadius = 20
        saveButton.clipsToBounds = true
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
