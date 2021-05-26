//
//  MembersViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/19/21.
//

import UIKit

class MembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    //MARK: Variables and initializers
    private var membersArray = [String]()
    
    private var groupID = String()
    
    private var isCreator = Bool()
    
    private let popupBox: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.isOpaque = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        return table
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        //button.layer.cornerRadius = 12
        //button.layer.borderWidth = 1
        
        return button
    }()
    
    private let deleteGroupButton: UIButton = {
       let button = UIButton()
        button.setTitle("Delete Group", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .lightGray
        
        return button
    }()
    
    private let leaveGroupButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private let copyGroupIDButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        
        return button
    }()
    
    init(members: [String], groupID: String, isCreator: Bool) {
        membersArray = members
        self.groupID = groupID
        self.isCreator = isCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Code
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        
        self.definesPresentationContext = true
        
        
        // Add tableView
        initTableView()
        setUpTableView()
        
        //Table View Appearance
        self.tableView.backgroundColor = .black
        self.tableView.separatorColor = .white
        
        // Dimsiss view controller
        exitButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        copyGroupIDButton.addTarget(self, action: #selector(copyGroupID), for: .touchUpInside)
        deleteGroupButton.addTarget(self, action: #selector(deleteGroup), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: 35, width: popupBox.width, height: 265)
        tableView.layer.borderWidth = 5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        exitButton.frame = (CGRect(x: 5, y: 10, width: 20, height: 20))
        copyGroupIDButton.frame = CGRect(x: 270, y: 10, width: 20, height: 20)
        if isCreator {
            deleteGroupButton.frame = CGRect(x: 50, y: 305, width: 200, height: 20)
        }
        if !isCreator {
            
        }
        
    }
    // MARK: Functions    
    @objc private func dismissVC() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func copyGroupID() {
        let clipboard = UIPasteboard.general
        clipboard.string = groupID
        groupIDCopied()
    }
    
    @objc private func deleteGroup() {
        // Delete group here
        deleteGroupWarning(completion: { [weak self] bool in
            guard let strongSelf = self else {
                return
            }
            
            if bool {
                // Delete Group
                DatabaseManager.shared.deleteFromGroups(groupID: strongSelf.groupID, completion: { bool in})
                // Include the deleteGroup function
                // Include the deleteGroupID function
                // Create function to remove existing members from group
            }
            else {
                print("testing fucntionality")
            }
        })
    }
    
    //MARK: Table View
    private func setUpTableView() {
        view.addSubview(popupBox)
        popupBox.addSubview(tableView)
        let header = createTableHeader()
        popupBox.addSubview(header)
        popupBox.addSubview(exitButton)
        popupBox.addSubview(copyGroupIDButton)
        popupBox.addSubview(deleteGroupButton)
        
        popupBox.heightAnchor.constraint(equalToConstant: 335).isActive = true
        popupBox.widthAnchor.constraint(equalToConstant: 300).isActive = true
        popupBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func createTableHeader() -> UIView {
        let headerView = UIView(/*frame: CGRect(x: 0, y: popupBox.top, width: popupBox.width, height: 30)*/)
        
        let headerLabel = UILabel(frame: CGRect(x: 100, y: 5, width: 150, height: 22))
        headerLabel.text = "Members"
        headerLabel.font = .boldSystemFont(ofSize: 20)
        headerLabel.textColor = .black
        
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.tableHeaderView = createTableHeader()
        
        //Create table header!!!!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = membersArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}
