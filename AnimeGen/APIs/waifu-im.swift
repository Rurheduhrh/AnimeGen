//
//  waifu-im.swift
//  AnimeGen
//
//  Created by cranci on 17/02/24.
//

import UIKit

extension ViewController {
    
    func loadImageFromWaifuIm() {
        startLoadingIndicator()

        let isNSFW = UserDefaults.standard.bool(forKey: "enableExplictiCont")

        let apiEndpoint = "https://api.waifu.im/search"

        var components = URLComponents(string: apiEndpoint)
        components?.queryItems = [
            URLQueryItem(name: "is_nsfw", value: isNSFW ? "true" : "false")
        ]

        guard let url = components?.url else {
            
            if self.alert {
                self.showAlert(withTitle: "Invalid URL", message: "Please wait, the api may be down.", viewController: self)
            }
            
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    
                    if self.alert {
                        self.showAlert(withTitle: "Error!", message: "\(error)", viewController: self)
                    }
                    
                    print("Error: \(error)")
                    self.stopLoadingIndicator()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    
                    if self.alert {
                        self.showAlert(withTitle: "Invalid HTTP response", message: "Please wait, the api may be down.", viewController: self)
                    }
                    
                    print("Invalid HTTP response")
                    self.stopLoadingIndicator()
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    
                    if self.alert {
                        self.showAlert(withTitle: "Invalid status code", message: "\(httpResponse.statusCode)", viewController: self)
                    }
                    
                    print("Invalid status code: \(httpResponse.statusCode)")
                    self.stopLoadingIndicator()
                    return
                }

                do {
                    if let jsonData = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let images = jsonResponse["images"] as? [[String: Any]],
                       let firstImage = images.first,
                       let imageUrlString = firstImage["url"] as? String,
                       let imageUrl = URL(string: imageUrlString),
                       let tagsArray = firstImage["tags"] as? [[String: Any]] {
                        
                        self.currentImageURL = imageUrlString

                        let tags = tagsArray.compactMap { $0["name"] as? String }

                        if let data = try? Data(contentsOf: imageUrl), let newImage = UIImage(data: data) {
                            
                            self.imageView.image = newImage
                            self.animateImageChange(with: newImage)
                            self.addToHistory(image: newImage)
                            
                            self.tagsLabel.isHidden = false

                            self.updateUIWithTags(tags)
                            
                            self.stopLoadingIndicator()
                            
                            self.incrementCounter()
                        } else {
                            
                            if self.alert {
                                self.showAlert(withTitle: "Error!", message: "Failed to load image data.", viewController: self)
                            }
                            
                            print("Failed to load image data.")
                            self.stopLoadingIndicator()
                        }
                    } else {
                        
                        if self.alert {
                            self.showAlert(withTitle: "Error!", message: "Failed to parse JSON response or missing data.", viewController: self)
                        }
                        
                        print("Failed to parse JSON response or missing necessary data.")
                        self.stopLoadingIndicator()
                    }
                }
            }
        }

        task.resume()
    }
    
}
