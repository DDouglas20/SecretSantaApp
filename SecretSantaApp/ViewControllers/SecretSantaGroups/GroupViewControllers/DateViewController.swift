//
//  DateViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/28/21.
//

import UIKit

class DateViewController: UIViewController {
    
    //MARK: Variables
    private var chosenDate = Date()
    
    private var didEnd = false
    
    private var timer = Timer()
    
    private let currentDateElements = Calendar.current
    
    private var isCreator = Bool()
    
    private var dateString = String()
    
    //private var giftBought = Bool()
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        picker.backgroundColor = .clear
        picker.tintColor = .systemGreen
        picker.locale = .current
        picker.layer.borderColor = UIColor.clear.cgColor
        //picker.minimumDate = .distantPast
        //picker.maximumDate = .distantFuture
        
        
        return picker
    }()
    
    private var tempDate: UILabel = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        
        let formatter = DateFormatter()
        formatter.calendar = picker.calendar
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        var dateStringLabel = UILabel()
        dateStringLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 300, height: 50))
        dateStringLabel.text = dateString
        dateStringLabel.font = .boldSystemFont(ofSize: 30)
        dateStringLabel.textColor = .black
        
        return dateStringLabel
    }()
    
    private let timerLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 45)
        
        return label
    }()
    
    private let timeLeftLabel: UILabel = {
       let label = UILabel()
        label.text = "Time Left:"
        label.font = .boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private var dateLabel: UILabel = {
        var dateStringLabel = UILabel()
        dateStringLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 250, height: 50))
        dateStringLabel.text = UserDefaults.standard.value(forKey: "date") as? String
        dateStringLabel.font = .boldSystemFont(ofSize: 30)
        dateStringLabel.textColor = .black
        dateStringLabel.backgroundColor = .lightGray
        
        return dateStringLabel
    }()
    
    private let headerLabel: UILabel = {
       var header = UILabel()
        header = UILabel(frame: CGRect(x: 90, y: 5, width: 150, height: 22))
        header.text = "Event End Date"
        header.font = .boldSystemFont(ofSize: 20)
        header.textColor = .black
        
        return header
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
    
    private let popupBox: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.isOpaque = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: UI Code
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        // Set up popUpBox
        setUpView()
        
        
        // Button Actions
        if isCreator {
            datePicker.addTarget(self, action: #selector(getDateFromPicker(sender:)), for: .valueChanged)
            datePicker.addTarget(self, action: #selector(unhidePicker(sender:)), for: .touchDown)
            datePicker.addTarget(self, action: #selector(hidePicker(sender:)), for: .touchUpOutside)
        }
        exitButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exitButton.frame = (CGRect(x: 5, y: 10, width: 20, height: 20))
        datePicker.frame = (CGRect(x: 50, y: 50, width: 250, height: 50))
        timeLeftLabel.frame = CGRect(x: 75, y: 125, width: 300, height: 50)
        timerLabel.frame = CGRect(x: 75, y: timeLeftLabel.bottom + 10, width: 300, height: 50)
    }
    
    //MARK: Initializer
    init(isCreator: Bool) {
        //self.giftBought = giftBought
        self.isCreator = isCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    private func setUpView() {
        view.addSubview(popupBox)
        popupBox.addSubview(headerLabel)
        popupBox.addSubview(exitButton)
        popupBox.addSubview(timeLeftLabel)
        popupBox.addSubview(timerLabel)
        if dateLabel.text == nil {
            print("We eneter if branch")
            popupBox.addSubview(tempDate)
            popupBox.bringSubviewToFront(tempDate)
        }
        else {
            popupBox.addSubview(dateLabel)
            popupBox.bringSubviewToFront(dateLabel)
        }
        popupBox.addSubview(datePicker)
        popupBox.sendSubviewToBack(datePicker)
        
        
        popupBox.heightAnchor.constraint(equalToConstant: 335).isActive = true
        popupBox.widthAnchor.constraint(equalToConstant: 300).isActive = true
        popupBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func dismissVC() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*@objc private func showDateString(sender: UIDatePicker) -> UILabel {
        let formatter = DateFormatter()
        formatter.calendar = datePicker.calendar
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        
        var dateStringLabel = UILabel()
        dateStringLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 300, height: 50))
        dateStringLabel.text = dateString
        dateStringLabel.font = .boldSystemFont(ofSize: 30)
        dateStringLabel.textColor = .black
        
        return dateStringLabel
    }*/
    
    @objc private func getDateFromPicker(sender: UIDatePicker)  {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.chosenDate = datePicker.date
        runTimer()
        let dateString = formatter.string(from: datePicker.date)
        self.dateString = dateString
        dateLabel.text = self.dateString
        UserDefaults.standard.setValue(dateLabel.text, forKey: "date")
        
        dateSuccessfullySet()
        print("We're moving past this")
        print("This is datestring label: \(dateLabel.text)")
    }
    
    private func createDateStringLabel() -> UILabel {
        var dateStringLabel = UILabel()
        dateStringLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 300, height: 50))
        dateStringLabel.text = dateString
        dateStringLabel.font = .boldSystemFont(ofSize: 30)
        dateStringLabel.textColor = .black
        
        return dateStringLabel
    }
    
    private func dateWarnings(date: Date, calendar: Calendar, chosenDate: DateComponents) {
        let dateComponents = calendar.dateComponents([.month, .day, .year], from: date)
        
        let year = dateComponents.year
        let month = dateComponents.month
        let day = dateComponents.day
        
        if (month == chosenDate.month && day == chosenDate.day && year == chosenDate.year) {
            // Show Time's Up Alert & Notification
        }
        
        // Every week send a notification if gift hasn't been bought
    }
    
    @objc private func updateTimer() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        
        let difference = Calendar.current.dateComponents([.month, .day, .hour], from: datePicker.date, to: chosenDate)
        let monthsOptional = difference.month
        let daysOptional = difference.day
        let hoursOptional = difference.hour
        
        guard let months = monthsOptional,
              let days = daysOptional,
              let hours = hoursOptional else {
            return
        }
        
        self.timerLabel.text = "\(months) : \(days) : \(hours)"
        if datePicker.date == chosenDate {
            didEnd = true
            timer.invalidate()
        }
        
    }
    
    private func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1,target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true )
    }
    
    @objc private func unhidePicker(sender: UIDatePicker) {
        datePicker.tintColor = .link
    }
    
    @objc private func hidePicker(sender: UIDatePicker) {
        datePicker.tintColor = .clear
    }
    
    @objc private func datePicker(datePicker: UIDatePicker) -> DateComponents {
        let chosenDate = datePicker.calendar.dateComponents([.month, .day, .year], from: datePicker.date)
        
        return chosenDate
    }
}
