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
<<<<<<< HEAD
    {
=======
    {      
        // Guard: must be logged in
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
        if (!User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

<<<<<<< HEAD
=======
        // Guard: must be a Seller
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
        if (!User.IsInRole("Seller"))
        {
            Response.Redirect("~/PropertyForRent.aspx");
            return;
        }

<<<<<<< HEAD
        // Ensure isHidden column exists — safe to run every time
        EnsureIsHiddenColumn();

=======
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
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
<<<<<<< HEAD
                string sqlquery = "SELECT propertyNo, street, city, postcode, type, rooms, rent, ownerNo, staffNo, branchNo, isHidden FROM PropertyForRent WHERE propertyNo=@propertyNo";
=======
                string sqlquery = "SELECT * FROM PropertyForRent WHERE propertyNo=@propertyNo";
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
                using (SQLiteCommand sqlcomm = new SQLiteCommand(sqlquery, con))
                {
                    sqlcomm.Parameters.AddWithValue("@propertyNo", propertyID);
                    con.Open();

                    using (SQLiteDataReader reader = sqlcomm.ExecuteReader())
                    {
<<<<<<< HEAD
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
=======
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                propertyNo.Text = reader.GetString(0);
                                txtStreet.Text = reader.GetString(1);
                                txtCity.Text = reader.GetString(2);
                                txtPostCode.Text = reader.GetString(3);
                                txtType.Text = reader.GetString(4);
                                txtRooms.Text = reader.GetString(5);
                                txtRent.Text = reader.GetDecimal(6).ToString();
                                string ownerNo = reader.GetString(7);
                                ownerDropdown(ownerNo);
                                string staffNo = reader.GetString(8);
                                staffDropdown(staffNo);
                                string branchNo = reader.GetString(9);
                                branchDropdown(branchNo);

                                // Show the currently uploaded image (if any)
                                ShowCurrentImage(propertyNo.Text);
                            }
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
                        }
                    }
                }
            }
        }
    }

    /// <summary>
<<<<<<< HEAD
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

=======
    /// Looks for an uploaded image in ~/Images/Properties/ matching this propertyNo.
    /// Displays it if found, otherwise shows the "no image" placeholder.
    /// </summary>
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
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
<<<<<<< HEAD
                    DDLOwnerNo.SelectedValue = ownerNum;
=======
                {
                    DDLOwnerNo.SelectedValue = ownerNum;
                }
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
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
<<<<<<< HEAD
                    DDLStaffNo.SelectedValue = staffNum;
=======
                {
                    DDLStaffNo.SelectedValue = staffNum;
                }
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
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
<<<<<<< HEAD
                    DDLBranchNo.SelectedValue = branchNum;
=======
                {
                    DDLBranchNo.SelectedValue = branchNum;
                }
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
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

<<<<<<< HEAD
=======
        // Handle image upload first
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
        if (fileUploadInput.HasFile)
        {
            string ext = Path.GetExtension(fileUploadInput.FileName).ToLower();
            string[] allowed = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

            if (!allowed.Contains(ext))
            {
<<<<<<< HEAD
                lblUploadMessage.Text = "Invalid file type. Please upload JPG, PNG, GIF or WEBP.";
=======
                lblUploadMessage.Text = "❌ Invalid file type. Please upload JPG, PNG, GIF or WEBP.";
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
                lblUploadMessage.ForeColor = System.Drawing.Color.Red;
                ShowCurrentImage(propertyID);
                return;
            }

            if (fileUploadInput.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
<<<<<<< HEAD
                lblUploadMessage.Text = "File too large. Maximum size is 5 MB.";
=======
                lblUploadMessage.Text = "❌ File too large. Maximum size is 5 MB.";
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
                lblUploadMessage.ForeColor = System.Drawing.Color.Red;
                ShowCurrentImage(propertyID);
                return;
            }

<<<<<<< HEAD
            string folder = Server.MapPath("~/Images/Properties/");
            foreach (var oldExt in new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" })
            {
                string oldPath = Path.Combine(folder, propertyID + oldExt);
                if (File.Exists(oldPath)) File.Delete(oldPath);
            }
            fileUploadInput.SaveAs(Path.Combine(folder, propertyID + ext));
        }

=======
            // Delete any previous image for this property (all extensions)
            string folder = Server.MapPath("~/Images/Properties/");
            foreach (var oldExt in new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" })
            {
                string old = Path.Combine(folder, propertyID + oldExt);
                if (File.Exists(old)) File.Delete(old);
            }

            // Save new image
            string savePath = Path.Combine(folder, propertyID + ext);
            fileUploadInput.SaveAs(savePath);
        }

        // Update property details in DB
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            con.Open();
            string sqlquery = "UPDATE PropertyForRent SET street=@street, city=@city, postcode=@postcode, type=@type, rooms=@rooms, rent=@rent, ownerNo=@ownerNo, staffNo=@staffNo, branchNo=@branchNo WHERE propertyNo=@propertyNo";
            using (SQLiteCommand cmd = new SQLiteCommand(sqlquery, con))
            {
<<<<<<< HEAD
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
=======
                cmd.Parameters.AddWithValue("@street", txtStreet.Text);
                cmd.Parameters.AddWithValue("@city", txtCity.Text);
                cmd.Parameters.AddWithValue("@postcode", txtPostCode.Text);
                cmd.Parameters.AddWithValue("@type", txtType.Text);
                cmd.Parameters.AddWithValue("@rooms", txtRooms.Text);
                cmd.Parameters.AddWithValue("@rent", txtRent.Text);
                cmd.Parameters.AddWithValue("@ownerNo", DDLOwnerNo.Text);
                cmd.Parameters.AddWithValue("@staffNo", DDLStaffNo.Text);
                cmd.Parameters.AddWithValue("@branchNo", DDLBranchNo.Text);
                cmd.Parameters.AddWithValue("@propertyNo", propertyID);

>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
                cmd.ExecuteNonQuery();
            }
        }

        Response.Redirect("PropertyForRent.aspx");
    }
<<<<<<< HEAD

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
=======
}
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
