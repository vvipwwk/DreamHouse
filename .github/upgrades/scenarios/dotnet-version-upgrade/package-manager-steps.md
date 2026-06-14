# Package Manager Console Steps — NuGet Remediation

Run these commands inside Visual Studio's Package Manager Console (Tools → NuGet Package Manager → Package Manager Console). Set the Default project to the website project if listed.

1. Review current packages:
   Get-Package -ProjectName "PropertyForRentEdit" | Format-Table Id, Version

2. For each package to update, run (one at a time):
   Update-Package -Id Microsoft.Owin -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Host.SystemWeb -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Security -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Security.Cookies -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Security.Facebook -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Security.Google -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Security.MicrosoftAccount -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Security.OAuth -Version 4.2.3 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.Owin.Security.Twitter -Version 4.2.3 -ProjectName "PropertyForRentEdit"

3. Update CodeDom provider (if desired):
   Update-Package -Id Microsoft.CodeDom.Providers.DotNetCompilerPlatform -Version 4.1.0 -ProjectName "PropertyForRentEdit"

4. Identity packages (minor patch):
   Update-Package -Id Microsoft.AspNet.Identity.Core -Version 2.2.4 -ProjectName "PropertyForRentEdit"
   Update-Package -Id Microsoft.AspNet.Identity.Owin -Version 2.2.4 -ProjectName "PropertyForRentEdit"

5. After each Update-Package command:
   - Rebuild the solution from Visual Studio (Build → Rebuild Solution)
   - If build succeeds, commit the changed packages.config and packages/* content to git
   - If build fails, revert that package (use Update-Package -Id <id> -Version <previousVersion>) and report

6. Skip major jumps (e.g., bootstrap 3.x → 5.x). Leave EntityFramework at 6.4.4 (EF6) to avoid breaking changes.

7. Finalize: Run a full build and smoke test the site locally.

Notes:
- If the website project is not listed as a Package Manager Console project, select the project in the Default Project dropdown.
- Visual Studio will place packages into the expected local folders and update Bin refresh files; this is the recommended method for packages.config website projects.
