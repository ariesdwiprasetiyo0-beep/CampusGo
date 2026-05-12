import Foundation

struct StudentDTO: Codable {
    let student_id: String
    let full_name: String
    let faculty: String
    let program: String
    let photo_url: String?
    let is_active: Bool

    func toDomain() -> Student {
        Student(
            studentID: student_id,
            fullName: full_name,
            faculty: faculty,
            program: program,
            photoURL: photo_url.flatMap { URL(string: $0) },
            isActive: is_active
        )
    }
}
