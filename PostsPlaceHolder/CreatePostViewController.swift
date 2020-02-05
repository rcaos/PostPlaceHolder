//
//  CreatePostViewController.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    var viewModel = CreatePostViewModel()
    
    var loadingView: UIView!
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var bodyInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildLoadingView()
        
        setupView(with: .initial)
        setupViewModel()
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
    
    func setupViewModel() {
        viewModel.updateUI = { [weak self] state in
            self?.setupView(with: state)
        }
    }
    
    func setupView(with state: CreatePostViewModel.ViewState) {
        switch state {
        case .initial: break
        case .loading:
            view.addSubview(loadingView)
        case .success:
            loadingView.removeFromSuperview()
            showAlert(message: "Post creado correctamente")
        case .error:
            loadingView.removeFromSuperview()
            showAlert(message: "Error al crear Post")
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
    
    // MARK: - Actions
    
    @IBAction func submitPost(_ sender: Any) {
        guard let title = titleInput.text,
            let body = bodyInput.text,
            !title.isEmpty, !body.isEmpty else { return }
        viewModel.createPost(title: title, body: body)
    }
}
