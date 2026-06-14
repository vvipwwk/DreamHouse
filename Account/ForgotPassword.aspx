<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ForgotPassword.aspx.cs" Inherits="ForgotPassword" Async="true" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div style="min-height: 80vh; display: flex; align-items: center; justify-content: center; background: #f9f9f9;">
        <div style="background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 100%; max-width: 450px;">
            <h2 style="text-align: center; font-weight: 700;">Forgot Password?</h2>
            <p style="text-align: center; color: #666; margin-bottom: 30px;">Enter your email to reset your password.</p>
            
            <asp:PlaceHolder id="loginForm" runat="server">
                <div class="form-group">
                    <label style="font-weight: 600;">Email</label>
                    <asp:TextBox runat="server" ID="Email" CssClass="form-control" style="padding: 12px; border-radius: 8px;" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" CssClass="text-danger" ErrorMessage="The email field is required." />
                </div>
                
                <div class="form-group" style="margin-top: 30px;">
                    <asp:Button runat="server" OnClick="Forgot" Text="Email Link" CssClass="btn" style="width: 100%; background: #e74c3c; color: white; padding: 12px; border-radius: 8px; font-weight: bold;" />
                </div>
            </asp:PlaceHolder>
            
            <asp:PlaceHolder runat="server" ID="DisplayEmail" Visible="false">
                <div class="alert alert-success" style="border-radius: 8px; text-align: center;">
                    Please check your email (or EmailLog.txt) to reset your password.
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>
