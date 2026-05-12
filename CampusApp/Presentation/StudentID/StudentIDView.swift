import SwiftUI

struct StudentIDView: View {
    @State private var viewModel: StudentIDViewModel

    init(viewModel: StudentIDViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Memuat profil...")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.loadProfile() }
                    }
                } else if let student = viewModel.student {
                    VStack(spacing: 20) {
                        if let photoURL = student.photoURL {
                            AsyncImage(url: photoURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(8)
                                case .failure:
                                    Image(systemName: "person.crop.square")
                                        .font(.system(size: 100))
                                        .foregroundStyle(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            DetailRow(label: "NPM", value: student.studentID)
                            DetailRow(label: "Nama", value: student.fullName)
                            DetailRow(label: "Fakultas", value: student.faculty)
                            DetailRow(label: "Program", value: student.program)
                            DetailRow(label: "Status", value: student.isActive ? "Aktif" : "Tidak Aktif")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        // QR Code placeholder
                        VStack {
                            Image(systemName: "qrcode")
                                .font(.system(size: 100))
                                .foregroundStyle(.gray)
                            Text("QR Code")
                                .font(.caption)
                        }
                        .padding()

                        Spacer()
                    }
                    .padding()
                } else {
                    EmptyStateView(message: "Data mahasiswa tidak ditemukan")
                }
            }
            .navigationTitle("Kartu Mahasiswa")
        }
        .task { await viewModel.loadProfile() }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
        }
    }
}
