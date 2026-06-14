using System;
using System.Web.UI;
using PropertyForRentEdit;

public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Only show the search feature to logged-in buyers
        if (pnlSearch != null)
        {
            pnlSearch.Visible = User.Identity.IsAuthenticated && User.IsInRole("Buyer");
        }
    }
}
