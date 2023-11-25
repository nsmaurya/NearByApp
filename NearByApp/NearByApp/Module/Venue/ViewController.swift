//
//  ViewController.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var filterTextLabel: UILabel!

    lazy var interactor: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewState()
        interactor.fetchData()
    }
    
    private func observeViewState() {
        interactor.onViewStateChange = {[weak self] _ in
            self?.onStateChange()
        }
        onStateChange()
    }

    private func onStateChange() {
        if interactor.viewState.isLoading {
            //TODO:: Loading
        }

        switch interactor.viewState {
        case .empty:
            break
        case .ready:
            //TODO:: Load API Data here
            break
        case .error(let error):
            guard let err = error as? NearByError else {
                self.showAlert(error.localizedDescription)
                return
            }
            self.showAlert(err.errorDescription)
        default:
            break
        }
    }

    private func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "NearBy", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Okay", style: .cancel, handler: { _ in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func sliderValueChanged(_ sender: UISlider) {
        
    }
}

