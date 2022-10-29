//
//  WorkoutsViewController.swift
//  Parstagram
//
//  Created by Camila Aichele on 10/29/22.
//

import UIKit
import AlamofireImage

class WorkoutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var TableView: UITableView!
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 self.TableView.reloadData()
                 
                 print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    override func prepare(for segue:
        UIStoryboardSegue, sender: Any?){
        
        print("Loading up the details screen")
        
        // find selected movie
        
        let cell = sender as! UITableViewCell
        let indexPath = TableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // pass selected movie to details view controller
        
        let detailsViewController =
        segue.destination as!
        MovieDetailsViewController
        
        detailsViewController.movie = movie
        
        TableView.deselectRow(at: indexPath, animated: true)
        
    }

}
