//
//  AdminMypageMemoDetailViewController.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

//toAdminMemoDetail (segue)
class AdminMypageMemoDetailViewController: UIViewController {

    @IBOutlet var dateDetail: UILabel!
    @IBOutlet var titleDetail: UITextField!
    @IBOutlet var contentDetail: UITextView!
    
    var detailAdminNote: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let detailNote = detailAdminNote {
            titleDetail.text = detailNote.value(forKey: "title") as? String
            contentDetail.text = detailNote.value(forKey: "content") as? String
            let dbDate: Date? = detailNote.value(forKey: "date") as? Date
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd h:mm a"
            if let unwrapDate = dbDate {
                let displayDate = formatter.string(from: unwrapDate as Date)
                dateDetail.text = displayDate
            }
        }
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
