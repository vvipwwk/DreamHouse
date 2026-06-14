using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SQLite;
using System.Configuration;
using PropertyForRentEdit;

public partial class PropertyForRent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Show the filter bar only for logged-in buyers
            pnlSearchBar.Visible = User.Identity.IsAuthenticated && User.IsInRole("Buyer");

            string keyword = Request.QueryString["q"];
            LoadProperties(keyword);
        }
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        string keyword = txtFilterInput.Text.Trim();
        if (!string.IsNullOrEmpty(keyword))
        {
            // Redirect to the same page with the query string so the filter persists on refresh
            Response.Redirect("PropertyForRent.aspx?q=" + HttpUtility.UrlEncode(keyword));
        }
        else
        {
            LoadProperties(null);
        }
    }

    private void LoadProperties(string keyword)
    {
        string mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
        using (var con = new SQLiteConnection(mainconn))
        {
            string sqlquery;
            int filterCount = 0;

            if (!string.IsNullOrEmpty(keyword))
            {
                sqlquery = "SELECT * FROM PropertyForRent WHERE city LIKE @q OR street LIKE @q2 OR postcode LIKE @q3 OR type LIKE @q4 ORDER BY type";
                using (var sqlconn = new SQLiteCommand(sqlquery, con))
                {
                    string pct = keyword.Trim();
                    sqlconn.Parameters.AddWithValue("@q", "%" + pct + "%");
                    sqlconn.Parameters.AddWithValue("@q2", "%" + pct + "%");
                    sqlconn.Parameters.AddWithValue("@q3", "%" + pct + "%");
                    sqlconn.Parameters.AddWithValue("@q4", "%" + pct + "%");

                    con.Open();
                    using (var sda = new SQLiteDataAdapter(sqlconn))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        filterCount = dt.Rows.Count;

                        PropertyRepeater.DataSource = dt;
                        PropertyRepeater.DataBind();
                    }
                }
            }
            else
            {
                sqlquery = "SELECT * FROM PropertyForRent ORDER BY type";
                using (var sqlconn = new SQLiteCommand(sqlquery, con))
                {
                    con.Open();
                    using (var sda = new SQLiteDataAdapter(sqlconn))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        PropertyRepeater.DataSource = dt;
                        PropertyRepeater.DataBind();
                    }
                }
            }

            // Update the filter count label if we have one
            if (!string.IsNullOrEmpty(keyword) && lblFilterCount != null)
            {
                lblFilterCount.Text = " " + filterCount.ToString() + " result(s) found";
                lblFilterCount.Visible = true;
            }
        }
    }

    protected string GetCityImage(object cityObj, object propertyNoObj)
    {
        return HelperUtilities.GetCityImage(cityObj, propertyNoObj);
    }

    /// <summary>Returns true when the current user is authenticated and in the Seller role.</summary>
    protected bool IsSeller()
    {
        return User.Identity.IsAuthenticated && User.IsInRole("Seller");
    }

    protected void PropertyRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Buy")
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string propertyNo = e.CommandArgument.ToString();
            string userId = Microsoft.AspNet.Identity.IdentityExtensions.GetUserId(User.Identity);

            string mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
            using (var con = new SQLiteConnection(mainconn))
            {
                string sqlquery = "INSERT INTO Purchases (PropertyNo, UserId, PurchaseDate) VALUES (@PropertyNo, @UserId, @PurchaseDate)";
                using (var sqlconn = new SQLiteCommand(sqlquery, con))
                {
                    sqlconn.Parameters.AddWithValue("@PropertyNo", propertyNo);
                    sqlconn.Parameters.AddWithValue("@UserId", userId);
                    sqlconn.Parameters.AddWithValue("@PurchaseDate", DateTime.Now);

                    con.Open();
                    int rows = sqlconn.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        PurchaseMessage.Text = "Successfully purchased property " + propertyNo + "! We will contact you soon.";
                        PurchaseMessage.CssClass = "text-success";
                    }
                    else
                    {
                        PurchaseMessage.Text = "An error occurred during purchase.";
                        PurchaseMessage.CssClass = "text-danger";
                    }
                }
            }
        }
    }
}
