//
//  ContentView.swift
//  PictureThis
//
//  Created by Sossio Murolo on 14/11/23.
//

import SwiftUI
import AVFoundation
import Vision
import CoreML

struct DetailView: View {
    var capturedImage: UIImage?
    var plantName: String?
    var plantDescription: String?
    
    var onTakeNewPhoto: (() -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let capturedImage = capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .padding()
                }

                if let plantName = plantName {
                    Text(plantName)
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                }

                if let plantDescription = plantDescription {
                    Text(plantDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                }

                // Divider
                Divider()

                // Additional Plant Information
                Section(header: Text("Additional Information").font(.headline)) {
                    Text("Distribution: Mediterranean region")
                    Text("Classification: Magnoliopsida")
                    Text("Characteristics: Evergreen shrub with thorny stems.")
                }

                // Divider
                Divider()

                // Care Instructions
                Section(header: Text("Care Instructions").font(.headline)) {
                    Text("Watering: Regular watering, especially in hot weather.")
                    Text("Sunlight: Full sun to partial shade.")
                    Text("Soil: Well-draining soil.")
                }

                // Spacer for layout spacing
                Spacer()

                // Button to take a new photo
                Button(action: {
                    onTakeNewPhoto?()
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(15)

                        Text("New Photo")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding(.horizontal, 10)
                    }
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            .navigationBarTitle("Plant Details", displayMode: .inline)
        }
    }
}




struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            capturedImage: UIImage(named: "plants"),
            plantName: "Sample Plant",
            plantDescription: "This is a sample plant description."
        )
    }
}



struct ContentView: View {
    
    // State: Questa variabile può essere modificata all'interno della vista stessa. Privata: indica che può essere modificata solo all'interno della vista.
    
    @State private var isCameraPresented = false
    @State private var recognizedObject: String?
    @State private var confidence: Double?
    
    @State private var capturedImage: UIImage?
    @State private var plantName: String?
    @State private var plantDescription: String?
    
    //?: vuol dire che è opzionale il valore, può essere anche nil
    
    
    var body: some View {
        
        VStack{
            
            if let capturedImage = capturedImage,let plantName = plantName, let plantDescription = plantDescription{
                
                DetailView(capturedImage: capturedImage, plantName: plantName, plantDescription: plantDescription,    onTakeNewPhoto: {
                    isCameraPresented.toggle()
                    self.recognizedObject = nil
                    self.confidence = nil
                    self.capturedImage = nil
                    self.plantName = nil
                    self.plantDescription = nil
                }
                )
                
            } else{
                Button(action: {
                    isCameraPresented.toggle()
                }) {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .sheet(isPresented: $isCameraPresented) {
                    CameraView(recognizedObject: $recognizedObject, confidence: $confidence, capturedImage: $capturedImage, plantName: $plantName, plantDescription: $plantDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CameraView: UIViewControllerRepresentable {
    
    //queste variabili consentono di passare dati tra ContentView e CameraView
    @Binding var recognizedObject: String?
    @Binding var confidence: Double?
    @Binding var capturedImage: UIImage?
    @Binding var plantName: String?
    @Binding var plantDescription: String?
    
    /*quando l'utente cattura un'immagine tramite la fotocamera, gli eventi vengono gestiti dalla classe Coordinator, che a sua volta comunica con la vista principale (CameraView) per aggiornare le variabili di stato e avviare il processo di riconoscimento dell'oggetto.
     
     CameraView, che conforma a UIViewControllerRepresentable. Questo consente di incorporare un UIImagePickerController (un view controller UIKit per la cattura di immagini) all'interno di un'interfaccia utente SwiftUI, gestendo al contempo la comunicazione tra SwiftUI e UIKit attraverso il coordinatore (Coordinator).
     */
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        //viene dichiarata una variabile di istanza chiamata parent di tipo CameraView. Questa variabile è cruciale perché manterrà un riferimento all'istanza della vista principale (CameraView) che ha creato questo coordinatore.
        var parent: CameraView
        
        //il costruttore è utilizzato per stabilire una relazione tra il coordinatore e la vista principale passando un'istanza di CameraView come parametro e assegnandola a una variabile di istanza (parent) del coordinatore. Questo collegamento sarà utile per la comunicazione tra il coordinatore e la vista principale, ad esempio, per passare informazioni o risultati da eventi gestiti dal coordinatore alla vista principale.
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                recognizeObject(image: uiImage)
            } else {
                parent.recognizedObject = "Error: Unable to get the original image"
                parent.confidence = nil
                parent.capturedImage = nil
                parent.plantName = nil
                parent.plantDescription = nil
                
            }
            
            picker.dismiss(animated: true)
        }
        
        
        
        func recognizeObject(image: UIImage) {
            guard let ciImage = CIImage(image: image) else {
                parent.recognizedObject = "Error: Unable to convert UIImage to CIImage"
                parent.confidence = nil
                parent.capturedImage = nil
                parent.plantName = nil
                parent.plantDescription = nil
                
                return
            }
            
            // Carica il modello PlantClassifier
            let config = MLModelConfiguration()
            guard let coreMLModel = try? PlantClassifier_3(configuration: config),
                  let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {
                parent.recognizedObject = "Error: Unable to load PlantClassifier model"
                parent.confidence = nil
                parent.capturedImage = nil
                parent.plantName = nil
                parent.plantDescription = nil
                
                return
            }
            
            
            
            // Configura la richiesta di riconoscimento di oggetti
            let objectRecognitionRequest = VNCoreMLRequest(model: visionModel) { request, error in
                if let error = error {
                    self.parent.recognizedObject = "Error: \(error.localizedDescription)"
                    self.parent.confidence = nil
                    self.parent.capturedImage = nil
                    self.parent.plantName = nil
                    self.parent.plantDescription = nil
                    
                    return
                }
                
                guard let observations = request.results as? [VNClassificationObservation], !observations.isEmpty else {
                    self.parent.recognizedObject = "No object recognized"
                    self.parent.confidence = nil
                    self.parent.capturedImage = nil
                    self.parent.plantName = nil
                    self.parent.plantDescription = nil
                    
                    return
                }
                
                // Estrai l'etichetta dell'oggetto riconosciuto
                let recognizedObject = observations.first!.identifier
                let confidence = Double(observations.first!.confidence)
                
                self.parent.recognizedObject = " \(recognizedObject)"
                self.parent.confidence = confidence
                
                self.parent.capturedImage = image
                self.parent.plantName = recognizedObject
                self.parent.plantDescription = "Descrizione della pianta..."
                
            }
            
            // Creazione di una richiesta per il riconoscimento di oggetti
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            
            do {
                try requestHandler.perform([objectRecognitionRequest])
            } catch {
                parent.recognizedObject = "Error: \(error.localizedDescription)"
                parent.confidence = nil
                parent.capturedImage = nil
                parent.plantName = nil
                parent.plantDescription = nil
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



