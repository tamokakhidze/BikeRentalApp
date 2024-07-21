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
    private lazy var dividers: [UIView] = {
         return (0..<3).map { _ in
             let divider = UIView()
             divider.translatesAutoresizingMaskIntoConstraints = false
             divider.backgroundColor = UIColor(.primaryDeep)
             return divider
         }
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
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var titleLabel = CustomUiLabel(fontSize: 20, text: "Choose start and end times as well as dates", tintColor: .black, textAlignment: .center)
    private var startTitleLabel = CustomUiLabel(fontSize: 20, text: "Start time", tintColor: .black, textAlignment: .center)
    private var endTitleLabel = CustomUiLabel(fontSize: 20, text: "End time", tintColor: .black, textAlignment: .center)
    private var checkAvailabilityButton = CustomButton(title: "Check Availability", hasBackground: true, width: 350)
    private var rentBikeButton = CustomButton(title: "Rent Bike", hasBackground: true, width: 350)
    private var viewModel = CalendarViewModel()
    var bike: Bike
    var isHelmetChosen: Bool
    var helmetPrice: Double
    
    private var isBikeAvailable: Bool = false {
        didSet {
            rentBikeButton.isEnabled = isBikeAvailable
        }
    }
    
    // MARK: - Lifecycle

    init(bike: Bike, isHelmetChosen: Bool, helmetPrice: Double) {
        self.bike = bike
        self.isHelmetChosen = isHelmetChosen
        self.helmetPrice = helmetPrice
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
        
        mainStackView.addArrangedSubviews(titleLabel, dividers[0], startTitleLabel, startTimeView, dividers[1], endTitleLabel, endTimeView, dividers[2], checkAvailabilityButton,rentBikeButton,UIView())
        
        setConstraints()
        
        rentBikeButton.isEnabled = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            dividers[0].widthAnchor.constraint(equalToConstant: 300),
            dividers[0].heightAnchor.constraint(equalToConstant: 0.5),
            
            dividers[1].widthAnchor.constraint(equalToConstant: 300),
            dividers[1].heightAnchor.constraint(equalToConstant: 0.5),
            
            dividers[2].widthAnchor.constraint(equalToConstant: 300),
            dividers[2].heightAnchor.constraint(equalToConstant: 0.5),
            
            startTimeView.widthAnchor.constraint(equalToConstant: 170),
            startTimeView.heightAnchor.constraint(equalToConstant: 50),
            
            endTimeView.widthAnchor.constraint(equalToConstant: 170),
            endTimeView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func addTargets() {
        checkAvailabilityButton.addTarget(self, action: #selector(checkAvailabilityButtonTapped), for: .touchUpInside)
        rentBikeButton.addTarget(self, action: #selector(rentBikeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
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
        viewModel.rentBike(startTime: startTimeView.date, endTime: endTimeView.date, bike: bike, isHelmetChosen: isHelmetChosen)
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
                "bikeID": self.bike.id ?? "",
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
