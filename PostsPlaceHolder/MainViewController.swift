//
//  ViewController.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    var loadingView: UIView!
    let identifierCell = "identifierCell"
    let segueDetail = "detailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        buildLoadingView()
        setupViewModel()
    }
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupViewModel() {
        
        viewModel.updateUI = { [weak self] state in
            self?.setupView(with: state)
        }
        
        viewModel.getPosts()
    }
    
    func buildLoadingView(){
        let defaultFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = defaultFrame
        
        loadingView = UIView(frame: defaultFrame)
        loadingView.backgroundColor = .white
        
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func setupView(with state: MainViewModel.ViewState) {
        switch state {
        case .initial: break
        case .loading:
            view.addSubview(loadingView)
        case .success:
            loadingView.removeFromSuperview()
            tableView.reloadData()
        case .error:
            loadingView.removeFromSuperview()
            showAlert(message: "Error al consultas Posts")
        }
    }
    
    func showAlert(message: String) {
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default)
        let alert = UIAlertController(title: "Create Post",
              message: message,
              preferredStyle: .alert)
        alert.addAction(defaultAction)
             
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueDetail {
            guard let index =  sender as? Int,
            let controllerTo = segue.destination as? DetailPostViewController else { return }
            controllerTo.viewModel = viewModel.buildDetailModel(for: index)
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
        
        cell.textLabel?.text = String( viewModel.posts[indexPath.row].id )
        cell.detailTextLabel?.text = viewModel.posts[indexPath.row].title
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: segueDetail, sender: indexPath.row)
    }
}
