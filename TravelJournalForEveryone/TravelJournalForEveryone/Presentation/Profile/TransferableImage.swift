//
//  TransferableImage.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 3/8/25.
//
// 현재 사용하지 않는 코드이나 나중에 이미지 확대, 축소 등에서 쓸 수도 있으니 레거시로 남겨두어도 될까요 ?

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
