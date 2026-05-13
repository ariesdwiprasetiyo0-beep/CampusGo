import Foundation

// MARK: - Mock Event Repository
final class MockEventRepository: EventRepository {

    private let allEvents: [CampusEvent] = {
        let calendar = Calendar.current
        let now = Date()

        func date(daysAhead: Int, hour: Int, minute: Int = 0) -> Date {
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.day! += daysAhead
            components.hour = hour
            components.minute = minute
            return calendar.date(from: components) ?? now
        }

        return [
            CampusEvent(
                id: UUID(),
                title: "Orientasi Mahasiswa Baru 2026",
                description: "Acara pengenalan kampus untuk mahasiswa baru Angkatan 2026. Kegiatan meliputi pengenalan fasilitas, organisasi kampus, dan sesi tanya jawab dengan dekan.",
                date: date(daysAhead: 1, hour: 8, minute: 0),
                location: "Auditorium Gedung A",
                category: .orientation
            ),
            CampusEvent(
                id: UUID(),
                title: "Seminar Nasional Kecerdasan Buatan",
                description: "Seminar membahas perkembangan AI terkini dan implikasinya terhadap dunia industri. Pembicara dari Google dan Gojek akan hadir.",
                date: date(daysAhead: 3, hour: 9, minute: 0),
                location: "Aula Rektorat Lt. 2",
                category: .academic
            ),
            CampusEvent(
                id: UUID(),
                title: "Festival Budaya Nusantara",
                description: "Pameran seni dan budaya daerah dari 34 provinsi di Indonesia. Ada pertunjukan tari tradisional, kuliner, dan pakaian adat.",
                date: date(daysAhead: 5, hour: 10, minute: 0),
                location: "Lapangan Utama Kampus",
                category: .cultural
            ),
            CampusEvent(
                id: UUID(),
                title: "Turnamen Futsal Antar Fakultas",
                description: "Kompetisi futsal bergengsi antar fakultas se-universitas. Daftarkan timmu dan raih piala juara umum!",
                date: date(daysAhead: 7, hour: 7, minute: 30),
                location: "GOR Olahraga Kampus",
                category: .sports
            ),
            CampusEvent(
                id: UUID(),
                title: "Workshop Pengembangan Aplikasi Mobile",
                description: "Workshop hands-on membangun aplikasi iOS dan Android dari nol. Peserta diharapkan membawa laptop. Kuota terbatas 50 orang.",
                date: date(daysAhead: 8, hour: 13, minute: 0),
                location: "Lab Komputer Gedung C, Lt. 3",
                category: .academic
            ),
            CampusEvent(
                id: UUID(),
                title: "Malam Keakraban FASILKOM",
                description: "Acara keakraban seluruh civitas akademika Fakultas Ilmu Komputer. Ada hiburan, games, dan doorprize menarik.",
                date: date(daysAhead: 10, hour: 18, minute: 30),
                location: "Gedung Serbaguna FASILKOM",
                category: .cultural
            ),
            CampusEvent(
                id: UUID(),
                title: "Kuliah Umum: Transformasi Digital",
                description: "Kuliah umum bersama Menteri Komunikasi dan Informatika membahas roadmap transformasi digital Indonesia 2025-2045.",
                date: date(daysAhead: 12, hour: 10, minute: 0),
                location: "Auditorium Pusat, Kapasitas 1000",
                category: .academic
            ),
            CampusEvent(
                id: UUID(),
                title: "Lomba Lari 5K Campus Run",
                description: "Ikuti lomba lari menyusuri kawasan kampus sepanjang 5 kilometer. Terbuka untuk mahasiswa, dosen, dan staf. Hadiah total Rp 10 juta.",
                date: date(daysAhead: 14, hour: 6, minute: 0),
                location: "Gerbang Utama Kampus",
                category: .sports
            ),
            CampusEvent(
                id: UUID(),
                title: "Pameran Karya Tugas Akhir",
                description: "Pameran hasil karya tugas akhir mahasiswa tingkat akhir dari berbagai program studi. Terbuka untuk umum.",
                date: date(daysAhead: 16, hour: 9, minute: 0),
                location: "Lobby Gedung Rektorat",
                category: .academic
            ),
            CampusEvent(
                id: UUID(),
                title: "Pekan Orientasi Organisasi Mahasiswa",
                description: "Kesempatan bagi mahasiswa baru untuk mengenal dan bergabung dengan berbagai UKM dan organisasi mahasiswa kampus.",
                date: date(daysAhead: 2, hour: 13, minute: 0),
                location: "Taman Kampus & Parkir Selatan",
                category: .orientation
            ),
        ]
    }()

    func fetchUpcoming(limit: Int) async throws -> [CampusEvent] {
        try await Task.sleep(for: .milliseconds(700))
        let sorted = allEvents
            .filter { $0.date >= Date() }
            .sorted { $0.date < $1.date }
        return Array(sorted.prefix(limit))
    }

    func fetchAll() async throws -> [CampusEvent] {
        try await Task.sleep(for: .milliseconds(700))
        return allEvents.sorted { $0.date < $1.date }
    }

    func save(_ events: [CampusEvent]) async throws {
        // No-op for mock
    }
}
