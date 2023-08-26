//
//  PhotoPicker.swift
//  SwiftUI-Assignment_1
//
//  Created by Inito on 26/08/23.
//


import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
    @Binding var avatarImage: UIImage
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIImagePickerController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage{
                guard let data = image.jpegData(compressionQuality: 0.5),let compressedImage = UIImage(data: data) else{
                    return
                }
                photoPicker.avatarImage = compressedImage
            }else{
                print("This file does not support")
            }
            picker.dismiss(animated: true)
        }
    }
    
    
}
