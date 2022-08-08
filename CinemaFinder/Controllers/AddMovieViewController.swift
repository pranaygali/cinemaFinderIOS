//
//  AddMovieViewController.swift
//  CinemaFinder


import UIKit

class AddMovieViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldCast: UITextField!
    @IBOutlet weak var textFieldDirectorName: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    var data: MovieModel!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        let error = self.validation(name: self.textFieldName.text ?? "", cast: self.textFieldCast.text ?? "", dName: self.textFieldDirectorName.text ?? "")
        
        if error.isEmpty {
            data != nil ? self.update(dataID: self.data.docID, name: self.textFieldName.text?.trim() ?? "", cast: self.textFieldCast.text?.trim() ?? "", dName: self.textFieldDirectorName.text?.trim() ?? "") :
            self.addMovieData(name: self.textFieldName.text?.trim() ?? "", cast: self.textFieldCast.text?.trim() ?? "", dName: self.textFieldDirectorName.text?.trim() ?? "")
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    @IBAction func btnClickLogout(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.setStart()
    }
    
    private func validation(name: String, cast: String, dName: String) -> String {
        if name.isEmpty {
            return STRING.errorEnterMovieName
        } else if cast.isEmpty {
            return STRING.errorEnterCast
        } else if dName.isEmpty {
            return STRING.errorEnterDName
        }else {
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAdd.layer.cornerRadius = 10.0
        
        if self.data != nil {
            self.textFieldName.text = self.data.name
            self.textFieldCast.text = self.data.starCast
            self.textFieldDirectorName.text = self.data.dName
        }
    }
    
    

