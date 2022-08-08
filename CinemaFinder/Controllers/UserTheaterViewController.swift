//
//  UserTheaterViewController.swift
//  CinemaFinder


import UIKit

class UserTheaterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var array = [TheaterModel]()
    var movieData: MovieModel!
    
    
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


extension UserTheaterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheaterCellUser", for: indexPath) as! TheaterCellUser
        cell.labelName.text = self.array[indexPath.row].name
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SelectSeatVC.self){
                vc.movieData = self.movieData
                vc.theaterData = self.array[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.viewMain.isUserInteractionEnabled = true
        cell.viewMain.addGestureRecognizer(tap)
        return cell
    }
    
    func getData(){
        _ = Firestore.firestore().collection(cTheater).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
        }
    }
    
}


class TheaterCellUser: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.layer.cornerRadius = 10.0
    }
}
