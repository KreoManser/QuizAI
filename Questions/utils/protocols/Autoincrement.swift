struct IntAutoincrementId: Codable {
    private static var currentId: Int = 0
    private let id: Int

    init() {
        self.id = IntAutoincrementId.currentId
        IntAutoincrementId.currentId += 1
    }

    init(from decoder: Decoder) throws {
        self.id = IntAutoincrementId.currentId
        IntAutoincrementId.currentId += 1
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(id)
    }

    func getId() -> Int {
        return self.id
    }
}
