using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SQLite;
using System.Web.UI;
using System.Configuration;
using PropertyForRentEdit;
using System.Web.UI.WebControls;

public partial class SearchResults : Page
{
    public string SearchKeyword { get; private set; } = "";
    public int ResultCount { get; private set; } = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var keyword = Request.QueryString["q"];
            if (string.IsNullOrEmpty(keyword))
            {
                SearchKeyword = "all properties";
                ResultCount = LoadProperties(null);
                return;
            }

            SearchKeyword = keyword;
            ResultCount = LoadProperties(keyword);
        }
    }

    private int LoadProperties(string keyword)
    {
        string mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
        HelperUtilities.EnsureIsHiddenColumn(mainconn);
        bool isSeller = User.Identity.IsAuthenticated && User.IsInRole("Seller");
        string buyerFilter = !isSeller ? " AND (isHidden IS NULL OR isHidden = 0) AND propertyNo NOT IN (SELECT PropertyNo FROM Purchases WHERE Status NOT IN ('Completed', 'Released'))" : "";

        using (var con = new SQLiteConnection(mainconn))
        {
            string sqlquery;
            if (!string.IsNullOrEmpty(keyword))
            {
                sqlquery = "SELECT * FROM PropertyForRent WHERE (city LIKE @q OR street LIKE @q2 OR postcode LIKE @q3 OR type LIKE @q4)" + buyerFilter + " ORDER BY type";
            }
            else
            {
                sqlquery = "SELECT * FROM PropertyForRent WHERE 1=1" + buyerFilter + " ORDER BY type";
            }

            using (var sqlconn = new SQLiteCommand(sqlquery, con))
            {
                if (!string.IsNullOrEmpty(keyword))
                {
                    string pct = keyword.Trim();
                    sqlconn.Parameters.AddWithValue("@q", "%" + pct + "%");
                    sqlconn.Parameters.AddWithValue("@q2", "%" + pct + "%");
                    sqlconn.Parameters.AddWithValue("@q3", "%" + pct + "%");
                    sqlconn.Parameters.AddWithValue("@q4", "%" + pct + "%");
                }

                con.Open();
                using (var sda = new SQLiteDataAdapter(sqlconn))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    ResultRepeater.DataSource = dt;
                    ResultRepeater.DataBind();
                    pnlNoResults.Visible = (dt.Rows.Count == 0);
                    return dt.Rows.Count;
                }
            }
        }
    }

    protected string GetCityImage(object cityObj, object propertyNoObj)
    {
        return HelperUtilities.GetCityImage(cityObj, propertyNoObj);
    }

    protected bool IsSeller()
    {
        return User.Identity.IsAuthenticated && User.IsInRole("Seller");
    }

    protected void ResultRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Buy")
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            string propertyNo = e.CommandArgument.ToString();

            Response.Redirect("~/Checkout.aspx?propertyNo=" + Server.UrlEncode(propertyNo));
        }
    }
}
