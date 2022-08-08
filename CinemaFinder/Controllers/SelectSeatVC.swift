//
//  SelectSeatVC.swift
//  CinemaFinder


import UIKit

class SelectSeatVC: UIViewController {

    @IBOutlet weak var vwSeatCount: UIView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btn9AM: UIButton!
    @IBOutlet weak var btn3PM: UIButton!
    @IBOutlet weak var btn9PM: UIButton!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    
    var datePicker = UIDatePicker()
    var count = 1
    let toolBar = UIToolbar()
    var movieData: MovieModel!
    var theaterData: TheaterModel!
    var isSelectTime: Bool = false
    var price: Float = 0.0
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == self.btn9AM {
            self.setupButton(sender1: self.btn9AM, sender2: self.btn3PM, sender3: self.btn9PM)
        } else if sender == self.btn3PM {
            self.setupButton(sender1: self.btn3PM, sender2: self.btn9AM, sender3: self.btn9PM)
        } else if sender == btn9PM {
            self.setupButton(sender1: self.btn9PM, sender2: self.btn9AM, sender3: self.btn3PM)
        } else if sender == self.btnMinus {
            if self.count > 1 {
                self.count -= 1
                self.lblCount.text = self.count.description
            }
        } else if sender == btnPlus {
            if self.count < 5 {
                self.count += 1
                self.lblCount.text = self.count.description
            }
        }
    }
    
    
    func checkPayment() -> String {
    
    }
    
    @IBAction func btnPaymentClick(_ sender: UIButton) {
        
        
    }
    
    @IBAction func btnProfileClick(_ sender: UIButton) {
        
    }
    
    
    func setupButton(sender1: UIButton, sender2: UIButton, sender3: UIButton) {
        self.isSelectTime = true
        sender1.layer.borderColor = UIColor.green.cgColor
        sender1.layer.borderWidth = 1.0
        sender1.isSelected = true
        sender2.isSelected = false
        sender2.layer.borderWidth = 0.0
        sender3.isSelected = false
        sender3.layer.borderWidth = 0.0
    }
    
    func setUpView(){
        self.txtDate.inputView = datePicker
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.sizeToFit()
        self.txtDate.inputAccessoryView = toolBar
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func doneButtonTapped() {
        self.txtDate.text = GFunction.shared.getDate(datePicker.date, "dd-MM-yyyy hh:mm:ss +0000", output: "dd-MM-yyyy")
        self.txtDate.resignFirstResponder()
        self.getData3PM()
        self.getData9AM()
        self.getData9PM()
    }
}


extension SelectSeatVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtDate {
            self.datePicker.datePickerMode = .date
            self.datePicker.minimumDate = Date()
            return true
        }
        return false
    }
    
    
    func getTime() -> String {
        if self.btn3PM.isSelected {
            return "3:00 PM"
        }else if self.btn9PM.isSelected {
            return "9:00 PM"
        }else if self.btn9AM.isSelected {
            return "9:00 AM"
        }
        
        return ""
    }
    
    
    
    
    func getData3PM(){
        _ = Firestore.firestore().collection(cBooking).whereField(cDate, isEqualTo: self.txtDate.text?.trim() ?? "").whereField(cMID, isEqualTo: movieData.docID).whereField(cTime, isEqualTo: "3:00 PM").whereField(cTID, isEqualTo: theaterData.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            var bookedCount = 0
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let seat : Int = data1[cSeats] as? Int {
                        bookedCount += seat
                    }
                }
            }
            
            if !(10 > (bookedCount+self.count)){
                self.btn3PM.backgroundColor = .lightGray
                self.btn3PM.isUserInteractionEnabled = false
            }
        }
    }
    
    
    func getData9PM(){
        _ = Firestore.firestore().collection(cBooking).whereField(cDate, isEqualTo: self.txtDate.text?.trim() ?? "").whereField(cMID, isEqualTo: movieData.docID).whereField(cTime, isEqualTo: "9:00 PM").whereField(cTID, isEqualTo: theaterData.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            var bookedCount = 0
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let seat : Int = data1[cSeats] as? Int {
                        bookedCount += seat
                    }
                }
            }
            
            if !(10 > (bookedCount+self.count)){
                self.btn9PM.backgroundColor = .lightGray
                self.btn9PM.isUserInteractionEnabled = false
            }
        }
    }
    
    func getData9AM(){
        _ = Firestore.firestore().collection(cBooking).whereField(cDate, isEqualTo: self.txtDate.text?.trim() ?? "").whereField(cMID, isEqualTo: movieData.docID).whereField(cTime, isEqualTo: "9:00 AM").whereField(cTID, isEqualTo: theaterData.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            var bookedCount = 0
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let seat : Int = data1[cSeats] as? Int {
                        bookedCount += seat
                    }
                }
            }
            
            if !(10 > (bookedCount+self.count)){
                self.btn9AM.backgroundColor = .lightGray
                self.btn9AM.isUserInteractionEnabled = false
            }
        }
    }
}

    
}
