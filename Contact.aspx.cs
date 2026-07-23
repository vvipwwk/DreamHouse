using System;
using System.Web.UI;

public partial class Contact : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        // Here you would send an email or save to DB.
        // For now we just show the success panel.
        // Example email send (requires SMTP config in Web.config):
        //
        // var msg = new System.Net.Mail.MailMessage();
        // msg.To.Add("support@dreamhouse.sg");
        // msg.Subject = "[" + ddlEnquiry.SelectedValue + "] " + txtSubject.Text;
        // msg.Body = "From: " + txtName.Text + " <" + txtEmail.Text + ">\n"
        //          + "Phone: " + txtPhone.Text + "\n\n"
        //          + txtMessage.Text;
        // var smtp = new System.Net.Mail.SmtpClient();
        // smtp.Send(msg);

        lblSuccessName.Text = Server.HtmlEncode(txtName.Text.Trim());
        pnlForm.Visible    = false;
        pnlSuccess.Visible = true;
    }
}
