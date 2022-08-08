//
//  HomePageMovieViewController.swift
//  CinemaFinder


import UIKit

class HomePageMovieViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var array = [MovieModel]()
    
    @IBAction func btnClickAdd(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let vc = UIStoryboard.main.instantiateViewController(withClass: AddMovieViewController.self) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnClickLogout(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.setStart()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        // Do any additional setup after loading the view.
    }

}

extension HomePageMovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.configCell(data: self.array[indexPath.row])
        cell.buttonEdit.addAction(for: .touchUpInside) {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddMovieViewController.self) {
                vc.data = self.array[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        cell.buttonDelete.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("CinemaFinder", actionOkTitle: "Delete", actionCancelTitle: "Cancel", message: "Are you sure you want to delete this movie? ") { (true) in
                self.delete(dataID: self.array[indexPath.row].docID)
            }
        }
        return cell
    }
    





class MovieCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonEdit.layer.cornerRadius = 10.0
        self.buttonDelete.layer.cornerRadius = 10.0
    }
    
    func configCell(data: MovieModel) {
//        self.imageViewProfile.setImgWebUrl(url: data.imagePath, isIndicator: true)
    }
}
