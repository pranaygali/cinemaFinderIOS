//
//  AddTheaterViewController.swift
//  CinemaFinder


import UIKit
import Firebase

class AddTheaterViewController: UIViewController {

    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    var data: TheaterModel!
    
    
    private func validation(name: String, address: String) -> String {
        if name.isEmpty {
            return STRING.errorEnterTheaterName
        } else if address.isEmpty {
            return STRING.errorEnterTheaterAddress
        } else {
            return ""
        }
    }
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        let error = self.validation(name: self.textFieldFullName.text?.trim() ?? "", address: self.textFieldAddress.text?.trim() ?? "")
        
        if error.isEmpty {
            if self.data != nil {
                self.update(dataID: self.data.docID, name: self.textFieldFullName.text?.trim() ?? "", address: self.textFieldAddress.text?.trim() ?? "")
            }else{
                self.addTheaterData(address: self.textFieldAddress.text?.trim() ?? "", name: self.textFieldFullName.text?.trim() ?? "")
            }
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    @IBAction func btnClickLogout(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAdd.layer.cornerRadius = 10.0
        
        if data != nil {
            self.textFieldAddress.text = self.data.location
            self.textFieldFullName.text = self.data.name
        }
    }
    
    
