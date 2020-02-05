//
//  DetailPostViewController.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import UIKit

class DetailPostViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyText: UITextView!
    var loadingView: UIView!
    
    var viewModel: DetailPostViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLoadingView()
    }
    
    func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.updateUI = { [weak self] state in
            self?.setupView(with: state)
        }
        
        viewModel.getPostDetail()
    }
    
    func updateUI() {
        
    }
    
    func setupView(with state: DetailPostViewModel.ViewState) {
        switch state {
        case .initial: break
        case .loading:
            view.addSubview(loadingView)
        case .success:
            loadingView.removeFromSuperview()
            titleLabel.text = viewModel?.title
            bodyText.text = viewModel?.body
        case .error:
            loadingView.removeFromSuperview()
            showAlert(message: "Error al crear Post")
        }
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
    
    func showAlert(message: String) {
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default)
        let alert = UIAlertController(title: "Error al consultar detalle",
              message: message,
              preferredStyle: .alert)
        alert.addAction(defaultAction)
             
        self.present(alert, animated: true)
    }
}
