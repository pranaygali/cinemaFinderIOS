//
//  UserProfile.swift
//  CinemaFinder


import UIKit

class UserProfile: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContact: UITextField!
//    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnSaveChanges: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
    }
    
    @IBAction func btnLogoutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !GFunction.user.email.isEmpty {
            let user = GFunction.user
//            self.imgProfile.setImgWebUrl(url: user?.profile ?? "", isIndicator: true)
            self.txtName.text = user?.name.description
            self.txtEmail.text = user?.email.description
            self.txtContact.text = user?.mobile.description
            self.txtEmail.isUserInteractionEnabled = false
        }
        
        self.btnSaveChanges.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
}
