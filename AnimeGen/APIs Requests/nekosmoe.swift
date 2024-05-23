//
//  nekosmoe.swift
//  AnimeGen
//
//  Created by cranci on 18/02/24.
//

import UIKit

extension ViewController {

    func loadImageFromNekosMoe() {
        startLoadingIndicator()

        let isNSFW = UserDefaults.standard.bool(forKey: "explicitContents")

        let apiEndpoint = "https://nekos.moe/api/v1/random/image"

        guard var components = URLComponents(string: apiEndpoint) else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        components.queryItems = [URLQueryItem(name: "nsfw", value: isNSFW.description.lowercased())]

        guard let url = components.url else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil,
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let jsonData = data,
                    let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                    let images = jsonResponse["images"] as? [[String: Any]],
                    let firstImage = images.first,
                    let imageId = firstImage["id"] as? String,
                    let tagsArray = firstImage["tags"] as? [String] else {
                        print("Failed to get valid response.")
                        self.stopLoadingIndicator()
                        return
                }

                self.updateUIWithTags(tagsArray)
                self.loadImage(with: imageId, tags: tagsArray)
            }
        }

        task.resume()
    }

    private func loadImage(with imageId: String, tags: [String]?) {
        var components = URLComponents(string: "https://nekos.moe/thumbnail/\(imageId)")
        if let tags = tags {
            components?.queryItems = [URLQueryItem(name: "tags", value: tags.joined(separator: ","))]
        }

        guard let url = components?.url else {
            print("Invalid URL")
            stopLoadingIndicator()
            return
        }

        let imageRequest = URLRequest(url: url)

        let imageTask = URLSession.shared.dataTask(with: imageRequest) { (imageData, _, imageError) in
            DispatchQueue.main.async {
                if let imageError = imageError {
                    print("Image loading error: \(imageError)")
                } else if let imageData = imageData, let newImage = UIImage(data: imageData) {
                    self.imageView.image = newImage
                    self.addToHistory(image: newImage)
                    self.animateImageChange(with: newImage)
                    if let tags = tags {
                        self.addImageToHistory(image: newImage, tags: tags)
                    }
                    self.incrementCounter()
                    
                    if self.moetags {
                        self.tagsLabel.isHidden = false
                    } else {
                        self.tagsLabel.isHidden = true
                    }
                } else {
                    print("Failed to load image data.")
                }
                self.stopLoadingIndicator()
            }
        }

        imageTask.resume()
    }
}
