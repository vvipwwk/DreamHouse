using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Linq;
using System.Web.UI;
using PropertyForRentEdit;

public partial class Account_Register : Page
{
    protected void CreateUser_Click(object sender, EventArgs e)
    {
        var manager = new UserManager();
        var user = new ApplicationUser() { UserName = Email.Text, Email = Email.Text };
        IdentityResult result = manager.Create(user, Password.Text);
        if (result.Succeeded)
        {
            // Determine which role was selected
            string selectedRole = rdSeller.Checked ? "Seller" : "Buyer";

            // Assign role using RoleManager
            using (var roleManager = ApplicationRoleManager.Create())
            {
                if (!roleManager.RoleExists(selectedRole))
                    roleManager.Create(new IdentityRole(selectedRole));
            }
            manager.AddToRole(user.Id, selectedRole);

            IdentityHelper.SignIn(manager, user, isPersistent: false);
            IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
        }
        else
        {
            ErrorMessage.Text = result.Errors.FirstOrDefault();
        }
    }
}