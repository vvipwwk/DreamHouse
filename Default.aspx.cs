using System;
using System.Web.UI;
using PropertyForRentEdit;

public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (pnlSearch != null)
        {
            pnlSearch.Visible = !(User.Identity.IsAuthenticated && User.IsInRole("Seller"));
        }
    }
}
