# GitHub Actions CI/CD Setup

This directory contains GitHub Actions workflows and templates for the docx_viewer package.

## 📁 Contents

- **workflows/** - Automated CI/CD pipelines
  - `ci.yml` - Main CI pipeline (runs on PRs to main/dev)
  - `publish.yml` - Manual package publishing workflow
  - `quality-check.yml` - Weekly code quality audit
  - `auto-label.yml` - Automatic PR/issue labeling
  - `welcome.yml` - Welcome message for first-time contributors
  - `stale.yml` - Auto-close stale issues/PRs
  - `docs.yml` - Documentation coverage check
  - `changelog-check.yml` - Ensures CHANGELOG.md is updated

- **ISSUE_TEMPLATE/** - Issue and PR templates
  - `bug_report.yml` - Bug report template
  - `feature_request.yml` - Feature request template
  - `config.yml` - Issue template configuration

- **labeler.yml** - Auto-labeling configuration
- **dependabot.yml** - Automated dependency updates
- **PULL_REQUEST_TEMPLATE.md** - Pull request template

## 🚀 CI Workflows

### 1. CI Pipeline (`ci.yml`)
**Triggers:** Pull requests and pushes to `main` or `dev` branches

**Jobs:**
- ✅ **Analyze & Format Check** - Code formatting and static analysis
- 🧪 **Run Tests** - Unit tests with coverage reporting (comments on PR)
- 📦 **Package Analysis** - Validates package quality with `pana`
- 🏗️ **Build Example** - Builds on Web, iOS, and Windows
- 🔒 **Security Scan** - Checks for vulnerabilities
- 📝 **Lint Report** - Posts analysis results as PR comment

### 2. Publish Workflow (`publish.yml`)
**Triggers:** Manual trigger only

**Purpose:** Publishes package to pub.dev
- Validates version consistency
- Supports dry-run mode
- Creates Git tags and GitHub releases

### 3. Quality Check (`quality-check.yml`)
**Triggers:** Weekly (Mondays 9 AM UTC) or manual

**Purpose:** Weekly code quality audit
- Runs comprehensive analysis
- Generates test coverage reports
- Checks for code smells (TODO/FIXME)
- Creates issues if quality degrades

### 4. Auto Label (`auto-label.yml`)
**Triggers:** When PR is opened or updated

**Purpose:** Automatically labels PRs
- Labels based on files changed (lib, docs, ci, etc.)
- Adds size labels (XS, S, M, L, XL)
- Marks breaking changes automatically

### 5. Welcome (`welcome.yml`)
**Triggers:** First-time issue or PR from new contributors

**Purpose:** Welcome new contributors
- Friendly welcome message for first-time contributors
- Guidance for next steps
- Tips for successful contribution

### 6. Stale (`stale.yml`)
**Triggers:** Daily at midnight UTC

**Purpose:** Keep issues/PRs clean and manageable
- Marks inactive issues (60 days) and PRs (30 days) as stale
- Auto-closes after 14 days (issues) or 7 days (PRs)
- Exempts pinned, security, and work-in-progress items

### 7. Documentation Check (`docs.yml`)
**Triggers:** PRs that modify Dart files or README

**Purpose:** Ensure code is well documented
- Generates API documentation
- Checks for undocumented public APIs
- Posts documentation coverage report as PR comment
- Uploads generated docs as artifacts

### 8. Changelog Check (`changelog-check.yml`)
**Triggers:** PRs to main/dev branches

**Purpose:** Ensure CHANGELOG.md is updated
- Reminds contributors to update CHANGELOG
- Can skip with `no-changelog` label (for docs-only changes)
- Helps maintain clear project history

## 🔧 Setup Required

### Secrets Configuration

Add these in **Settings → Secrets and variables → Actions**:

1. **`PUB_DEV_CREDENTIALS`** (Required for publishing)
   ```bash
   # Get credentials
   dart pub token add https://pub.dev
   
   # Linux/macOS
   cat ~/.pub-cache/credentials.json
   
   # Windows
   type %APPDATA%\Pub\Cache\credentials.json
   ```
   Copy the entire JSON and add as secret.

### Branch Protection (Recommended)

**Settings → Branches → Add rule** for `main` and `dev`:
- ✅ Require pull request reviews
- ✅ Require status checks (select: Analyze & Format Check, Run Tests)
- ✅ Require branches to be up to date

## 📦 Publishing New Version

1. Update `pubspec.yaml` version and `CHANGELOG.md`
2. Commit and push to main
3. Go to **Actions → Publish to pub.dev → Run workflow**
4. Enter version number (must match pubspec.yaml)
5. Choose dry-run option for testing
6. Click "Run workflow"

## 🧪 Testing Locally

Before pushing, run these commands:

```bash
# Format check
dart format . --set-exit-if-changed

# Analysis
flutter analyze

# Tests
flutter test --coverage

# Dry-run publish
flutter pub publish --dry-run

# Generate documentation
dart doc
```

## 📊 PR Auto-Comments

The CI automatically posts comments on PRs with:
- 📊 **Test coverage report** - Overall percentage and per-file breakdown
- 🔍 **Static analysis results** - Lint warnings and errors
- 📚 **Documentation coverage** - Missing documentation warnings
- 📝 **CHANGELOG reminder** - If CHANGELOG.md not updated

## 🏷️ Automatic Labels

PRs are automatically labeled based on:
- **File changes**: `documentation`, `dependencies`, `ci`, `lib`, `example`, `tests`, `web`, `mobile`
- **PR size**: `size/XS`, `size/S`, `size/M`, `size/L`, `size/XL`
- **Breaking changes**: `breaking-change` (detected from title/description)
- **Changelog**: `changelog-updated` (when CHANGELOG.md is modified)
- **Activity**: `stale` (for inactive issues/PRs)

## 🤖 Dependabot

Automatically creates PRs for:
- Package dependencies (main & example)
- GitHub Actions versions
- Runs weekly on Mondays

## 💡 Tips for Contributors

### Skip CHANGELOG Check
For PRs that don't need changelog entries (docs, CI, typos):
```
Add label: no-changelog
```

### Keep PRs from Being Marked Stale
Add these labels:
- `pinned` - Never mark as stale
- `work-in-progress` - Active development
- `help wanted` - Waiting for contributors

### Documentation Best Practices
- Add doc comments to all public APIs
- Include code examples in documentation
- Use `///` for public API documentation
- Use `//` for implementation comments

## 📈 Monitoring

### Check Workflow Status
- **Actions Tab**: See all workflow runs
- **Pull Requests**: Status checks appear automatically
- **Issues**: Auto-created for quality failures

### Weekly Reports
- Quality check runs every Monday
- Results available in Actions tab
- Issues created automatically if checks fail

## 🛠️ Troubleshooting

### CI Fails: Format Check
```bash
dart format .
git add .
git commit -m "style: format code"
git push
```

### CI Fails: Analysis Errors
```bash
flutter analyze
# Fix issues and recommit
```

### CI Fails: Tests
```bash
flutter test
# Debug and fix failing tests
```

### Stale Bot Closed My PR
Simply add a comment or push new commits to reopen automatically.

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Package Publishing](https://dart.dev/tools/pub/publishing)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

---

**For questions, open an issue or discussion!** 💬
