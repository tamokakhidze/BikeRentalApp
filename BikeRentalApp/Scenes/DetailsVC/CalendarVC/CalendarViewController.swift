//
//  CalendarViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import UIKit
import FirebaseAuth
import PassKit

// MARK: - CalendarViewController

class CalendarViewController: UIViewController {
    
    // MARK: - Ui components and properties

    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let currentDate = gregorianCalendar.component(.day, from: Date())
        let currentMonth = gregorianCalendar.component(.month, from: Date())
        let currentYear = gregorianCalendar.component(.year, from: Date())
        let fromDateComponents = DateComponents(calendar: gregorianCalendar, year: currentYear, month: currentMonth, day: currentDate)
        let toDateComponents = DateComponents(calendar: gregorianCalendar, year: currentYear, month: currentMonth, day: currentDate)
        if let fromDate = fromDateComponents.date, let toDate = toDateComponents.date {
            let calendarViewDateRange = DateInterval(start: fromDate, end: toDate)
            calendarView.availableDateRange = calendarViewDateRange
        }
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.layer.cornerRadius = 20
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "en-US")
        calendarView.fontDesign = .rounded
        return calendarView
    }()
    
    private lazy var startTimeView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .compact
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.locale = Locale(identifier: "ka-GE")
        datePickerView.layer.cornerRadius = 10
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        return datePickerView
    }()
    
    private lazy var endTimeView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .compact
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.locale = Locale(identifier: "ka-GE")
        datePickerView.layer.cornerRadius = 10
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        return datePickerView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var checkAvailabilityButton = CustomButton(title: "Check Availability", hasBackground: true)
    private var rentBikeButton = CustomButton(title: "Rent Bike", hasBackground: true)
    private var viewModel = CalendarViewModel()
    var bike: Bike
    
    private var isBikeAvailable: Bool = false {
        didSet {
            rentBikeButton.isEnabled = isBikeAvailable
        }
    }
    
    // MARK: - Lifecycle

    init(bike: Bike) {
        self.bike = bike
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        viewModel.delegate = self
    }
    
    // MARK: - Ui setup

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(calendarView, startTimeView, endTimeView, checkAvailabilityButton, rentBikeButton, UIView())

        setConstraints()
        
        rentBikeButton.isEnabled = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            calendarView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 400),
            
            startTimeView.widthAnchor.constraint(equalToConstant: 200),
            startTimeView.heightAnchor.constraint(equalToConstant: 50),
            
            endTimeView.widthAnchor.constraint(equalToConstant: 200),
            endTimeView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions

    private func addTargets() {
        checkAvailabilityButton.addTarget(self, action: #selector(checkAvailabilityButtonTapped), for: .touchUpInside)
        rentBikeButton.addTarget(self, action: #selector(rentBikeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func timeChanged() {
        print("Start time: \(startTimeView.date), End time: \(endTimeView.date)")
    }
    
    @objc private func checkAvailabilityButtonTapped() {
        viewModel.checkAvailability(for: bike, startTime: startTimeView.date, endTime: endTimeView.date)
    }
    
    @objc private func rentBikeButtonTapped() {
        guard isBikeAvailable else {
            AlertManager.showAlert(message: "Bike is not available", on: self, title: "Please check availability first")
            return
        }
        viewModel.rentBike(startTime: startTimeView.date, endTime: endTimeView.date, bike: bike)
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension CalendarViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        if self.isBikeAvailable {
            let dateFormatter = ISO8601DateFormatter()
            let startTimeString = dateFormatter.string(from: self.startTimeView.date)
            let endTimeString = dateFormatter.string(from: self.endTimeView.date)
            
            let startTime = startTimeView.date
            let endTime = endTimeView.date
            let diffComponents = Calendar.current.dateComponents([.hour], from: startTime, to: endTime)
            guard let hours = diffComponents.hour else { return  }
            let totalPrice = bike.price * Double(hours)
            
            let bookingInfo: [String: Any] = [
                "startTime": startTimeString,
                "endTime": endTimeString,
                "bikeID": self.bike.id,
                "userID": Auth.auth().currentUser?.uid ?? "",
                "totalPrice": String(format: "%.2f", totalPrice)
            ]
            
            let booking = Booking(dictionary: bookingInfo)
            
            BikeService.shared.rentBike(with: booking) { success, error in
                if success {
                    print("Booking added successfully")
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                    self.navigationController?.pushViewController(SuccessViewController(), animated: false)
                } else {
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
                    } else {
                        print("Booking not available")
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                        AlertManager.showAlert(message: "Bike not available", on: self, title: "please choose other times")
                    }
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CalendarViewModelDelegate

extension CalendarViewController: CalendarViewModelDelegate {
    func showPaymentViewController(viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            if let paymentVC = viewController as? PKPaymentAuthorizationViewController {
                paymentVC.delegate = self
            }
            self.present(viewController, animated: animated)
        }
    }
    
    func updateAvailability(isAvailable: Bool) {
        self.isBikeAvailable = isAvailable
    }
    
    func showAlert(message: String, title: String) {
        AlertManager.showAlert(message: message, on: self, title: title)
    }
}
