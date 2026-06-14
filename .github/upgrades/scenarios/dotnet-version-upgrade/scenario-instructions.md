# NuGet Vulnerability Remediation

## Preferences
- **Flow Mode**: Automatic
- **Scope**: Repository-wide (packages.config-based ASP.NET WebForms project)
- **Fix Strategy**: Update vulnerable NuGet packages to nearest non-vulnerable version. If no safe upgrade, report for manual review.

## Source Control
- **Source Branch**: main
- **Working Branch**: main (use current branch)
- **Commit Strategy**: After Each Task
- **Branch Sync**: Auto (Merge)

## User Preferences
- **Package update method**: Use Visual Studio Package Manager Console for package updates and restore (user requested). Update steps saved as `package-manager-steps.md` in the scenario folder.
