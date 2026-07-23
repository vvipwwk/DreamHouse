<<<<<<< HEAD
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
            pnlSearchBar.Visible = User.Identity.IsAuthenticated && User.IsInRole("Buyer");
            BindFilterDropdowns();

            string keyword = Request.QueryString["q"];
            string priceRange = Request.QueryString["price"];
            string rooms = Request.QueryString["rooms"];
            string propertyType = Request.QueryString["type"];

            txtFilterInput.Text = keyword;
            SelectListValue(ddlPriceRange, priceRange);
            SelectListValue(ddlRooms, rooms);
            SelectListValue(ddlPropertyType, propertyType);

            LoadProperties(keyword, priceRange, rooms, propertyType);
        }
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        Response.Redirect(BuildFilterUrl(txtFilterInput.Text.Trim(), ddlPriceRange.SelectedValue, ddlRooms.SelectedValue, ddlPropertyType.SelectedValue));
    }

    private void LoadProperties(string keyword, string priceRange, string rooms, string propertyType)
    {
        string mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
        using (var con = new SQLiteConnection(mainconn))
        {
            string sqlquery = @"SELECT * FROM PropertyForRent
                WHERE (@q = '' OR city LIKE @likeQ OR street LIKE @likeQ OR postcode LIKE @likeQ OR type LIKE @likeQ OR propertyNo LIKE @likeQ)
                AND (@rooms = '' OR rooms = @rooms)
                AND (@type = '' OR type = @type)";

            decimal minPrice;
            decimal maxPrice;
            bool hasMinPrice;
            bool hasMaxPrice;
            ParsePriceRange(priceRange, out minPrice, out maxPrice, out hasMinPrice, out hasMaxPrice);

            if (hasMinPrice)
            {
                sqlquery += " AND rent >= @minPrice";
            }

            if (hasMaxPrice)
            {
                sqlquery += " AND rent <= @maxPrice";
            }

            sqlquery += " ORDER BY type";

            using (var sqlconn = new SQLiteCommand(sqlquery, con))
            {
                string trimmedKeyword = (keyword ?? string.Empty).Trim();
                sqlconn.Parameters.AddWithValue("@q", trimmedKeyword);
                sqlconn.Parameters.AddWithValue("@likeQ", "%" + trimmedKeyword + "%");
                sqlconn.Parameters.AddWithValue("@rooms", rooms ?? string.Empty);
                sqlconn.Parameters.AddWithValue("@type", propertyType ?? string.Empty);
                if (hasMinPrice) sqlconn.Parameters.AddWithValue("@minPrice", minPrice);
                if (hasMaxPrice) sqlconn.Parameters.AddWithValue("@maxPrice", maxPrice);

                con.Open();
                using (var sda = new SQLiteDataAdapter(sqlconn))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    PropertyRepeater.DataSource = dt;
                    PropertyRepeater.DataBind();

                    lblFilterCount.Text = dt.Rows.Count.ToString() + " result(s) found";
                    lblFilterCount.Visible = HasFilters(keyword, priceRange, rooms, propertyType);
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

    protected void PropertyRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Buy")
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            Response.Redirect("~/Checkout.aspx?propertyNo=" + HttpUtility.UrlEncode(e.CommandArgument.ToString()));
        }
    }

    private void BindFilterDropdowns()
    {
        BindDistinctDropdown("SELECT DISTINCT rooms FROM PropertyForRent ORDER BY CAST(rooms AS INTEGER)", ddlRooms, "Any rooms", " rooms");
        BindDistinctDropdown("SELECT DISTINCT type FROM PropertyForRent ORDER BY type", ddlPropertyType, "Any property", string.Empty);
    }

    private void BindDistinctDropdown(string query, DropDownList dropdown, string firstText, string suffix)
    {
        dropdown.Items.Clear();
        dropdown.Items.Add(new ListItem(firstText, string.Empty));

        string mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
        using (SQLiteConnection con = new SQLiteConnection(mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand(query, con))
        {
            con.Open();
            using (SQLiteDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    string value = reader[0].ToString();
                    dropdown.Items.Add(new ListItem(value + suffix, value));
                }
            }
        }
    }

    private string BuildFilterUrl(string keyword, string priceRange, string rooms, string propertyType)
    {
        List<string> parts = new List<string>();
        AddQueryPart(parts, "q", keyword);
        AddQueryPart(parts, "price", priceRange);
        AddQueryPart(parts, "rooms", rooms);
        AddQueryPart(parts, "type", propertyType);
        return "PropertyForRent.aspx" + (parts.Count == 0 ? string.Empty : "?" + string.Join("&", parts.ToArray()));
    }

    private void AddQueryPart(List<string> parts, string key, string value)
    {
        if (!string.IsNullOrWhiteSpace(value))
        {
            parts.Add(key + "=" + HttpUtility.UrlEncode(value));
        }
    }

    private void SelectListValue(DropDownList dropdown, string value)
    {
        if (!string.IsNullOrEmpty(value) && dropdown.Items.FindByValue(value) != null)
        {
            dropdown.SelectedValue = value;
        }
    }

    private bool HasFilters(string keyword, string priceRange, string rooms, string propertyType)
    {
        return !string.IsNullOrWhiteSpace(keyword)
            || !string.IsNullOrWhiteSpace(priceRange)
            || !string.IsNullOrWhiteSpace(rooms)
            || !string.IsNullOrWhiteSpace(propertyType);
    }

    private void ParsePriceRange(string priceRange, out decimal minPrice, out decimal maxPrice, out bool hasMinPrice, out bool hasMaxPrice)
    {
        minPrice = 0m;
        maxPrice = 0m;
        hasMinPrice = false;
        hasMaxPrice = false;

        if (string.IsNullOrWhiteSpace(priceRange))
        {
            return;
        }

        string[] values = priceRange.Split('-');
        if (values.Length > 0 && decimal.TryParse(values[0], out minPrice))
        {
            hasMinPrice = true;
        }

        if (values.Length > 1 && decimal.TryParse(values[1], out maxPrice))
        {
            hasMaxPrice = true;
        }
    }
}
=======
﻿using System;
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
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
