<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Account_Login" Async="true" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div style="min-height: 80vh; display: flex; align-items: center; justify-content: center; background: url('https://images.unsplash.com/photo-1542314831-c6a4d14d8c85?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;">
        <div style="background: rgba(255, 255, 255, 0.95); padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); width: 100%; max-width: 450px;">
            <h2 style="text-align: center; font-weight: 700; color: #333; margin-top: 0;">Welcome Back</h2>
            <p style="text-align: center; color: #666; margin-bottom: 30px;">Sign in to your Dreamhouse account</p>
            
            <section id="loginForm">
                <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                    <div class="alert alert-danger" style="border-radius: 8px;">
                        <asp:Literal runat="server" ID="FailureText" />
                    </div>
                </asp:PlaceHolder>
                
                <div class="form-group">
                    <label style="font-weight: 600; color: #555;">Email / User Name</label>
                    <asp:TextBox runat="server" ID="UserName" CssClass="form-control" style="padding: 12px; border-radius: 8px; font-size: 1.1em;" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName" CssClass="text-danger" ErrorMessage="The user name field is required." Display="Dynamic" />
                </div>
                
                <div class="form-group" style="margin-top: 20px;">
                    <label style="font-weight: 600; color: #555;">Password</label>
                    <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" style="padding: 12px; border-radius: 8px; font-size: 1.1em;" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="The password field is required." Display="Dynamic" />
                </div>
                
                <div class="form-group" style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                    <div class="checkbox" style="margin: 0;">
                        <asp:CheckBox runat="server" ID="RememberMe" />
                        <asp:Label runat="server" AssociatedControlID="RememberMe" style="color: #666;">Remember me</asp:Label>
                    </div>
                    <a href="/Account/ForgotPassword.aspx" style="color: #e74c3c; text-decoration: none; font-weight: 600;">Forgot Password?</a>
                </div>
                
                <div class="form-group" style="margin-top: 30px;">
                    <asp:Button runat="server" OnClick="LogIn" Text="Sign In" CssClass="btn" style="width: 100%; background: #e74c3c; color: white; padding: 12px; border-radius: 8px; font-size: 1.2em; font-weight: bold; border: none;" />
                </div>
                
                <p style="text-align: center; margin-top: 20px; color: #666;">
                    Don't have an account? <asp:HyperLink runat="server" ID="RegisterHyperLink" style="color: #e74c3c; font-weight: 600;">Sign up</asp:HyperLink>
                </p>
            </section>
        </div>
    </div>
</asp:Content>

