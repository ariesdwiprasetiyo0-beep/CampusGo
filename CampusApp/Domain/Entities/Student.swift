import Foundation

struct Student: Equatable {
    let studentID: String
    let fullName: String
    let faculty: String
    let program: String
    let photoURL: URL?
    let isActive: Bool
}
