//
//  CameraView.swift
//  PictureThis
//
//  Created by Sossio Murolo on 16/11/23.
//

import SwiftUI
import Vision
import AVFoundation
import CoreML


struct PhotoView: UIViewControllerRepresentable {
    
    //queste variabili consentono di passare dati tra ContentView e CameraView
    @State var recognizedObject: String?
    @State var confidence: Double?
    
    /*quando l'utente cattura un'immagine tramite la fotocamera, gli eventi vengono gestiti dalla classe Coordinator, che a sua volta comunica con la vista principale (CameraView) per aggiornare le variabili di stato e avviare il processo di riconoscimento dell'oggetto.
     
     CameraView, che conforma a UIViewControllerRepresentable. Questo consente di incorporare un UIImagePickerController (un view controller UIKit per la cattura di immagini) all'interno di un'interfaccia utente SwiftUI, gestendo al contempo la comunicazione tra SwiftUI e UIKit attraverso il coordinatore (Coordinator).
     */
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        //viene dichiarata una variabile di istanza chiamata parent di tipo CameraView. Questa variabile è cruciale perché manterrà un riferimento all'istanza della vista principale (CameraView) che ha creato questo coordinatore.
        var parent: PhotoView
        
        //il costruttore è utilizzato per stabilire una relazione tra il coordinatore e la vista principale passando un'istanza di CameraView come parametro e assegnandola a una variabile di istanza (parent) del coordinatore. Questo collegamento sarà utile per la comunicazione tra il coordinatore e la vista principale, ad esempio, per passare informazioni o risultati da eventi gestiti dal coordinatore alla vista principale.
        
        init(parent: PhotoView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                recognizeObject(image: uiImage)
            } else {
                parent.recognizedObject = "Error: Unable to get the original image"
                parent.confidence = nil
            }
            
            picker.dismiss(animated: true)
        }
        
        
        
        func recognizeObject(image: UIImage) {
            guard let ciImage = CIImage(image: image) else {
                parent.recognizedObject = "Error: Unable to convert UIImage to CIImage"
                parent.confidence = nil
                return
            }
            
            
            //Va bene ma è deprecato questo modo di iniziliazzare (init)
            
            /*
             guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
             parent.recognizedObject = "Error: Unable to load MobileNetV2 model"
             parent.confidence = nil
             return
             }
             */
            
            // Carica il modello PlantClassifier
            let config = MLModelConfiguration()
            guard let coreMLModel = try? PlantClassifier_2(configuration: config),
                  let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {
                parent.recognizedObject = "Error: Unable to load PlantClassifier model"
                parent.confidence = nil
                return
            }
            
            
            
            
            // Configura la richiesta di riconoscimento di oggetti
            let objectRecognitionRequest = VNCoreMLRequest(model: visionModel) { request, error in
                if let error = error {
                    self.parent.recognizedObject = "Error: \(error.localizedDescription)"
                    self.parent.confidence = nil
                    return
                }
                
                guard let observations = request.results as? [VNClassificationObservation], !observations.isEmpty else {
                    self.parent.recognizedObject = "No object recognized"
                    self.parent.confidence = nil
                    return
                }
                
                // Estrai l'etichetta dell'oggetto riconosciuto
                let recognizedObject = observations.first!.identifier
                let confidence = Double(observations.first!.confidence)
                
                self.parent.recognizedObject = " \(recognizedObject)"
                self.parent.confidence = confidence
                
            }
            
            // Creazione di una richiesta per il riconoscimento di oggetti
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            
            do {
                try requestHandler.perform([objectRecognitionRequest])
            } catch {
                parent.recognizedObject = "Error: \(error.localizedDescription)"
                parent.confidence = nil
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
}


#Preview {
    PhotoView()
}
