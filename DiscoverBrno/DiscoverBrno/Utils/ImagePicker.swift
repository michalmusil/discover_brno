//
//  ImagePicker.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.allowsEditing = true
        viewController.sourceType = .camera
        viewController.delegate = context.coordinator
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // DO NOTHING
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        @Binding var isPresented: Bool
        @Binding var image: UIImage?
        
        init(isPresented: Binding<Bool>, image: Binding<UIImage?>) {
            self._isPresented = isPresented
            self._image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }
    }
}
