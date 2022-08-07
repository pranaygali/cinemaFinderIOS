//
//  UserHomeViewController.swift
//  CinemaFinder

import UIKit

class UserHomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pendingItem: DispatchWorkItem?
    var pendingRequest: DispatchWorkItem?
    var array = [MovieModel]()
    var arrayData = [MovieModel]()
    
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
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
}


extension UserHomeViewController: UITableViewDelegate, UITableViewDataSource {
    }


class MovieCellUser: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    func configCell(data: MovieModel) {
        self.labelName.text = data.name
        self.labelPrice.text = "Price: $15"
    }
    
    override func awakeFromNib() {
        self.buttonDelete.layer.cornerRadius = 10.0
        self.imageViewProfile.layer.cornerRadius = 10.0
    }
}


//MARK:- UISearchBarDelegate Delegate methods :-
extension UserHomeViewController : UISearchBarDelegate{

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.arrayData = self.array.filter({$0.name.localizedStandardContains(searchBar.text!)})
        self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrayData = self.array
        self.searchBar.resignFirstResponder()
    }
}
