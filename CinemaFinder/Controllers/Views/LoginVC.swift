//
//  LoginVC.swift
//  CinemaFinder

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUP: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignInAdmin: UIButton!
    @IBOutlet weak var btnApple: UIButton!
  
    var flag: Bool = true
    private let socialLoginManager: SocialLoginManager = SocialLoginManager()
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignIn {
            self.flag = false
            let error = self.validation(email: self.txtEmail.text!.trim(),password: self.txtConfirmPassword.text!.trim())
            
            if error.isEmpty {
                self.firebaseLogin(data: self.txtEmail.text?.trim() ?? "", password: self.txtConfirmPassword.text ?? "")
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
            
        }else if sender == btnSignUP {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignInAdmin {
            
        } else if sender == btnApple {
            self.socialLoginManager.performAppleLogin()
        }
    }
    
    func validation(email: String, password: String) -> String {
        
        if email.isEmpty {
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        } else if password.isEmpty {
            return STRING.errorPassword
        } else {
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnApple.layer.cornerRadius = 10.0
        self.btnSignInAdmin.layer.cornerRadius = 10.0
        self.btnSignIn.layer.cornerRadius = 10.0
        
        self.socialLoginManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

}


//MARK:- Extension for Login Function
extension LoginVC {
    
    func firebaseLogin(data: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: data, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            //return if any error find
            if error != nil {
                Alert.shared.showAlert(message: error?.localizedDescription ?? "", completion: nil)
            }else{
                self?.loginUser(email: data, password: password)
            }
        }
    }
    
    func loginUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(cUser).whereField(cEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let name: String = data1[cName] as? String, let phone: String = data1[cPhone] as? String, let email: String = data1[cEmail] as? String
//                   let password: String = data1[cPassword] as? String
                { //let imagePath: String = data1[cImageURL] as? String{
                    GFunction.user = UserModel(docID: docId, name: name, mobile: phone, email: email, profile: "")
                    GFunction.shared.firebaseRegister(data: email, password: password)
                    
                    Alert.shared.showAlert(message: "Login Successfully !!!", completion: nil)
                    UIApplication.shared.setTab()
                }
                
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}


extension LoginVC: SocialLoginDelegate {
    
    func socialLoginData(data: SocialLoginDataModel) {
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
        self.loginUser(email: data.email, password: data.socialId,data: data)
    }
    
    func loginUser(email:String,password:String,data: SocialLoginDataModel) {
        
        _ = AppDelegate.shared.db.collection(cUser).whereField(cEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            if snapshot.documents.count != 0 {
                self.txtEmail.text = data.email
                self.txtEmail.isUserInteractionEnabled = true
                
            }else{
//                if let vc = UIStoryboard.main.instantiateViewController(withClass:  SignUpVC.self) {
//                    vc.socialData = data
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
            }
        }
    }
}
