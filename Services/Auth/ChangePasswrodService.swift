import Foundation

class ChangePasswrodService {
    func password(oldPassword: String, newPassword: String) async throws {
        guard let url = URL(string: "\(Constants.baseUrl)/auth/change-password") else {
            throw URLError(.badURL)
        }

        let body = ChangePasswordRequest(oldPassword: oldPassword, newPassword: newPassword)
        
        let token = try await AuthService.shared.validAccessToken()
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("Brak HTTPURLResponse")
            throw URLError(.cannotParseResponse)
        }

        print("Status:", httpResponse.statusCode)
        print("Body:", String(data: data, encoding: .utf8) ?? "brak treści")

        guard (200...299).contains(httpResponse.statusCode) else {
               
            throw URLError(.badServerResponse)
        }
    }
}
