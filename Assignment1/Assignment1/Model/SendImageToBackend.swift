
import Foundation
import UIKit
import Alamofire

class SaveImageToBackend{

    func sendImage(_ image: UIImage){
        let signInURL = "http://apistaging.inito.com/api/v2/auth/sign_in"
        let signInHeaders: HTTPHeaders = [ "Content-Type": "application/json" ]
        let signInParameters: Parameters = [ "truevault_id": "5f69b581-00d1-4378-b353-b20fd9a71c35",
            "truevault_access_token": "v2.000f6984ea614ef3868c74b4ffa9d8f9.30b1e5ec943ab18fb3eb5fb5a405c32cd8c5e2ee4827781a5c311a6b976ec75f" ]

        AF.request(signInURL, method: .post, parameters: signInParameters, encoding: JSONEncoding.default, headers: signInHeaders)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let headers = response.response?.allHeaderFields as? [String: String] {
                        let accessToken = headers["access-token"] ?? ""
                        let uid = headers["uid"] ?? ""
                        let client = headers["client"] ?? ""

                        // Call the function to send the image with the obtained headers
                        self.uploadImage(accessToken: accessToken, uid: uid, client: client, image: image)
                    }
                case .failure(let error):
                    print("Sign In Error: \(error)")
                }
            }
    }



    func uploadImage(accessToken: String, uid: String, client: String, image: UIImage) {
        let uploadURL = "http://apistaging.inito.com/api/v1/tests"
        let uploadHeaders: HTTPHeaders = [
            "Content-Type": "application/json",
            "access-token": accessToken,
            "uid": uid,
            "client": client
        ]
        
       // var testDate = Date().fo
        
        let imageData = image.jpegData(compressionQuality: 1)!
        let uploadParameters: Parameters = [
            "test[done_date]": "2023-08-21",
            "test[batch_qr_code]": "XAN"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "test[images_attributes][][pic]", fileName: "image.jpg", mimeType: "image/jpeg")
            for (key, value) in uploadParameters {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: uploadURL, method: .post, headers: uploadHeaders)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(_):
                print("Image Uploaded Successfully")
            case .failure(let error):
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print("Image Upload Error: \(error)")
                    print("Response String: \(responseString)")
                }
            }
        }
    }


}
