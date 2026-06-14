<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ResetPassword.aspx.cs" Inherits="ResetPassword" Async="true" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div style="min-height: 80vh; display: flex; align-items: center; justify-content: center; background: #f9f9f9;">
        <div style="background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 100%; max-width: 450px;">
            <h2 style="text-align: center; font-weight: 700;">Reset Password</h2>
            
            <p class="text-danger">
                <asp:Literal runat="server" ID="ErrorMessage" />
            </p>

            <asp:PlaceHolder id="resetForm" runat="server">
                <div class="form-group">
                    <label style="font-weight: 600;">Email</label>
                    <asp:TextBox runat="server" ID="Email" CssClass="form-control" style="padding: 12px; border-radius: 8px;" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" CssClass="text-danger" ErrorMessage="The email field is required." />
                </div>
                
                <div class="form-group" style="margin-top: 20px;">
                    <label style="font-weight: 600;">New Password</label>
                    <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" style="padding: 12px; border-radius: 8px;" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="The password field is required." />
                </div>
                
                <div class="form-group" style="margin-top: 20px;">
                    <label style="font-weight: 600;">Confirm Password</label>
                    <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control" style="padding: 12px; border-radius: 8px;" />
                    <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" CssClass="text-danger" ErrorMessage="Passwords must match." />
                </div>
                
                <div class="form-group" style="margin-top: 30px;">
                    <asp:Button runat="server" OnClick="Reset_Click" Text="Reset Password" CssClass="btn" style="width: 100%; background: #e74c3c; color: white; padding: 12px; border-radius: 8px; font-weight: bold;" />
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>
