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
        // Guard: must be logged in
        if (!User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        // Guard: must be a Seller
        if (!User.IsInRole("Seller"))
        {
            Response.Redirect("~/PropertyForRent.aspx");
            return;
        }

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
                string sqlquery = "SELECT * FROM PropertyForRent WHERE propertyNo=@propertyNo";
                using (SQLiteCommand sqlcomm = new SQLiteCommand(sqlquery, con))
                {
                    sqlcomm.Parameters.AddWithValue("@propertyNo", propertyID);
                    con.Open();

                    using (SQLiteDataReader reader = sqlcomm.ExecuteReader())
                    {
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
                        }
                    }
                }
            }
        }
    }

    /// <summary>
    /// Looks for an uploaded image in ~/Images/Properties/ matching this propertyNo.
    /// Displays it if found, otherwise shows the "no image" placeholder.
    /// </summary>
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
                {
                    DDLOwnerNo.SelectedValue = ownerNum;
                }
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
                {
                    DDLStaffNo.SelectedValue = staffNum;
                }
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
                {
                    DDLBranchNo.SelectedValue = branchNum;
                }
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

        // Handle image upload first
        if (fileUploadInput.HasFile)
        {
            string ext = Path.GetExtension(fileUploadInput.FileName).ToLower();
            string[] allowed = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

            if (!allowed.Contains(ext))
            {
                lblUploadMessage.Text = "❌ Invalid file type. Please upload JPG, PNG, GIF or WEBP.";
                lblUploadMessage.ForeColor = System.Drawing.Color.Red;
                ShowCurrentImage(propertyID);
                return;
            }

            if (fileUploadInput.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                lblUploadMessage.Text = "❌ File too large. Maximum size is 5 MB.";
                lblUploadMessage.ForeColor = System.Drawing.Color.Red;
                ShowCurrentImage(propertyID);
                return;
            }

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
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            con.Open();
            string sqlquery = "UPDATE PropertyForRent SET street=@street, city=@city, postcode=@postcode, type=@type, rooms=@rooms, rent=@rent, ownerNo=@ownerNo, staffNo=@staffNo, branchNo=@branchNo WHERE propertyNo=@propertyNo";
            using (SQLiteCommand cmd = new SQLiteCommand(sqlquery, con))
            {
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

                cmd.ExecuteNonQuery();
            }
        }

        Response.Redirect("PropertyForRent.aspx");
    }
}