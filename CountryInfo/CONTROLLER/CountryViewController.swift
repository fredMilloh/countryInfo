//
//  CountryViewController.swift
//  CountryInfo
//
//  Created by fred on 30/04/2020.
//  Copyright © 2020 fred. All rights reserved.
//
// pour la webView :    import WebKit
//                      création UIView (flagView)
//                      Création WKWebView (flagWebView)
//                      Constraints des 2 views (top, bottom, leading, tralling equals)
//                      initialiser classe WKWebView()
//                      Méthode .load pour charger la webView avec URLRequest
//                      essai scrollView sur flag
//                  pb: pas réussi à redimensionner la webView à la UIView
//
import Foundation
import UIKit
import WebKit

class CountryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var labelInfo: UILabel!

    @IBOutlet weak var flagView: UIView!
    var flag: WKWebView = WKWebView()

    @IBOutlet weak var flagWebView: WKWebView!
    @IBOutlet weak var dataStackView: UIStackView!

    @IBOutlet weak var nameData: UILabel!
    @IBOutlet weak var regionData: UILabel!
    @IBOutlet weak var subregionData: UILabel!
    @IBOutlet weak var capitalData: UILabel!
    @IBOutlet weak var populationData: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var languageData: UILabel!

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        getCountries()
        setupPickerView()
        flag.scrollView.automaticallyAdjustsScrollIndicatorInsets = true
    }

//MARK: - pickerView methods

    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), forKey: "textColor")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
        return countries[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        goButton.setTitle(countries[row].name, for: .normal)
    }

//MARK: - pickerView data

    var countries = [Country]()

    func getCountries() {
        let url = URL(string: "https://restcountries.com/v2/all")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
         DispatchQueue.main.async {
            if error == nil {
                do {
                    self.countries = try JSONDecoder().decode([Country].self, from: data!)
                } catch {
                    print("parse error")
                }
                self.pickerView.reloadComponent(0)
            }
         }
        }.resume()
    }

//MARK: - buttons methods

    @IBAction func goButtonPressed(_ sender: UIButton) {

            let selectedCountry = goButton.title(for: .normal)
        QueryService.shared.getCountryDetails(domain: selectedCountry!) { (result) in

            switch result {
            case .failure(let error) :
                print(error)
            case .success(let countryDetails) :
                self.updateData(countryDetails: countryDetails)

                self.getFlag(flagUrl: countryDetails[0].flag)

                self.toggleObjet(actual: true)
            }
        }
    }

    @IBAction func autrePaysButtonPressed(_ sender: UIButton) {
        toggleObjet(actual: false)
    }

//MARK: - other methods

    private func updateData(countryDetails: ([CountryData])) {
        let info = countryDetails[0]
        nameData.text = "Pays : " + info.name
        regionData.text = "Région : " + info.region
        subregionData.text = "Sous Région : " + info.subregion
        capitalData.text = "Capitale : " + info.capital
        populationData.text = "Population : " + String(info.population) + " personnes"
        currencyName.text = "Monnaie : " + info.currencies[0].name
        if info.currencies[0].symbol == nil {
            currencySymbol.text = "Symbole inconnu"
            } else {
            currencySymbol.text = "Symbole Monnaie : " + info.currencies[0].symbol!
        }
        languageData.text = "Langue : " + info.languages[0].name
    }

    private func getFlag(flagUrl: String) {
        if let url = URL(string: flagUrl) {
            let request = URLRequest(url: url)
        self.flagWebView.load(request)
        }
    }

    private func toggleObjet(actual: Bool) {
        labelInfo.isHidden = actual
        goButton.isHidden = actual
        dataStackView.isHidden = !actual
        returnButton.isHidden = !actual
        flagView.isHidden = !actual
        flagWebView.isHidden = !actual
        pickerView.isHidden = actual
    }

//MARK: - alert

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The country download failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}
