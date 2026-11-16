using System;
using System.Configuration;
using System.Data;
using System.Data.SQLite;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;
using PropertyForRentEdit;

public partial class MyBookings : Page
{
    private readonly string Mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!IsPostBack)
        {
            HelperUtilities.EnsureIsHiddenColumn(Mainconn);
            LoadUserBookings();
        }
    }

    private void LoadUserBookings()
    {
        string currentUserId = User.Identity.GetUserId() ?? string.Empty;
        string currentUserEmail = User.Identity.Name ?? string.Empty;

        using (var con = new SQLiteConnection(Mainconn))
        using (var cmd = new SQLiteCommand(@"
            SELECT 
                p.PurchaseId,
                p.PropertyNo,
                p.PurchaseDate,
                p.TotalAmount,
                p.PaymentMethod,
                COALESCE(p.Status, 'Active') AS Status,
                pr.street,
                pr.city,
                pr.postcode,
                pr.type,
                pr.rent
            FROM Purchases p
            INNER JOIN PropertyForRent pr ON pr.propertyNo = p.PropertyNo
            WHERE p.UserId = @UserId OR p.BuyerEmail = @BuyerEmail
            ORDER BY p.PurchaseDate DESC", con))
        {
            cmd.Parameters.AddWithValue("@UserId", currentUserId);
            cmd.Parameters.AddWithValue("@BuyerEmail", currentUserEmail);

            con.Open();
            using (var sda = new SQLiteDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                sda.Fill(dt);

                rptBookings.DataSource = dt;
                rptBookings.DataBind();

                pnlNoBookings.Visible = (dt.Rows.Count == 0);
            }
        }
    }

    protected void rptBookings_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Release")
        {
            string propertyNo = e.CommandArgument?.ToString();
            if (string.IsNullOrEmpty(propertyNo)) return;

            string currentUserId = User.Identity.GetUserId() ?? string.Empty;
            string currentUserEmail = User.Identity.Name ?? string.Empty;

            using (var con = new SQLiteConnection(Mainconn))
            {
                con.Open();

                // 1. Mark booking as Completed/Released
                using (var cmdPurchase = new SQLiteCommand(@"
                    UPDATE Purchases 
                    SET Status = 'Completed' 
                    WHERE PropertyNo = @PropertyNo 
                    AND (UserId = @UserId OR BuyerEmail = @BuyerEmail)
                    AND Status NOT IN ('Completed', 'Released')", con))
                {
                    cmdPurchase.Parameters.AddWithValue("@PropertyNo", propertyNo);
                    cmdPurchase.Parameters.AddWithValue("@UserId", currentUserId);
                    cmdPurchase.Parameters.AddWithValue("@BuyerEmail", currentUserEmail);
                    cmdPurchase.ExecuteNonQuery();
                }

                // 2. Release property back to public in PropertyForRent
                using (var cmdProp = new SQLiteCommand("UPDATE PropertyForRent SET isHidden = 0 WHERE propertyNo = @PropertyNo", con))
                {
                    cmdProp.Parameters.AddWithValue("@PropertyNo", propertyNo);
                    cmdProp.ExecuteNonQuery();
                }
            }

            lblStatusMessage.Text = "<div class='alert alert-success' style='border-radius:8px;'>You have successfully checked out of Property <strong>" + Server.HtmlEncode(propertyNo) + "</strong>. It is now released back to the public!</div>";
            LoadUserBookings();
        }
    }

    protected bool IsActive(object statusObj)
    {
        string status = statusObj?.ToString() ?? string.Empty;
        return !status.Equals("Completed", StringComparison.OrdinalIgnoreCase) 
            && !status.Equals("Released", StringComparison.OrdinalIgnoreCase);
    }

    protected string GetCityImage(object cityObj, object propertyNoObj)
    {
        return HelperUtilities.GetCityImage(cityObj, propertyNoObj);
    }
}
