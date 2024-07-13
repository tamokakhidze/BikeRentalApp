//
//  DetailsViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 09.07.24.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore

// MARK: - DetailsViewController

final class DetailsViewController: UIViewController {
    
    // MARK: - Ui components and properties

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 20
        mapView.clipsToBounds = true
        return mapView
    }()
    ///To decide: custom stackViewbi mirchevnia tu lazy inicializacia???
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        //let url = URL(string: "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg")
        //imageView.setImage(with: (url ?? URL(string: ""))!)
        imageView.image = .bike
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var featuresCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 0
        let itemWidth: CGFloat = 136
        let itemHeight: CGFloat = 89
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeaturesCell.self, forCellWithReuseIdentifier: FeaturesCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let rentButton = CustomButton(title: "Rent now!", hasBackground: true, width: 200)
    private let allPhotosButton = SmallCustomButton(width: 50, height: 50, backgroundImage: "homeImage", backgroundColor: .white )
    private lazy var backgroundOne = CustomRectangleView(color: .darkBackground)
    private lazy var backgroundTwo = CustomRectangleView(color: .white)
    
    let manager = CLLocationManager()
    var bike: Bike
    private var bikeName: CustomUiLabel?
    
    // MARK: - Lifecycle

    init(bike: Bike) {
        self.bike = bike
        super.init(nibName: nil, bundle: nil)
        self.bikeName = CustomUiLabel(fontSize: 24, text: "\(bike.geometry.capitalized) bike", tintColor: .white, textAlignment: .left)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupUI()
        setDelegates()
        addActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServices()
    }
    
    // MARK: - Ui setup

    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(backgroundOne)
        view.addSubview(backgroundTwo)
        view.addSubview(mainStackView)
        view.addSubview(mainImage)
        
        configureStackViews()
        configureConstraints()
    }
    
    private func configureStackViews() {
        featuresStackView.addArrangedSubviews(
            CustomImageView(width: 16, height: 16, backgroundImage: "homeImage"),
            CustomUiLabel(fontSize: 12, text: "\(bike.price)", tintColor: .white, textAlignment: .left),
            CustomImageView(width: 16, height: 15, backgroundImage: "profileImage"),
            CustomUiLabel(fontSize: 12, text: "\(bike.year)", tintColor: .white, textAlignment: .left),
            allPhotosButton)
        
        mainStackView.addArrangedSubviews(
            bikeName ?? UILabel(),
            featuresStackView,
            CustomUiLabel(fontSize: 24, text: "Features", tintColor: .darkBackground, textAlignment: .left),
            featuresCollectionView,
            rentButton)
    }
    
    private func configureConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        backgroundOne.translatesAutoresizingMaskIntoConstraints = false
        backgroundTwo.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        featuresStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: backgroundTwo.topAnchor),
            
            backgroundOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            backgroundOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOne.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundOne.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundTwo.topAnchor.constraint(equalTo: backgroundOne.topAnchor, constant: 99),
            backgroundTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundTwo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: backgroundOne.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainImage.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 40),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            mainImage.widthAnchor.constraint(equalToConstant: 200),
            mainImage.heightAnchor.constraint(equalToConstant: 105),
            
            featuresStackView.widthAnchor.constraint(equalToConstant: 125),
            
            featuresCollectionView.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
    // MARK: - Actions

    private func addActions() {
        rentButton.addTarget(self, action: #selector(goToCalendarView), for: .touchUpInside)
        allPhotosButton.addTarget(self, action: #selector(showSlider), for: .touchUpInside)
    }
    
    @objc private func goToCalendarView() {
        let vc = CalendarViewController(bike: bike)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showSlider() {
        let vc = SliderPopUpViewController(bike: bike)
        vc.modalPresentationStyle = .popover
        if let popoverController = vc.popoverPresentationController {
            popoverController.delegate = self
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height/4, width: 0, height: 0)
            popoverController.permittedArrowDirections = .any
            vc.preferredContentSize = CGSize(width: 300, height: 400)
            
        }
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Delegates

    private func setDelegates() {
        featuresCollectionView.dataSource = self
        mapView.delegate = self
    }
    
    // MARK: - Location Services

    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {
            print("location services not enabled.")
        }
    }
    
    private func setupLocationManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
}
// MARK: - CLLocationManagerDelegate

extension DetailsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(bike: bike,
                   userLocation: locations.first ?? CLLocation(latitude: CLLocationDegrees(41.7268), longitude: CLLocationDegrees(44.7504)))
        }
    }
    
    func render(bike: Bike, userLocation: CLLocation) {
        let bikeLat = bike.location.latitude
        let bikeLong = bike.location.longitude
        let bikeCoordinate = CLLocationCoordinate2D(latitude: bikeLat, longitude: bikeLong)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)

        let bikeAnnotation = MKPointAnnotation()
        bikeAnnotation.coordinate = bikeCoordinate
        bikeAnnotation.title = "Bike Location"
        mapView.addAnnotation(bikeAnnotation)
        
        let userLocAnnotation = MKPointAnnotation()
        userLocAnnotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        userLocAnnotation.title = "Your location"
        mapView.addAnnotation(userLocAnnotation)
        
        let bikeCLLocation = CLLocation(latitude: bikeLat, longitude: bikeLong)
        let midPoint = midPoint(of: bikeCLLocation, userLocation)
        let region = MKCoordinateRegion(center: midPoint, span: span)
        mapView.setRegion(region, animated: true)
        
        print("mid loc: \(midPoint), bike loc: \(bikeCLLocation), me: \(userLocation) ")
        
    }
}
// MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturesCell.identifier, for: indexPath) as? FeaturesCell
        
        var text = ""
        var icon = ""
        var info = ""
        switch indexPath.row {
        case 0:
            text = "Gears: \(bike.numberOfGears)"
            icon = "gear"
            info = "Smooth Shifting"
        case 1:
            text = "Brake type: \(bike.brakeType.capitalized)"
            icon = "pedal.brake.fill"
            info = "High Performance"
        default:
            text = bike.hasLights ? "With lights" : "No lights"
            icon = bike.hasLights ? "flashlight.on.circle.fill" : "flashlight.slash.circle.fill"
            info = bike.hasLights ? "Safety at Night" : "Daytime Use Only"
        }
        
        cell?.configure(with: text, icon: icon, detailsText: info)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension DetailsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
// MARK: - MKMapViewDelegate

extension DetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "view")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "view")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(resource: .mapPin)
        
        return annotationView
    }
}
