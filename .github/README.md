# GitHub Actions CI/CD Setup

This directory contains GitHub Actions workflows and templates for the docx_viewer package.

## 📁 Contents

- **workflows/** - Automated CI/CD pipelines
  - `ci.yml` - Main CI pipeline (runs on PRs to main/dev)
  - `publish.yml` - Manual package publishing workflow
  - `quality-check.yml` - Weekly code quality audit

- **ISSUE_TEMPLATE/** - Issue and PR templates
  - `bug_report.yml` - Bug report template
  - `feature_request.yml` - Feature request template
  - `config.yml` - Issue template configuration

- **dependabot.yml** - Automated dependency updates
- **CODEOWNERS** - Code ownership and review assignments
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
- Creates issues if quality degrades

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
```

## 📊 PR Comments

The CI automatically posts comments on PRs with:
- 📊 Test coverage report with percentage and per-file breakdown
- 🔍 Static analysis results

## 🤖 Dependabot

Automatically creates PRs for:
- Package dependencies (main & example)
- GitHub Actions versions
- Runs weekly on Mondays

## 💡 Tips

- Always test with dry-run before actual publishing
- Review Dependabot PRs before merging
- CI comments update automatically (no duplicates)
- Coverage artifacts available for 30 days

---

For questions, open an issue or discussion!
