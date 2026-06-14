using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using PropertyForRentEdit;

public partial class ResetPassword : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["code"] == null)
            {
                ErrorMessage.Text = "A code must be supplied for password reset.";
                resetForm.Visible = false;
            }
        }
    }

    protected void Reset_Click(object sender, EventArgs e)
    {
        if (IsValid)
        {
            string code = Request.QueryString["code"];
            if (code != null)
            {
                var manager = HttpContext.Current.GetOwinContext().GetUserManager<UserManager>();
                var user = manager.FindByEmail(Email.Text);
                if (user == null)
                {
                    ErrorMessage.Text = "No user found.";
                    return;
                }
                var result = manager.ResetPassword(user.Id, code, Password.Text);
                if (result.Succeeded)
                {
                    Response.Redirect("~/Account/Login");
                }
                else
                {
                    ErrorMessage.Text = result.Errors.FirstOrDefault();
                }
            }
        }
    }
}
