//
//  SignUpVC.swift
//  CinemaFinder

import UIKit

class SignUpVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUP: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    var flag : Bool = true
    var imgPicker = UIImagePickerController()
    var imgPicker1 = OpalImagePickerController()
    var isImageSelected : Bool = false
    var imageURL = ""
    var imageData = UIImage()
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignIn {
            self.navigationController?.popViewController(animated: true)
        }else if sender == btnSignUP {
            self.flag = false
            
            let error = self.validation(name: self.txtName.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", mobile: self.txtPhone.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "", confirmPass: self.txtConfirmPassword.text?.trim() ?? "")
        
            if error.isEmpty {
                self.firebaseRegister(data: self.txtEmail.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "", name: self.txtName.text?.trim() ?? "", mobile: self.txtPhone.text?.trim() ?? "")
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }
    }
    
    func openPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: "Select Image", preferredStyle: .actionSheet)
        
        let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return Alert.shared.showAlert(message: "Camera not Found", completion: nil)
            }
            GFunction.shared.isGiveCameraPermissionAlert(self) { (isGiven) in
                if isGiven {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.imgPicker.mediaTypes = ["public.image"]
                        self.imgPicker.sourceType = .camera
                        self.imgPicker.cameraDevice = .rear
                        self.imgPicker.allowsEditing = true
                        self.imgPicker.delegate = self
                        self.present(self.imgPicker, animated: true)
                    }
                }
            }
        })
        
        let PhotoLibrary = UIAlertAction(title: "Gallary", style: .default, handler:
                                            { [self]
            (alert: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .denied || photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized {
                            DispatchQueue.main.async {
                                self.imgPicker1 = OpalImagePickerController()
                                self.imgPicker1.maximumSelectionsAllowed = 1
                                self.imgPicker1.imagePickerDelegate = self
                                self.imgPicker1.isEditing = true
                                present(self.imgPicker1, animated: true, completion: nil)
                            }
                        }
                    })
                }else if photos == .authorized {
                    DispatchQueue.main.async {
                        self.imgPicker1 = OpalImagePickerController()
                        self.imgPicker1.imagePickerDelegate = self
                        self.imgPicker1.maximumSelectionsAllowed = 1
                        self.imgPicker1.isEditing = true
                        present(self.imgPicker1, animated: true, completion: nil)
                    }
                    
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        actionSheet.addAction(cameraPhoto)
        actionSheet.addAction(PhotoLibrary)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgProfile.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.openPicker()
        }
        self.imgProfile.addGestureRecognizer(tap)
        self.btnSignUP.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
    
    private func validation(name: String, email: String,mobile: String, password: String, confirmPass: String) -> String {
        if !self.isImageSelected {
            return STRING.errorSelectImage
        }else if name.isEmpty {
            return STRING.errorEnterName
            
        } else if email.isEmpty {
            return STRING.errorEmail
            
        } else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
            
        } else if mobile.isEmpty {
            return STRING.errorMobile
            
        } else if !Validation.isValidPhoneNumber(mobile) {
            return STRING.errorValidMobile
            
        } else if password.isEmpty {
            return STRING.errorPassword
            
        } else if password.count < 8 {
            return STRING.errorPasswordCount
            
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
            
        } else if confirmPass.isEmpty {
            return STRING.errorConfirmPassword
            
        } else if password != confirmPass {
            return STRING.errorPasswordMismatch
            
        } else {
            return ""
        }
    }
}

//MARK:- UIImagePickerController Delegate Methods
extension SignUpVC: UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate {
    func uploadImagePic(img1 :UIImage, name: String, email: String, mobile: String, password: String){
        let data = img1.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let imagePath = GFunction.shared.UTCToDate(date: Date())
        let filePath = "profile/\(imagePath)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference(withPath: filePath)
        storageRef.putData(data as Data, metadata: metaData) { (metaData, error) in
            if let error = error {
                return
            }
            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                self.isImageSelected = true
                self.imageURL = url?.absoluteString ?? ""
                print(url?.absoluteString) // <- Download URL
                self.createAccount(name: name, email: email, mobile: mobile, password: password, profile: self.imageURL)
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        if let image = info[.editedImage] as? UIImage {
            self.isImageSelected = true
            self.imgProfile.image = image
            self.imageData = image
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        do { picker.dismiss(animated: true) }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]){
        for image in assets {
            if let image = getAssetThumbnail(asset: image) as? UIImage {
                self.imgProfile.image = image
                self.imageData = image
                self.isImageSelected = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: (asset.pixelWidth), height: ( asset.pixelHeight)), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- Extension for Login Function
extension SignUpVC {
    
    func firebaseRegister(data: String, password: String, name: String, mobile: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: data, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            //return if any error find
            if error != nil {
                Alert.shared.showAlert(message: error?.localizedDescription ?? "", completion: nil)
            }else{
                self?.uploadImagePic(img1: self!.imageData, name: name, email: data, mobile: mobile, password: password)
            }
        }
    }
    

    func createAccount(name: String, email: String, mobile: String, password: String, profile:String) {
        var ref : DocumentReference? = nil
//        ref = AppDelegate.shared.db.collection(cUser).document().set([
//        ])
        ref = AppDelegate.shared.db.collection(cUser).addDocument(data:
            [
              cPhone: mobile,
              cEmail: email,
              cName: name,
              cPassword : password,
              cImageURL: profile
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.update(dataID: ref!.documentID, name: name, email: email, mobile: mobile, password: password, profile: profile)
            }
        }
    }
    
    func update(dataID: String, name: String, email: String, mobile: String, password: String, profile: String) {
        let ref = AppDelegate.shared.db.collection(cUser).document(dataID)
        ref.updateData([
            cUID: dataID,
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                GFunction.shared.firebaseRegister(data: email, password: password)
                GFunction.user = UserModel(docID: dataID, name: name, mobile: mobile, email: email, password: password, profile: profile)
                UIApplication.shared.setTab()
                self.flag = true
            }
        }
    }
}
