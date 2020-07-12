import Danger

let danger = Danger()

// MARK: - Swiftlint
SwiftLint.lint(.all(directory: nil), inline: true)

// MARK: - Properties
let additions = danger.github.pullRequest.additions! 
let deletions = danger.github.pullRequest.deletions!
let changedFiles = danger.github.pullRequest.changedFiles!

let modified = danger.git.modifiedFiles
let editedFiles = modified + danger.git.createdFiles
let prTitle = danger.github.pullRequest.title

// MARK: - Validate
let validator = Validator()
validator.validate()

// MARK: - Validation rules
protocol ValidatorBuilder {
    func validate()
}

struct Validator: ValidatorBuilder {

    func validate() {
        checkSize()
        checkContent()
        checkTitle()
        checkModifiedFiles()
        checkTests()

        logResume()
    }

    private func checkSize() {
        if (additions + deletions) > ValidationRules.bigPRThreshold.hashValue {
            let message = """
                PR size seems relatively large.
                If this PR contains multiple changes, please split each into separate PR will helps faster, easier review.
            """
            fail(message)
        }
    }

    private func checkContent() {
        let message = "PR has no description. You should provide a description of the changes that you have made."

        guard let body = danger.github.pullRequest.body else { return
            fail(message)
        }

        if body.isEmpty {
            fail(message)
        }
    }

    private func checkTitle() {
        if prTitle.contains("WIP") {
            warn("PR is classed as Work in Progress.")
        }

        if prTitle.count < ValidationRules.minPRTitle.hashValue {
            warn("PR title is too short. Please use this format `[Jira Code] - Squad - Short Description`.")
        }

        if !prTitle.contains("[JIRA-") {
            warn("PR title does not contain a related Jira task. Please use the format `[Jira Code] - Short Description`.")
        }
    }

    private func checkModifiedFiles() {
        if changedFiles > ValidationRules.maxChangedFiles.hashValue {
            fail("PR contains too many changed files. Please split it in smaller PR")
        }
    }

    private func checkTests() {
        let testFiles = editedFiles.filter { ($0.contains("Tests") || $0.contains("Test")) && ($0.fileType == .swift  || $0.fileType == .m) }

        if testFiles.isEmpty {
            warn("PR does not contain any files related to Unit Tests")
        }
    }

    private func logResume() {
        let message =  """
            The PR added \(additions) and removed \(deletions) lines.  \(changedFiles) files changed.
        """

        warn(message)
    }
}

fileprivate enum ValidationRules: Int {
    case maxChangedFiles = 20
    case minPRTitle = 10 
    case bigPRThreshold = 3000
}