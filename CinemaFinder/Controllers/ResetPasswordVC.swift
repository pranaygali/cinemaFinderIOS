//
//  ResetPasswordVC.swift
//  CinemaFinder


import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnCancel {
            self.navigationController?.popViewController(animated: true)
        }else if sender == btnSubmit {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnCancel.layer.cornerRadius = 10.0
        self.btnSubmit.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
}
