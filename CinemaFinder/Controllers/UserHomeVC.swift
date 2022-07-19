//
//  UserHomeVC.swift
//  CinemaFinder

import UIKit

class UserHomeVC: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    
    var array = [MovieModel]()
    
    @IBAction func btnClickAdd(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: UserProfile.self) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnClickLogout(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        // Do any additional setup after loading the view.
    }
}


extension UserHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCellUser", for: indexPath) as! MovieCellUser
        cell.configCell(data: self.array[indexPath.row])
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: UserTheaterVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        return cell
    }
    
    func getData(){
        _ = AppDelegate.shared.db.collection(cMovie).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[cMName] as? String, let gerne: String = data1[cMGerne] as? String, let id :String = data1[cMID] as? String, let cast:String = data1[cMCast] as? String, let pName:String = data1[cMPName] as? String, let dName:String = data1[cMDName] as? String, let imagePath: String = data1[cImageURL] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(MovieModel(docID: id, name: name, starCast: cast, gerne: gerne, dName: dName, pName: pName, imagePath: imagePath))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}


class MovieCellUser: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGerne: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    func configCell(data: MovieModel) {
        self.imgProfile.setImgWebUrl(url: data.imagePath, isIndicator: true)
        self.lblName.text = data.name
        self.lblGerne.text = "Gerne: " + data.gerne
        self.lblPrice.text = "Price: $15"
    }
    
    override func awakeFromNib() {
        self.btnDelete.layer.cornerRadius = 10.0
        self.imgProfile.layer.cornerRadius = 10.0
    }
}
