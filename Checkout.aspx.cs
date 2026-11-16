using System;
using System.Configuration;
using System.Data.SQLite;
using System.Text.RegularExpressions;
using System.Web.UI;
using Microsoft.AspNet.Identity;

public partial class Checkout : Page
{
    private readonly string Mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;
    private const decimal ServiceFeeRate = 0.05m;
    private const decimal TaxRate = 0.06m;

    protected string PropertyNo
    {
        get { return ViewState["PropertyNo"] as string; }
        set { ViewState["PropertyNo"] = value; }
    }

    protected decimal MonthlyRent
    {
        get { return ViewState["MonthlyRent"] == null ? 0m : (decimal)ViewState["MonthlyRent"]; }
        set { ViewState["MonthlyRent"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!User.IsInRole("Buyer"))
        {
            Response.Redirect("~/PropertyForRent.aspx");
            return;
        }

        EnsurePurchasesSchema();

        if (!IsPostBack)
        {
            string propertyNo = Request.QueryString["propertyNo"];
            if (string.IsNullOrWhiteSpace(propertyNo) || !LoadProperty(propertyNo.Trim()))
            {
                ShowMessage("Property could not be found.", false);
                btnConfirmCheckout.Enabled = false;
                return;
            }

            txtBuyerEmail.Text = User.Identity.Name;
        }
    }

    protected void btnConfirmCheckout_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        // 1. Full name validation: max 35 characters
        string buyerName = txtBuyerName.Text.Trim();
        if (string.IsNullOrEmpty(buyerName))
        {
            ShowMessage("Full Name is required.", false);
            return;
        }
        if (buyerName.Length > 35)
        {
            ShowMessage("Full Name cannot exceed 35 characters (currently " + buyerName.Length + ").", false);
            return;
        }

        // 2. Contact number validation: digits only, max 9 numeric characters
        string rawContact = txtContactNo.Text.Trim();
        if (string.IsNullOrEmpty(rawContact))
        {
            ShowMessage("Contact Number is required.", false);
            return;
        }
        if (!Regex.IsMatch(rawContact, @"^[0-9]{1,9}$"))
        {
            ShowMessage("Contact Number must contain digits only, with a maximum of 9 numeric characters (no symbols or alphabets).", false);
            return;
        }
        string fullContact = ddlCountryCode.SelectedValue + " " + rawContact;

        // 3. Billing Address validation: 35 to 50 characters per address line
        string line1 = txtAddressLine1.Text.Trim();
        if (string.IsNullOrEmpty(line1))
        {
            ShowMessage("Billing Address Line 1 is required.", false);
            return;
        }
        if (line1.Length < 35 || line1.Length > 50)
        {
            ShowMessage("Billing Address Line 1 must be between 35 and 50 characters (currently " + line1.Length + ").", false);
            return;
        }

        string line2 = txtAddressLine2.Text.Trim();
        if (!string.IsNullOrEmpty(line2) && (line2.Length < 35 || line2.Length > 50))
        {
            ShowMessage("Billing Address Line 2 must be between 35 and 50 characters (currently " + line2.Length + ").", false);
            return;
        }

        string fullBillingAddress = line1 + (!string.IsNullOrEmpty(line2) ? "\n" + line2 : "");

        decimal serviceFee = CalculateServiceFee(MonthlyRent);
        decimal taxAmount = CalculateTax(MonthlyRent, serviceFee);
        decimal totalAmount = MonthlyRent + serviceFee + taxAmount;

        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand(@"INSERT INTO Purchases
            (PropertyNo, UserId, PurchaseDate, BuyerName, BuyerEmail, ContactNo, BillingAddress, MonthlyRent, ServiceFee, TaxAmount, TotalAmount, PaymentMethod, Status)
            VALUES
            (@PropertyNo, @UserId, @PurchaseDate, @BuyerName, @BuyerEmail, @ContactNo, @BillingAddress, @MonthlyRent, @ServiceFee, @TaxAmount, @TotalAmount, @PaymentMethod, @Status)", con))
        {
            cmd.Parameters.AddWithValue("@PropertyNo", PropertyNo);
            cmd.Parameters.AddWithValue("@UserId", User.Identity.GetUserId());
            cmd.Parameters.AddWithValue("@PurchaseDate", DateTime.Now);
            cmd.Parameters.AddWithValue("@BuyerName", buyerName);
            cmd.Parameters.AddWithValue("@BuyerEmail", txtBuyerEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@ContactNo", fullContact);
            cmd.Parameters.AddWithValue("@BillingAddress", fullBillingAddress);
            cmd.Parameters.AddWithValue("@MonthlyRent", MonthlyRent);
            cmd.Parameters.AddWithValue("@ServiceFee", serviceFee);
            cmd.Parameters.AddWithValue("@TaxAmount", taxAmount);
            cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);
            cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue);
            cmd.Parameters.AddWithValue("@Status", "Active");

            con.Open();
            cmd.ExecuteNonQuery();

            // Automatically hide the property from buyers since it has been rented
            using (SQLiteCommand hideCmd = new SQLiteCommand("UPDATE PropertyForRent SET isHidden = 1 WHERE propertyNo = @PropertyNo", con))
            {
                hideCmd.Parameters.AddWithValue("@PropertyNo", PropertyNo);
                hideCmd.ExecuteNonQuery();
            }
        }

        ShowMessage("Booking completed! You have successfully rented property " + PropertyNo + ". You can view your booking and check out anytime in <a href='MyBookings.aspx' style='font-weight:bold; color:#155724; text-decoration:underline;'>My Bookings</a>.", true);
        btnConfirmCheckout.Enabled = false;
    }

