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
    
    var loadingImageView: UIView!
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var bodyInput: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupLoadingViews()
        setupGestures()
        setupViewModel()
        setupInitState()
    }
    
    func setupInitState() {
        setupView(with: .initial)
        setupImageView(with: .initial)
        viewModel.getRandomImage()
    }
    
    func setupImageView() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 0.1
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.clipsToBounds = true
    }
    
    func setupLoadingViews() {
        loadingView = setupLoading(for: self.view)
        loadingImageView = setupLoading(for: self.imageView)
    }
    
    func setupLoading(for parentView: UIView) -> UIView {
        let defaultFrame = CGRect(x: 0, y: 0,
                                  width: parentView.frame.width,
                                  height: parentView.frame.height)
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = defaultFrame
        
        let loadingView = UIView(frame: defaultFrame)
        loadingView.backgroundColor = .white
        
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return loadingView
    }
    
    func setupViewModel() {
        viewModel.updateUI = { [weak self] state in
            self?.setupView(with: state)
        }
        
        viewModel.updateImageUI = { [weak self] state in
           self?.setupImageView(with: state)
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
    
    func setupImageView(with state: CreatePostViewModel.ViewState) {
        switch state {
        case .initial:
            imageView.image = UIImage(named: "placeholder")
        case .loading:
            imageView.addSubview(loadingImageView)
        case .success:
            loadingImageView.removeFromSuperview()
            if let data = viewModel.dataForImage {
                imageView.image = UIImage(data: data)
            }
        case .error:
            loadingImageView.removeFromSuperview()
            imageView.image = UIImage(named: "placeholder")
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
    
    //  MARK: - Gestures
    
    func setupGestures() {
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGestureView(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleGestureView(_ sender: UITapGestureRecognizer) {
        print("gesture here")
        viewModel.getRandomImage()
    }
}
