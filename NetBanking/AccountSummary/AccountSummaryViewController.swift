//
//  AccountSummaryViewController.swift
//  NetBanking
//
//  Created by JiTHiN on 11/11/24.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    var profile : Profile?
    var accounts : [Account] = []
    
    var headerViewModel = AccountSummaryHeaderView.ViewModel(
        welcomeMessage: "Welcome",
        name: "",
        date: Date()
    )
    var accountCellViewModels : [AccountSummaryCell.ViewModel] = []
    
    
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    var refreshControl = UIRefreshControl()
    
    var isLoaded = false

    var profileManager : ProfileManagable = ProfileManager()
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController {
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    func setupNavigationBar() {
         navigationItem.rightBarButtonItem = logoutBarButtonItem
     }
    private func setupTableView() {
        tableView.backgroundColor = appColour
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView
            .register(
                SkeletonCell.self,
                forCellReuseIdentifier: SkeletonCell.reuseID
            )
        tableView.rowHeight = AccountSummaryCell.rowHieght
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        
        let size = headerView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
    }
    
    private func setupRefreshControl(){
        refreshControl.tintColor = appColour
        refreshControl
            .addTarget(
                self,
                action: #selector(refreshContent),
                for: .valueChanged
            )
        tableView.refreshControl = refreshControl
    }
    private func setupSkeletons(){
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        configureTableCells(with: accounts)
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        let account = accountCellViewModels[indexPath.row]

        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            cell.configure(with: account)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



// MARK: Actions
extension AccountSummaryViewController {
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    private func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }
    
}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchData() {
        let group = DispatchGroup()
        let userId = String(Int.random(in: 1..<4))
        group.enter()
        profileManager.fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
        group.notify(queue: .main){
            self.tableView.refreshControl?.endRefreshing()
            guard let profile = self.profile else { return }
            
            self.isLoaded = true
            self.configureTableHeaderView(with: profile)
            self.configureTableCells(with: self.accounts)
            self.tableView.reloadData()
            
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(accountType: $0.type,
                                         accountName: $0.name,
                                         balance: $0.amount)
        }
    }
    private func showErrorAlert(title: String, description : String) {
        let alert = UIAlertController(title: title ,
                                      message: description,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    private func displayError(_ error : NetworkError){
        switch error{
        case .serverError :
            self.showErrorAlert(title: "Network Error", description: "Please check the network connectivity and try again later")
        case .decodingError :
            self.showErrorAlert(title: "Parsing Error", description: "Unable to parse the data try again later")
        }
    }
}
