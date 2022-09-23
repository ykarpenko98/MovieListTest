import Foundation

enum FileType {
    case fileUrl(URL)
    case data(Data)
}

enum MimeType: String {
    case png = "image/png"
    case jpeg = "image/jpeg"
}

struct UploadDataModel {
    let file: FileType
    let name: String
    let fileName: String
    let mimeType: MimeType
}
