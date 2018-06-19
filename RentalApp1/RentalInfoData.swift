//
//  RentalInfoData.swift
//  RentalApp1
//
//  Created by SWUCOMPUTER on 2018. 5. 25..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class RentalInfoData: NSObject {
    //모든 자료는 입력 전에 nil인지 확인하게 됨,
    //모든 자료가 nil이 아니므로 optional 타입이 아니며,
    //이 경우 init() 함수를 정의하던지 초기값을 주어야함
    var type: String = ""
    var number: String = ""
    var status: String = ""
    var detail: String = ""
    var uid: String = ""
    var rentDate: String = ""
}
