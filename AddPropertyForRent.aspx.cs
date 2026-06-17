using System;
using System.Configuration;
using System.Data.SQLite;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AddPropertyForRent : Page
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
            BindDropdown("SELECT ownerNo FROM PrivateOwner ORDER BY ownerNo", DDLOwnerNo, "ownerNo");
            BindDropdown("SELECT staffNo FROM Staff ORDER BY staffNo", DDLStaffNo, "staffNo");
            BindDropdown("SELECT branchNo FROM Branch ORDER BY branchNo", DDLBranchNo, "branchNo");
            txtPropertyNo.Text = GenerateSuggestedPropertyNo();
        }
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/PropertyForRent.aspx");
    }

    protected void btnPublish_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        decimal rent;
        if (!decimal.TryParse(txtRent.Text.Trim(), out rent))
        {
            ShowError("Rent must be a valid number.");
            return;
        }

        string propertyNoValue = txtPropertyNo.Text.Trim().ToUpperInvariant();
        if (PropertyExists(propertyNoValue))
        {
            ShowError("Property No already exists. Please use another property number.");
            return;
        }

        string uploadedExtension = null;
        if (fileUploadInput.HasFile)
        {
            uploadedExtension = ValidateUpload();
            if (uploadedExtension == null) return;
        }

        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        {
            string sqlquery = @"INSERT INTO PropertyForRent
                (propertyNo, street, city, postcode, type, rooms, rent, ownerNo, staffNo, branchNo)
                VALUES
                (@propertyNo, @street, @city, @postcode, @type, @rooms, @rent, @ownerNo, @staffNo, @branchNo)";

            using (SQLiteCommand cmd = new SQLiteCommand(sqlquery, con))
            {
                cmd.Parameters.AddWithValue("@propertyNo", propertyNoValue);
                cmd.Parameters.AddWithValue("@street", txtStreet.Text.Trim());
                cmd.Parameters.AddWithValue("@city", txtCity.Text.Trim());
                cmd.Parameters.AddWithValue("@postcode", txtPostCode.Text.Trim());
                cmd.Parameters.AddWithValue("@type", txtType.Text.Trim());
                cmd.Parameters.AddWithValue("@rooms", txtRooms.Text.Trim());
                cmd.Parameters.AddWithValue("@rent", rent);
                cmd.Parameters.AddWithValue("@ownerNo", DDLOwnerNo.SelectedValue);
                cmd.Parameters.AddWithValue("@staffNo", DDLStaffNo.SelectedValue);
                cmd.Parameters.AddWithValue("@branchNo", DDLBranchNo.SelectedValue);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        if (fileUploadInput.HasFile && uploadedExtension != null)
        {
            SaveUploadedImage(propertyNoValue, uploadedExtension);
        }

        Response.Redirect("~/PropertyForRent.aspx");
    }

    private void BindDropdown(string query, DropDownList dropdown, string fieldName)
    {
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand(query, con))
        {
            con.Open();
            using (SQLiteDataReader reader = cmd.ExecuteReader())
            {
                dropdown.DataSource = reader;
                dropdown.DataTextField = fieldName;
                dropdown.DataValueField = fieldName;
                dropdown.DataBind();
            }
        }
    }

    private string GenerateSuggestedPropertyNo()
    {
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand("SELECT COUNT(*) FROM PropertyForRent", con))
        {
            con.Open();
            int count = Convert.ToInt32(cmd.ExecuteScalar()) + 1;
            string candidate;
            do
            {
                candidate = "PN" + count.ToString("00");
                count++;
            } while (PropertyExists(candidate));

            return candidate;
        }
    }

    private bool PropertyExists(string propertyNoValue)
    {
        using (SQLiteConnection con = new SQLiteConnection(Mainconn))
        using (SQLiteCommand cmd = new SQLiteCommand("SELECT COUNT(*) FROM PropertyForRent WHERE propertyNo=@propertyNo", con))
        {
            cmd.Parameters.AddWithValue("@propertyNo", propertyNoValue);
            con.Open();
            return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
        }
    }

    private string ValidateUpload()
    {
        string ext = Path.GetExtension(fileUploadInput.FileName).ToLowerInvariant();
        string[] allowed = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

        if (!allowed.Contains(ext))
        {
            ShowError("Invalid image type. Please upload JPG, JPEG, PNG, GIF, or WEBP.");
            return null;
        }

        if (fileUploadInput.PostedFile.ContentLength > 5 * 1024 * 1024)
        {
            ShowError("Image is too large. Maximum size is 5 MB.");
            return null;
        }

        return ext;
    }

    private void SaveUploadedImage(string propertyNoValue, string extension)
    {
        string folder = Server.MapPath("~/Images/Properties/");
        if (!Directory.Exists(folder))
        {
            Directory.CreateDirectory(folder);
        }

        string savePath = Path.Combine(folder, propertyNoValue + extension);
        fileUploadInput.SaveAs(savePath);
    }

    private void ShowError(string message)
    {
        lblMessage.Text = message;
        lblMessage.ForeColor = System.Drawing.Color.Red;
    }
}
