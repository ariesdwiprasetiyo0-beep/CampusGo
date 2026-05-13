import Foundation

// MARK: - Mock Campus Buildings
// Coordinates based on Universitas Indonesia, Depok.
// Center campus: -6.3615, 106.8276

struct MockCampusBuildings {

    static let all: [CampusBuilding] = [
        CampusBuilding(
            id: UUID(),
            name: "Balairung Universitas Indonesia",
            shortName: "Balairung",
            category: .administration,
            latitude: -6.3608, longitude: 106.8270,
            description: "Gedung utama dan pusat administrasi tertinggi universitas. Digunakan untuk wisuda, sidang senat, dan acara resmi kenegaraan.",
            facilities: ["Aula 3000 kursi", "Ruang Senat", "Ruang VIP", "Parkir luas"],
            floors: 2,
            openHours: "Sen–Jum 08.00–17.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Fakultas Ilmu Komputer",
            shortName: "FASILKOM",
            category: .academic,
            latitude: -6.3654, longitude: 106.8264,
            description: "Pusat pendidikan Ilmu Komputer dan Sistem Informasi. Dilengkapi laboratorium komputer canggih dan studio riset AI.",
            facilities: ["Lab Pemrograman", "Lab AI & Data Science", "Lab Mobile", "Ruang kuliah ber-AC", "Co-working space"],
            floors: 5,
            openHours: "Sen–Sab 07.00–21.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Fakultas Ekonomi dan Bisnis",
            shortName: "FEB",
            category: .academic,
            latitude: -6.3615, longitude: 106.8302,
            description: "Fakultas dengan akreditasi internasional AACSB. Menyediakan program S1, S2, S3, dan program MBA internasional.",
            facilities: ["Bloomberg Terminal Lab", "Ruang Debat", "Bursa Efek Edukasi", "Perpustakaan Khusus"],
            floors: 6,
            openHours: "Sen–Jum 07.30–20.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Fakultas Kedokteran",
            shortName: "FK UI",
            category: .academic,
            latitude: -6.3578, longitude: 106.8306,
            description: "Salah satu fakultas kedokteran tertua dan terkemuka di Asia Tenggara. Dilengkapi cadaver lab dan simulasi klinik.",
            facilities: ["Cadaver Lab", "Klinik Simulasi", "Perpustakaan Kedokteran", "Skill Lab"],
            floors: 7,
            openHours: "24 jam (area tertentu)"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Perpustakaan Pusat UI",
            shortName: "Perpus Pusat",
            category: .library,
            latitude: -6.3628, longitude: 106.8289,
            description: "Perpustakaan megah berbentuk setengah bola dengan koleksi lebih dari 2 juta judul. Salah satu perpustakaan terbesar di Asia Tenggara.",
            facilities: ["Reading Room 24 jam", "Digital Library", "Discussion Room", "Café Literasi", "Printing Center"],
            floors: 8,
            openHours: "Sen–Sab 08.00–22.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Rektorat Universitas Indonesia",
            shortName: "Rektorat",
            category: .administration,
            latitude: -6.3592, longitude: 106.8278,
            description: "Pusat administrasi dan kebijakan universitas. Tempat kantor rektor, wakil rektor, dan direktorat utama.",
            facilities: ["Ruang Rapat Pleno", "Loket Pelayanan Mahasiswa", "Bank BNI", "ATM Center"],
            floors: 4,
            openHours: "Sen–Jum 08.00–16.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Masjid UI (Ukhuwah Islamiyah)",
            shortName: "Masjid UI",
            category: .worship,
            latitude: -6.3620, longitude: 106.8256,
            description: "Masjid kampus terbesar dengan kapasitas 5.000 jamaah. Arsitektur unik tanpa tiang penyangga di dalam ruang utama.",
            facilities: ["Ruang Shalat Utama", "Ruang Wudhu", "Perpustakaan Islam", "Aula Serbaguna"],
            floors: 2,
            openHours: "04.00–22.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Stasiun UI",
            shortName: "Stasiun UI",
            category: .transportation,
            latitude: -6.3665, longitude: 106.8280,
            description: "Stasiun KRL Commuter Line yang langsung terhubung ke kampus UI. Tersedia feeder bus kampus dari stasiun.",
            facilities: ["Loket KRL", "Halte Bus Kampus", "Parkir Motor", "Minimarket"],
            floors: 1,
            openHours: "04.30–24.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Pusat Kegiatan Mahasiswa",
            shortName: "Pusgiwa",
            category: .administration,
            latitude: -6.3600, longitude: 106.8275,
            description: "Pusat kegiatan seluruh organisasi dan unit kegiatan mahasiswa (UKM) UI. Tempat bermacam komunitas dan klub berkumpul.",
            facilities: ["Sekretariat 50+ UKM", "Ruang Latihan", "Panggung Mini", "Kantin Mahasiswa"],
            floors: 3,
            openHours: "Sen–Sab 08.00–21.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Gedung Olahraga UI",
            shortName: "GOR UI",
            category: .sports,
            latitude: -6.3595, longitude: 106.8250,
            description: "Fasilitas olahraga indoor dan outdoor bertaraf internasional. Venue resmi berbagai kejuaraan nasional.",
            facilities: ["Kolam Renang Olympic", "Lapangan Basket", "Lapangan Badminton", "Gym & Fitness", "Lintasan Atletik"],
            floors: 2,
            openHours: "Sen–Sab 06.00–21.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Klinik Satelit UI",
            shortName: "Klinik UI",
            category: .health,
            latitude: -6.3610, longitude: 106.8300,
            description: "Klinik kesehatan primer untuk mahasiswa, dosen, dan staf UI. Melayani konsultasi umum, gigi, dan psikologi.",
            facilities: ["Poli Umum", "Poli Gigi", "Poli Psikologi", "Apotek", "Laboratorium Klinik"],
            floors: 2,
            openHours: "Sen–Jum 07.30–16.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Asrama Mahasiswa UI",
            shortName: "Rusunawa",
            category: .dormitory,
            latitude: -6.3644, longitude: 106.8240,
            description: "Rumah susun sederhana untuk mahasiswa baru dan penerima beasiswa. Lokasi strategis dalam kawasan kampus.",
            facilities: ["Kamar Ber-AC", "Dapur Bersama", "Laundry", "WiFi Kampus", "Ruang Belajar Bersama"],
            floors: 5,
            openHours: "24 jam"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Kantin Terpadu UI",
            shortName: "Kantin Pusat",
            category: .dining,
            latitude: -6.3630, longitude: 106.8276,
            description: "Pusat kuliner kampus dengan lebih dari 40 tenant makanan dan minuman. Harga terjangkau, buka dari pagi hingga malam.",
            facilities: ["40+ Tenant Makanan", "Food Court Ber-AC", "Area Outdoor", "Parkir Motor", "Mushola"],
            floors: 1,
            openHours: "Sen–Sab 06.00–22.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Fakultas Hukum UI",
            shortName: "FH UI",
            category: .academic,
            latitude: -6.3570, longitude: 106.8285,
            description: "Fakultas hukum tertua di Indonesia, berdiri sejak 1924. Pusat kajian hukum nasional dan internasional.",
            facilities: ["Moot Court Room", "Perpustakaan Hukum", "Legal Aid Center", "Ruang Mediasi"],
            floors: 5,
            openHours: "Sen–Jum 07.30–19.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Fakultas Teknik UI",
            shortName: "FT UI",
            category: .academic,
            latitude: -6.3638, longitude: 106.8312,
            description: "Pusat pendidikan teknik terkemuka dengan 7 departemen. Dilengkapi laboratorium riset dan bengkel terpadu.",
            facilities: ["Lab Material", "Workshop Mesin", "Lab Elektro", "Pusat Riset Energi", "Studio Arsitektur"],
            floors: 6,
            openHours: "Sen–Sab 07.00–20.00"
        ),
        CampusBuilding(
            id: UUID(),
            name: "Puskesmas UI",
            shortName: "Puskesmas UI",
            category: .health,
            latitude: -6.3585, longitude: 106.8260,
            description: "Pusat kesehatan masyarakat yang melayani civitas akademika dan warga sekitar kampus UI.",
            facilities: ["IGD 24 Jam", "Rawat Inap", "Laboratorium", "Ambulans", "Apotek 24 Jam"],
            floors: 3,
            openHours: "24 jam"
        ),
    ]
}
