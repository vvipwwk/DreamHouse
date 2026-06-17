using System;
using System.Configuration;
using System.Data;
using System.Data.SQLite;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PurchaseRecords : Page
{
    private readonly string Mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!User.IsInRole("Seller"))
        {
            Response.Redirect("~/PropertyForRent.aspx");
            return;
        }

        if (!IsPostBack)
        {
            EnsurePurchasesSchema();
            BindPropertyFilter();
            string propertyNo = Request.QueryString["propertyNo"];
            if (!string.IsNullOrWhiteSpace(propertyNo) && ddlPropertyFilter.Items.FindByValue(propertyNo) != null)
            {
                ddlPropertyFilter.SelectedValue = propertyNo;
            }
            BindPurchaseRecords();
        }
    }

    protected void ddlPropertyFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPurchaseRecords();
    }

    private void BindPropertyFilter()
    {
        ddlPropertyFilter.Items.Clear();
        ddlPropertyFilter.Items.Add(new ListItem("All properties", string.Empty));

        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand("SELECT propertyNo, type, city FROM PropertyForRent ORDER BY propertyNo", con))
        {
            con.Open();
            using (SQLiteDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    string propertyNo = reader["propertyNo"].ToString();
                    ddlPropertyFilter.Items.Add(new ListItem(propertyNo + " - " + reader["type"] + " in " + reader["city"], propertyNo));
                }
            }
        }
    }

    private void BindPurchaseRecords()
    {
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand(@"SELECT
                p.PropertyNo,
                pr.type AS PropertyType,
                COALESCE(NULLIF(p.BuyerName, ''), u.UserName) AS BuyerName,
                COALESCE(NULLIF(p.BuyerEmail, ''), u.Email, u.UserName) AS BuyerEmail,
                p.ContactNo,
                p.PurchaseDate,
                p.TotalAmount,
                p.PaymentMethod,
                COALESCE(p.Status, 'Checked Out') AS Status
            FROM Purchases p
            INNER JOIN PropertyForRent pr ON pr.propertyNo = p.PropertyNo
            LEFT JOIN AspNetUsers u ON u.Id = p.UserId
            WHERE (@PropertyNo = '' OR p.PropertyNo = @PropertyNo)
            ORDER BY p.PurchaseDate DESC", con))
        {
            cmd.Parameters.AddWithValue("@PropertyNo", ddlPropertyFilter.SelectedValue);
            con.Open();
            using (SQLiteDataAdapter adapter = new SQLiteDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvPurchaseRecords.DataSource = dt;
                gvPurchaseRecords.DataBind();
                lblRecordCount.Text = dt.Rows.Count + " record(s) found";
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
}
