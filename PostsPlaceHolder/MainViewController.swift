//
//  ViewController.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import UIKit

import RxSwift

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    var loadingView: UIView!
    let identifierCell = "identifierCell"
    let segueDetail = "detailSegue"
    
    var disposeBag = DisposeBag()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupLoadingView()
        setupViewModel()
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Posts"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .default
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func setupLoadingView(){
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
    
    func setupViewModel() {
        
        viewModel.rxPostsObservable
            .bind(to: self.tableView.rx.items(cellIdentifier: identifierCell, cellType: UITableViewCell.self)) { _, element, cell in
                cell.textLabel?.text = String(element.id)
                cell.detailTextLabel?.text = element.body
        }
        .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(Post.self).subscribe(onNext: { value in
//            print("value selected: [\(value)]")
//        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let strongSelf = self else { return }
            strongSelf.tableView.deselectRow(at: index, animated: true)
            strongSelf.performSegue(withIdentifier: strongSelf.segueDetail, sender: index.row)
        }).disposed(by: disposeBag)
        
        viewModel.getPosts()
    }
    
    // MARK: - TODO
    // Manejar States con rxSwift, .loading, .error, etc
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
            showAlert(message: "Error al consultar Posts")
        }
    }
    
    func showAlert(message: String) {
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default)
        let alert = UIAlertController(title: "Consultando Posts",
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

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didSearch(with: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didSearch(with: searchText)
    }
}
