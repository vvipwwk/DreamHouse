using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SQLite;
using System.Configuration;

public partial class EditPropertyForRent : System.Web.UI.Page
{
    string Mainconn = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

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

        // Ensure isHidden column exists — safe to run every time
        EnsureIsHiddenColumn();

        if (!Page.IsPostBack)
        {
            var propertyID = Request.QueryString["propertyNo"];
            if (string.IsNullOrEmpty(propertyID))
            {
                Response.Redirect("PropertyForRent.aspx");
                return;
            }

            using (SQLiteConnection con = new SQLiteConnection(Mainconn))
            {
                string sqlquery = "SELECT propertyNo, street, city, postcode, type, rooms, rent, ownerNo, staffNo, branchNo, isHidden FROM PropertyForRent WHERE propertyNo=@propertyNo";
                using (SQLiteCommand sqlcomm = new SQLiteCommand(sqlquery, con))
                {
                    sqlcomm.Parameters.AddWithValue("@propertyNo", propertyID);
                    con.Open();

                    using (SQLiteDataReader reader = sqlcomm.ExecuteReader())
                    {
                        if (reader.HasRows && reader.Read())
                        {
                            propertyNo.Text  = reader["propertyNo"].ToString();
                            txtStreet.Text   = reader["street"].ToString();
                            txtCity.Text     = reader["city"].ToString();
                            txtPostCode.Text = reader["postcode"].ToString();
                            txtType.Text     = reader["type"].ToString();
                            txtRooms.Text    = reader["rooms"].ToString();
                            txtRent.Text     = reader["rent"].ToString();

                            ownerDropdown(reader["ownerNo"].ToString());
                            staffDropdown(reader["staffNo"].ToString());
                            branchDropdown(reader["branchNo"].ToString());

                            bool isHidden = reader["isHidden"] != DBNull.Value && Convert.ToInt32(reader["isHidden"]) == 1;
                            SetHideButton(isHidden);

                            ShowCurrentImage(propertyNo.Text);
                        }
                    }
                }
            }
        }
    }

    /// <summary>
    /// Adds isHidden column if it doesn't already exist. Safe to call repeatedly.
    /// </summary>
    private void EnsureIsHiddenColumn()
    {
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            con.Open();
            // Check if column exists
            bool exists = false;
            using (SQLiteCommand cmd = new SQLiteCommand("PRAGMA table_info(PropertyForRent)", con))
            using (SQLiteDataReader r = cmd.ExecuteReader())
            {
                while (r.Read())
                {
                    if (r["name"].ToString().Equals("isHidden", StringComparison.OrdinalIgnoreCase))
                    {
                        exists = true;
                        break;
                    }
                }
            }

            if (!exists)
            {
                using (SQLiteCommand cmd = new SQLiteCommand(
                    "ALTER TABLE PropertyForRent ADD COLUMN isHidden INTEGER DEFAULT 0", con))
                {
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }

    private void SetHideButton(bool isHidden)
    {
        btnToggleHide.Text = isHidden ? "Show to Buyers" : "Hide from Buyers";
        btnToggleHide.Style["background-color"] = isHidden ? "#27ae60" : "#f39c12";
    }

    protected void ShowCurrentImage(string propNo)
    {
        string[] extensions = { "jpg", "jpeg", "png", "gif", "webp" };
        string folder = Server.MapPath("~/Images/Properties/");
        string found = null;

        foreach (var ext in extensions)
        {
            string candidate = Path.Combine(folder, propNo + "." + ext);
            if (File.Exists(candidate))
            {
                found = ResolveUrl("~/Images/Properties/" + propNo + "." + ext);
                break;
            }
        }

        if (found != null)
        {
            imgCurrentProperty.ImageUrl = found;
            imgCurrentProperty.Style["display"] = "block";
            lblNoImage.Visible = false;
        }
        else
        {
            imgCurrentProperty.Style["display"] = "none";
            lblNoImage.Visible = true;
        }
    }

    protected void ownerDropdown(string ownerNum)
    {
        using (SQLiteConnection sqlconn = new SQLiteConnection(Mainconn))
        {
            sqlconn.Open();
            using (SQLiteCommand sqlcomm = new SQLiteCommand("SELECT ownerNo FROM PrivateOwner", sqlconn))
            {
                DDLOwnerNo.DataSource = sqlcomm.ExecuteReader();
                DDLOwnerNo.DataTextField = "ownerNo";
                DDLOwnerNo.DataValueField = "ownerNo";
                DDLOwnerNo.DataBind();
                if (DDLOwnerNo.Items.FindByValue(ownerNum) != null)
                    DDLOwnerNo.SelectedValue = ownerNum;
            }
        }
    }

    protected void staffDropdown(string staffNum)
    {
        using (SQLiteConnection sqlconn = new SQLiteConnection(Mainconn))
        {
            sqlconn.Open();
            using (SQLiteCommand sqlcomm = new SQLiteCommand("SELECT staffNo FROM Staff", sqlconn))
            {
                DDLStaffNo.DataSource = sqlcomm.ExecuteReader();
                DDLStaffNo.DataTextField = "staffNo";
                DDLStaffNo.DataValueField = "staffNo";
                DDLStaffNo.DataBind();
                if (DDLStaffNo.Items.FindByValue(staffNum) != null)
                    DDLStaffNo.SelectedValue = staffNum;
            }
        }
    }

    protected void branchDropdown(string branchNum)
    {
        using (SQLiteConnection sqlconn = new SQLiteConnection(Mainconn))
        {
            sqlconn.Open();
            using (SQLiteCommand sqlcomm = new SQLiteCommand("SELECT branchNo FROM Branch", sqlconn))
            {
                DDLBranchNo.DataSource = sqlcomm.ExecuteReader();
                DDLBranchNo.DataTextField = "branchNo";
                DDLBranchNo.DataValueField = "branchNo";
                DDLBranchNo.DataBind();
                if (DDLBranchNo.Items.FindByValue(branchNum) != null)
                    DDLBranchNo.SelectedValue = branchNum;
            }
        }
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("PropertyForRent.aspx");
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        var propertyID = Request.QueryString["propertyNo"];

        if (fileUploadInput.HasFile)
        {
            string ext = Path.GetExtension(fileUploadInput.FileName).ToLower();
            string[] allowed = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

            if (!allowed.Contains(ext))
            {
                lblUploadMessage.Text = "Invalid file type. Please upload JPG, PNG, GIF or WEBP.";
                lblUploadMessage.ForeColor = System.Drawing.Color.Red;
                ShowCurrentImage(propertyID);
                return;
            }

            if (fileUploadInput.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                lblUploadMessage.Text = "File too large. Maximum size is 5 MB.";
                lblUploadMessage.ForeColor = System.Drawing.Color.Red;
                ShowCurrentImage(propertyID);
                return;
            }

            string folder = Server.MapPath("~/Images/Properties/");
            foreach (var oldExt in new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" })
            {
                string oldPath = Path.Combine(folder, propertyID + oldExt);
                if (File.Exists(oldPath)) File.Delete(oldPath);
            }
            fileUploadInput.SaveAs(Path.Combine(folder, propertyID + ext));
        }

        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            con.Open();
            string sqlquery = "UPDATE PropertyForRent SET street=@street, city=@city, postcode=@postcode, type=@type, rooms=@rooms, rent=@rent, ownerNo=@ownerNo, staffNo=@staffNo, branchNo=@branchNo WHERE propertyNo=@propertyNo";
            using (SQLiteCommand cmd = new SQLiteCommand(sqlquery, con))
            {
                cmd.Parameters.AddWithValue("@street",     txtStreet.Text);
                cmd.Parameters.AddWithValue("@city",       txtCity.Text);
                cmd.Parameters.AddWithValue("@postcode",   txtPostCode.Text);
                cmd.Parameters.AddWithValue("@type",       txtType.Text);
                cmd.Parameters.AddWithValue("@rooms",      txtRooms.Text);
                cmd.Parameters.AddWithValue("@rent",       txtRent.Text);
                cmd.Parameters.AddWithValue("@ownerNo",    DDLOwnerNo.Text);
                cmd.Parameters.AddWithValue("@staffNo",    DDLStaffNo.Text);
                cmd.Parameters.AddWithValue("@branchNo",   DDLBranchNo.Text);
                cmd.Parameters.AddWithValue("@propertyNo", propertyID);
                cmd.ExecuteNonQuery();
            }
        }

        Response.Redirect("PropertyForRent.aspx");
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        var propertyID = Request.QueryString["propertyNo"];
        if (string.IsNullOrEmpty(propertyID)) return;

        string folder = Server.MapPath("~/Images/Properties/");
        foreach (var ext in new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" })
        {
            string imgPath = Path.Combine(folder, propertyID + ext);
            if (File.Exists(imgPath)) File.Delete(imgPath);
        }

        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            con.Open();
            using (SQLiteCommand cmd = new SQLiteCommand("DELETE FROM PropertyForRent WHERE propertyNo=@propertyNo", con))
            {
                cmd.Parameters.AddWithValue("@propertyNo", propertyID);
                cmd.ExecuteNonQuery();
            }
        }

        Response.Redirect("PropertyForRent.aspx");
    }

    protected void btnToggleHide_Click(object sender, EventArgs e)
    {
        var propertyID = Request.QueryString["propertyNo"];
        if (string.IsNullOrEmpty(propertyID)) return;

        EnsureIsHiddenColumn();

        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            con.Open();

            int currentHidden = 0;
            using (SQLiteCommand cmd = new SQLiteCommand(
                "SELECT isHidden FROM PropertyForRent WHERE propertyNo=@propertyNo", con))
            {
                cmd.Parameters.AddWithValue("@propertyNo", propertyID);
                var result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    currentHidden = Convert.ToInt32(result);
            }

            int newHidden = currentHidden == 1 ? 0 : 1;
            using (SQLiteCommand cmd = new SQLiteCommand(
                "UPDATE PropertyForRent SET isHidden=@isHidden WHERE propertyNo=@propertyNo", con))
            {
                cmd.Parameters.AddWithValue("@isHidden",   newHidden);
                cmd.Parameters.AddWithValue("@propertyNo", propertyID);
                cmd.ExecuteNonQuery();
            }
        }

        Response.Redirect(Request.Url.PathAndQuery);
    }
}
