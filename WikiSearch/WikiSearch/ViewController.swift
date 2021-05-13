//
//  ViewController.swift
//  WikiSearch
//
//  Created by Mac1 on 12/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var WebView: WKWebView!
    @IBOutlet weak var buscarTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
         let urlWikipedia = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Wikipedia-logo-v2-es.svg/1200px-Wikipedia-logo-v2-es.svg.png")
        WebView.load(URLRequest(url: urlWikipedia!))
        
        // Do any additional setup after loading the view.
    }
    @IBAction func buscarpalabraButton(_ sender: UIButton) {
        buscarTextField.resignFirstResponder()
        guard let palabraAbuscar = buscarTextField.text else { return  }
        buscarWikipedia(palabras: palabraAbuscar)
        
        
        
    }
    func buscarWikipedia(palabras: String)  {
        if let urlApi = URL(string: "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras.replacingOccurrences(of: " ", with: "%20"))"){
            let peticion = URLRequest(url: urlApi)
            let tarea = URLSession.shared.dataTask(with: peticion) { (datos, respuesta, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    do {
                        let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let querySubJson = json["query"] as! [String: Any]
                        
                        let pagesSubJson = querySubJson["pages"] as! [String: Any]
                        
                        let pageId = pagesSubJson.keys
                        
                        let llaveExtracto = pageId.first!
    
                        let idSubJson = pagesSubJson[llaveExtracto] as! [String: Any]
                        
                        if let extracto = idSubJson["extract"] as? String {
                            
                            DispatchQueue.main.async {
                                self.WebView.loadHTMLString(extracto, baseURL: nil)
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.WebView.loadHTMLString("<H1>No se pudo encontrar el resultado!</H1>", baseURL: nil)
                            }
                        }
                        
                        
                        
                        print("El objeto JSON es: \(idSubJson)")
                    } catch  {
                        print("Error al procesar el Json \(error.localizedDescription)")
                    }
                }
            }
            tarea.resume()
        }
    }
    
}


