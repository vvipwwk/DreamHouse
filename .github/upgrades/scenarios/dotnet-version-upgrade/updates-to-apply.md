# Planned Package Updates

Will prefer stable versions. Pre-release versions detected and will be ignored.

Planned updates (only packages with newer stable versions):

- AspNet.ScriptManager.bootstrap: 3.4.1 -> 5.2.3 (stable)
- AspNet.ScriptManager.jQuery: 3.4.1 -> 3.7.1
- bootstrap: 3.4.1 -> 5.3.8  (note: major version bump; risk to UI)
- jQuery: 3.6.4 -> 3.7.1
- Microsoft.AspNet.Identity.Core: 2.2.3 -> 2.2.4
- Microsoft.AspNet.Identity.Owin: 2.2.3 -> 2.2.4
- Microsoft.CodeDom.Providers.DotNetCompilerPlatform: 2.0.1 -> 4.1.0
- Microsoft.Owin.*: 4.0.1 -> 4.2.3 (all Microsoft.Owin packages)
- Microsoft.Web.Infrastructure: 1.0.0.0 -> 2.0.1
- Newtonsoft.Json: 13.0.3 -> 13.0.3 (latest stable is 13.0.3; 13.0.5-beta1 is pre-release so skip)

Notes:
- EntityFramework latest appears pre-release; keep 6.4.4 (EF6 stable) to avoid breaking changes.
- WebGrease, Modernizr, Owin: no stable updates or safe updates; keep current versions.
- bootstrap major upgrade (3.x -> 5.x) is risky and not recommended automatically; skip.

Update plan: apply safe minor/patch updates first (Owin 4.0.1 -> 4.2.3, Identity 2.2.3 -> 2.2.4, CodeDom provider), then build and validate.
