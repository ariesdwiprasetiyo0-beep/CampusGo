import SwiftUI

// MARK: - StudentIDView
struct StudentIDView: View {
    @State private var viewModel: StudentIDViewModel
    @State private var cardFlipped = false

    init(viewModel: StudentIDViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Memuat profil...")
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadProfile() }
                }
            } else if let student = viewModel.student {
                profileContent(student: student)
            } else {
                EmptyStateView(
                    message: "Data mahasiswa tidak ditemukan",
                    icon: "person.crop.circle.badge.questionmark"
                )
            }
        }
        .navigationTitle("Kartu Mahasiswa")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.loadProfile() }
    }

    // MARK: - Main Profile Content
    @ViewBuilder
    private func profileContent(student: Student) -> some View {
        List {
            // ── ID Card Section ────────────────────────────────────────────
            Section {
                IDCardView(student: student, isFlipped: $cardFlipped)
                    .frame(maxWidth: .infinity)
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                Button {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) {
                        cardFlipped.toggle()
                    }
                } label: {
                    Label(
                        cardFlipped ? "Lihat Sisi Depan" : "Tampilkan QR Code",
                        systemImage: cardFlipped ? "creditcard.fill" : "qrcode"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.appAccent)
                .controlSize(.regular)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }

            // ── Academic Info Section ──────────────────────────────────────
            Section("Informasi Akademik") {
                LabeledContent("NPM", value: student.studentID)
                LabeledContent("Nama Lengkap", value: student.fullName)
                LabeledContent("Fakultas", value: student.faculty)
                LabeledContent("Program Studi", value: student.program)
            }

            // ── Status Section ─────────────────────────────────────────────
            Section("Status") {
                HStack {
                    Text("Status Mahasiswa")
                    Spacer()
                    Text(student.isActive ? "Aktif" : "Tidak Aktif")
                        .foregroundStyle(student.isActive ? .green : .red)
                        .fontWeight(.semibold)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - IDCardView
/// The physical-looking student ID card with 3D flip animation.
struct IDCardView: View {
    let student: Student
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            frontFace
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.4
                )

            backFace
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.4
                )
        }
        .frame(height: 210)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Front Face
    private var frontFace: some View {
        ZStack(alignment: .leading) {
            // Background gradient
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.indigo, Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Subtle texture circles
            Circle()
                .fill(.white.opacity(0.07))
                .frame(width: 180)
                .offset(x: -50, y: -70)
            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 130)
                .offset(x: 260, y: 90)

            // Content
            HStack(alignment: .center, spacing: 16) {
                // Avatar
                avatarView
                    .frame(width: 72, height: 72)

                // Text info
                VStack(alignment: .leading, spacing: 5) {
                    Text("KARTU MAHASISWA")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.65))

                    Text(student.fullName)
                        .font(.system(.title3, design: .default, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)

                    Text(student.studentID)
                        .font(.system(.callout, design: .monospaced, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))

                    Text(student.program)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.72))
                        .lineLimit(1)
                }

                Spacer(minLength: 0)
            }
            .padding(22)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.indigo.opacity(0.35), radius: 18, x: 0, y: 8)
    }

    // MARK: - Back Face
    private var backFace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color(.separator), lineWidth: 0.5)
                )

            VStack(spacing: 14) {
                // QR area
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemBackground))
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)

                    Image(systemName: "qrcode")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundStyle(.primary)
                }

                VStack(spacing: 2) {
                    Text(student.studentID)
                        .font(.system(.callout, design: .monospaced, weight: .semibold))
                        .tracking(3)
                    Text("Scan untuk verifikasi identitas")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
    }

    // MARK: - Avatar
    @ViewBuilder
    private var avatarView: some View {
        if let photoURL = student.photoURL {
            AsyncImage(url: photoURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(.white.opacity(0.4), lineWidth: 2))
                default:
                    placeholderAvatar
                }
            }
        } else {
            placeholderAvatar
        }
    }

    private var placeholderAvatar: some View {
        Circle()
            .fill(.white.opacity(0.2))
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.white.opacity(0.85))
            )
            .overlay(Circle().strokeBorder(.white.opacity(0.3), lineWidth: 1.5))
    }
}

// MARK: - DetailRow (backward-compat stub, no longer used as primary component)
struct DetailRow: View {
    let label: String
    let value: String
    var icon: String = "info.circle.fill"
    var color: Color = .appAccent

    var body: some View {
        LabeledContent(label, value: value)
    }
}