    private bool LoadProperty(string propertyNo)
    {
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand("SELECT propertyNo, street, city, postcode, type, rent FROM PropertyForRent WHERE propertyNo=@propertyNo", con))
        {
            cmd.Parameters.AddWithValue("@propertyNo", propertyNo);
            con.Open();
            using (SQLiteDataReader reader = cmd.ExecuteReader())
            {
                if (!reader.Read())
                {
                    return false;
                }

                PropertyNo = reader["propertyNo"].ToString();
                MonthlyRent = Convert.ToDecimal(reader["rent"]);
                decimal serviceFee = CalculateServiceFee(MonthlyRent);
                decimal taxAmount = CalculateTax(MonthlyRent, serviceFee);
                decimal totalAmount = MonthlyRent + serviceFee + taxAmount;

                litPropertyTitle.Text = Server.HtmlEncode(reader["type"] + " " + PropertyNo);
                litPropertyAddress.Text = Server.HtmlEncode(reader["street"] + ", " + reader["city"] + " " + reader["postcode"]);
                litMonthlyRent.Text = FormatMoney(MonthlyRent);
                litServiceFee.Text = FormatMoney(serviceFee);
                litTaxAmount.Text = FormatMoney(taxAmount);
                litTotalAmount.Text = FormatMoney(totalAmount);
                return true;
            }
        }
    }

    private void EnsurePurchasesSchema()
    {
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            con.Open();
            using (SQLiteCommand cmd = con.CreateCommand())
            {
                cmd.CommandText = @"CREATE TABLE IF NOT EXISTS Purchases (
                    PurchaseId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                    PropertyNo VARCHAR(10) NOT NULL,
                    UserId NVARCHAR(128) NOT NULL,
                    PurchaseDate DATETIME NOT NULL
                )";
                cmd.ExecuteNonQuery();
            }

            EnsureColumn(con, "BuyerName", "NVARCHAR(256)");
            EnsureColumn(con, "BuyerEmail", "NVARCHAR(256)");
            EnsureColumn(con, "ContactNo", "NVARCHAR(50)");
            EnsureColumn(con, "BillingAddress", "TEXT");
            EnsureColumn(con, "MonthlyRent", "DECIMAL(10,2)");
            EnsureColumn(con, "ServiceFee", "DECIMAL(10,2)");
            EnsureColumn(con, "TaxAmount", "DECIMAL(10,2)");
            EnsureColumn(con, "TotalAmount", "DECIMAL(10,2)");
            EnsureColumn(con, "PaymentMethod", "NVARCHAR(50)");
            EnsureColumn(con, "Status", "NVARCHAR(50)");
        }
    }

    private void EnsureColumn(SQLiteConnection con, string columnName, string columnType)
    {
        using (SQLiteCommand check = new SQLiteCommand("PRAGMA table_info(Purchases)", con))
        using (SQLiteDataReader reader = check.ExecuteReader())
        {
            while (reader.Read())
            {
                if (string.Equals(reader["name"].ToString(), columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return;
                }
            }
        }

        using (SQLiteCommand alter = new SQLiteCommand("ALTER TABLE Purchases ADD COLUMN " + columnName + " " + columnType, con))
        {
            alter.ExecuteNonQuery();
        }
    }

    private decimal CalculateServiceFee(decimal rent)
    {
        return Math.Round(rent * ServiceFeeRate, 2);
    }

    private decimal CalculateTax(decimal rent, decimal serviceFee)
    {
        return Math.Round((rent + serviceFee) * TaxRate, 2);
    }

    private string FormatMoney(decimal value)
    {
        return "$" + value.ToString("0.00");
    }

    private void ShowMessage(string message, bool success)
    {
        lblMessage.Text = message;
        lblMessage.CssClass = success ? "text-success" : "text-danger";
    }
}
