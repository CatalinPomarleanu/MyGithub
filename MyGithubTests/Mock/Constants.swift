
let MOCK_USERNAME = "mock_username"
let MOCK_PASSWORD = "mock_password"

let MOCK_USER = User(fullName: "John Snow", userName: MOCK_USERNAME, avatarUrl: "", reposUrl: "", twoFactorAuthentication: false)
let MOCK_WRONG_USER = User(fullName: "John Snow", userName: "_", avatarUrl: "", reposUrl: "", twoFactorAuthentication: false)
let MOCK_PROJECTS = [
    Project(name: "First Project", description: "First Project Description", stars: 1),
    Project(name: "Second Project", description: "Second Project Description", stars: 2)
]
