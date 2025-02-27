//
//  ViewController.swift
//  GH Calculator
//
//  Created by Maria Eduarda Senna on 02/03/20.
//  Copyright © 2020 Maria Eduarda Senna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var subBool = true
    var intraBool = false
    
    var bool4ui = true
    var bool12ui = false
    
    var finalMedicineAmountMin = 0.0
    var finalMedicineAmountMax = 0.0
    
    
    @IBOutlet var helpButton: UIButton!
    
    @IBOutlet var periodTextField: UITextField!
    
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var injectionTypeSegmentedControl: UISegmentedControl!
    
//    @IBOutlet var typeOfInjectionPicker: UIPickerView!
    
    @IBOutlet var medicineTypeSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        periodTextField.delegate = self
        weightTextField.delegate = self
        
        let tapKeyboard = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapKeyboard)
        
        periodTextField.addDoneButtonToKeyboard(myAction: #selector(self.periodTextField.resignFirstResponder))
        
        weightTextField.addDoneButtonToKeyboard(myAction: #selector(self.weightTextField.resignFirstResponder))
        
        periodTextField.borderStyle = UITextField.BorderStyle.roundedRect
        weightTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir", size: 14)!], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir", size: 17)!], for: .selected)

        
//        typeOfInjectionPicker.dataSource = self
//        typeOfInjectionPicker.delegate = self
        
        
//        var typeOfMedicine: Medicine
//        typeOfMedicine = Medicine(injection: "Sub", typeUI: 4)
//
//        var paciente: Patient
//        paciente = Patient(weightParameter: 45, periodParameter: 30)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Subcutânea"
        }
        else {
            return "Intramuscular"
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        periodTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        
        return true

    }
    

     @IBAction func injectionTypeChanged() {

        switch injectionTypeSegmentedControl.selectedSegmentIndex {

        case 0:

            subBool = true
            intraBool = false

        case 1:

            subBool = false
            intraBool = true

        default:

            break

        }

    }
    
    @IBAction func medicineTypeChanged() {
        
        
        switch medicineTypeSegmentedControl.selectedSegmentIndex {
            
        case 0:
            
            bool4ui = true
            bool12ui = false
            
        case 1:
            
            bool4ui = false
            bool12ui = true
            
        default:
            
            break
            
        }
        
    }
    
    
    @IBAction func helpButtonActivate() {
        
        //chama o alerta de ajuda
        makeAlert(title: "Precisa de ajuda?", message: "Profissionais estão disponíveis para ajudá-lo.", buttonText: "Chamar ajuda")
            
    }
    
    
    @IBAction func calculate() {
        
        if (subBool == true) {
            
            //salva o valor retornado da função
            let (resultMinSub, resultMaxSub) = multiplyWeightSub()
            
            //arrendonda os valores para cima
            let resultMinSubInt = Int (resultMinSub.rounded(.up))
            let resultMaxSubInt = Int (resultMaxSub.rounded(.up))
            
            //chama a função que mostra o resultado na label
            resultPopUp(resultMin: resultMinSubInt, resultMax: resultMaxSubInt)
            
        }
        
        else if (intraBool == true) {
            
            let (resultMinIntra, resultMaxIntra) = multiplyWeightIntra()
            
            //arrendonda os valores para cima
            let resultMinIntraInt = Int (resultMinIntra.rounded(.up))
            let resultMaxIntraInt = Int (resultMaxIntra.rounded(.up))
            
            //chama a função que mostra o resultado na label
            resultPopUp(resultMin: resultMinIntraInt, resultMax: resultMaxIntraInt)
            
        }
        
    }
    
    
    func multiplyWeightSub () -> (Double, Double)  {
        
        //lê o que tem no text field;
        let weightSub = weightTextField.text!
        let periodSub = periodTextField.text!
        
        if (weightTextField.text == "" || periodTextField.text == "") {
            
            makeAlert(title: "Dados incompletos", message: "Preencha todos os campos antes de calcular.", buttonText: "OK")
            return (finalMedicineAmountMin, finalMedicineAmountMax)
            
        }
        
        //transformar texto em Int
        let weightSubInt = Int (weightSub)!
        let periodSubInt = Int (periodSub)!
        
        let weightSubDouble = Double (weightSubInt)
        let periodSubDouble = Double (periodSubInt)
        
        //multiplicar o peso lido pelos valores padrões da injeção subcutânea; obtem dosagem;
        let dosageSubMin = weightSubDouble * 0.07
        let dosageSubMax = weightSubDouble * 0.1
        
        //multiplicar a dosagem calculada pelo período (dias);
        let totalDaysSubMin = dosageSubMin * periodSubDouble
        let totalDaysSubMax = dosageSubMax * periodSubDouble
        
        if bool4ui == true {
            
            let (temporaryMedicineAmountMin, temporaryMedicineAmountMax) = divideTotalDaysBy4ui(totalDaysMin: totalDaysSubMin, totalDaysMax: totalDaysSubMax)
            
            finalMedicineAmountMin = temporaryMedicineAmountMin
            finalMedicineAmountMax = temporaryMedicineAmountMax
            
        }
        
        else if bool12ui == true {
            
            let (temporaryMedicineAmountMin, temporaryMedicineAmountMax) = divideTotalDaysBy12ui(totalDaysMin: totalDaysSubMin, totalDaysMax: totalDaysSubMax)
            
            finalMedicineAmountMin = temporaryMedicineAmountMin
            finalMedicineAmountMax = temporaryMedicineAmountMax
            
        }
        
        
        return (finalMedicineAmountMin, finalMedicineAmountMax)
        
        finalMedicineAmountMin = 0.0
        finalMedicineAmountMax = 0.0
        
    }
    
    func multiplyWeightIntra () -> (Double, Double) {
        
        //lê o que tem nos text fields;
        let weightIntra = weightTextField.text!
        let periodIntra = periodTextField.text!
        
        if (weightTextField.text == "" || periodTextField.text == "") {
            
            makeAlert(title: "Dados incompletos", message: "Preencha todos os campos antes de calcular.", buttonText: "OK")
            return (finalMedicineAmountMin, finalMedicineAmountMax)
            
        }
        
        //transformar texto em Int
        let weightIntraInt = Int (weightIntra)!
        let periodIntraInt = Int (periodIntra)!
        
        let weightIntraDouble = Double (weightIntraInt)
        let periodIntraDouble = Double (periodIntraInt)
        
        //multiplicar o peso lido pelos valores padrões da injeção intramuscular; obtem dosagem;
        let dosageIntraMin = weightIntraDouble * 0.14
        let dosageIntraMax = weightIntraDouble * 0.2
        
        //multiplicar a dosagem calculada pelo período (dias);
        let totalDaysIntraMin = dosageIntraMin * periodIntraDouble
        let totalDaysIntraMax = dosageIntraMax * periodIntraDouble
        
        if bool4ui == true {
            
            let (temporaryMedicineAmountMin, temporaryMedicineAmountMax) = divideTotalDaysBy4ui(totalDaysMin: totalDaysIntraMin, totalDaysMax: totalDaysIntraMax)
            
            finalMedicineAmountMin = temporaryMedicineAmountMin
            finalMedicineAmountMax = temporaryMedicineAmountMax
            
        }
        
        else if bool12ui == true {
            
            let (temporaryMedicineAmountMin, temporaryMedicineAmountMax) = divideTotalDaysBy12ui(totalDaysMin: totalDaysIntraMin, totalDaysMax: totalDaysIntraMax)
            
            finalMedicineAmountMin = temporaryMedicineAmountMin
            finalMedicineAmountMax = temporaryMedicineAmountMax
            
        }
        
        
        return (finalMedicineAmountMin, finalMedicineAmountMax)
        
        finalMedicineAmountMin = 0.0
        finalMedicineAmountMax = 0.0
        
    }
    
    func divideTotalDaysBy4ui (totalDaysMin: Double, totalDaysMax: Double) -> (Double, Double) {
        
        let medicineAmountMin = (totalDaysMin/4)
        let medicineAmountMax = (totalDaysMax/4)
        
        return (medicineAmountMin, medicineAmountMax)
        
    }
    
    func divideTotalDaysBy12ui (totalDaysMin: Double, totalDaysMax: Double) -> (Double, Double) {
        
        let medicineAmountMin = (totalDaysMin / 12)
        let medicineAmountMax = (totalDaysMax / 12)
        
        return (medicineAmountMin, medicineAmountMax)
        
    }
    
    
    func makeAlert (title: String, message:String, buttonText: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString(buttonText, comment: "Default action"), style: .cancel, handler: { _ in NSLog("The \"OK\" alert occured.") } )
        action.setValue(UIColor(red: CGFloat(6)/255, green: CGFloat(203)/255, blue: CGFloat(179)/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(action)
        
        self.present(alert, animated: true) {
            
            alert.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            
        }
        
    }
    
    
    func resultPopUp (resultMin: Int, resultMax: Int) {
        
        //mudar a palavra medicamento
        
        let alert = UIAlertController(title: "Você deve retirar de \n \(resultMin) a \(resultMax) \n medicamentos", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Finalizar", comment: "Default action"), style: .cancel, handler: {(action : UIAlertAction ) in
            //reinicializa todos os campos (tanto text fields quanto segmented controls)
            self.periodTextField.text = nil
            self.weightTextField.text = nil
//            self.injectionTypeSegmentedControl.selectedSegmentIndex = 0
            self.medicineTypeSegmentedControl.selectedSegmentIndex = 0
        } )
        action.setValue(UIColor(red: CGFloat(6)/255, green: CGFloat(203)/255, blue: CGFloat(179)/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func dismissOnTapOutside(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func restart () {
        
        //zerar todos os campos para reiniciar o cálculo;
        makeAlert(title: "Tem certeza que deseja limpar?", message: "", buttonText: "Reiniciar")
        
    }
        
}

//class Medicine {
//    ///Possible values: "Sub", "Intra"
//    var injection: String
//    ///Possible values: 4, 12
//    var typeUI: Int
//
//    init(injection: String, typeUI: Int) {
//        self.injection = injection
//        self.typeUI = typeUI
//    }
//
//    func whichCalculation() -> Int {
//        let
//    }
//
//}

//função que vai criar o botão de ok no teclado
extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
