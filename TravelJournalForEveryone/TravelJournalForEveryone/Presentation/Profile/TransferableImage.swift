//
//  TransferableImage.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/8/25.
//
import SwiftUI

enum TransferError: Error {
    case importFailed
}

struct TransferableImage: Transferable {
    let image: Image
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            let image = Image(uiImage: uiImage)
            return TransferableImage(image: image)
        }
    }
}
