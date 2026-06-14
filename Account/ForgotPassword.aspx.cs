using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using PropertyForRentEdit;

public partial class ForgotPassword : Page
{
    protected void Forgot(object sender, EventArgs e)
    {
        if (IsValid)
        {
            var manager = HttpContext.Current.GetOwinContext().GetUserManager<UserManager>();
            ApplicationUser user = manager.FindByEmail(Email.Text);
            if (user != null)
            {
                string code = manager.GeneratePasswordResetToken(user.Id);
                string callbackUrl = IdentityHelper.GetResetPasswordRedirectUrl(code, Request);
                manager.SendEmail(user.Id, "Reset Password", "Please reset your password by clicking <a href=\"" + callbackUrl + "\">here</a>");
                loginForm.Visible = false;
                DisplayEmail.Visible = true;
            }
        }
    }
}
