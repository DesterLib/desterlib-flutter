module.exports = {
  types: [
    { value: "feat", name: "feat:     ✨ A new feature" },
    { value: "fix", name: "fix:      🐛 A bug fix" },
    { value: "docs", name: "docs:     📝 Documentation changes" },
    {
      value: "style",
      name: "style:    💄 Code style changes (formatting, etc)",
    },
    {
      value: "refactor",
      name: "refactor: ♻️  Code refactoring (no functional changes)",
    },
    { value: "perf", name: "perf:     ⚡ Performance improvements" },
    { value: "test", name: "test:     ✅ Adding or updating tests" },
    {
      value: "build",
      name: "build:    📦 Build system or dependencies changes",
    },
    { value: "ci", name: "ci:       👷 CI/CD changes" },
    {
      value: "chore",
      name: "chore:    🔧 Other changes (no production code change)",
    },
    { value: "revert", name: "revert:   ⏪ Revert a previous commit" },
  ],

  scopes: [
    { name: "app" },
    { name: "ui" },
    { name: "player" },
    { name: "movies" },
    { name: "tvshows" },
    { name: "library" },
    { name: "settings" },
    { name: "api" },
    { name: "navigation" },
    { name: "theme" },
    { name: "widgets" },
    { name: "auth" },
    { name: "config" },
    { name: "deps" },
    { name: "android" },
    { name: "ios" },
    { name: "macos" },
    { name: "linux" },
    { name: "windows" },
    { name: "web" },
    { name: "ci" },
    { name: "docs" },
    { name: "release" },
  ],

  allowCustomScopes: true,
  allowBreakingChanges: ["feat", "fix", "refactor", "perf"],
  skipQuestions: [],

  messages: {
    type: "Select the type of change that you're committing:",
    scope: "\nDenote the SCOPE of this change (optional):",
    customScope: "Denote the SCOPE of this change:",
    subject: "Write a SHORT, IMPERATIVE description of the change:\n",
    body: 'Provide a LONGER description of the change (optional). Use "|" to break new line:\n',
    breaking: "List any BREAKING CHANGES (optional):\n",
    footer:
      "List any ISSUES CLOSED by this change (optional). E.g.: #31, #34:\n",
    confirmCommit: "Are you sure you want to proceed with the commit above?",
  },

  skipEmptyScopes: true,
  subjectLimit: 100,
  breaklineChar: "|",
  footerPrefix: "ISSUES CLOSED:",
  askForBreakingChangeFirst: true,
};

