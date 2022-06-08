
struct HomeModel: Codable {
    var needToLogin: Bool
    var user: UserModel?
    var title: String
    var header: String
    var message: String
}
