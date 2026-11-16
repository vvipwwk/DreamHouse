<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Account_Login" Async="true" %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <style>
        .body-content { padding-left: 0 !important; padding-right: 0 !important; }
        .login-wrap {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url('https://images.unsplash.com/photo-1542314831-c6a4d14d8c85?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
            margin-left: -15px;
            margin-right: -15px;
            padding: 40px 15px;
        }
        .login-card {
            background: rgba(255,255,255,0.95);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
        }
        .login-card h2 { text-align: center; font-weight: 700; color: #333; margin-top: 0; }
        .login-card .subtitle { text-align: center; color: #666; margin-bottom: 30px; }
        .login-card .field-group { margin-bottom: 20px; }
        .login-card .field-group label { font-weight: 600; color: #555; display: block; margin-bottom: 6px; }
        .login-card .field-group input.form-control {
            width: 100% !important;
            box-sizing: border-box !important;
            padding: 12px !important;
            border-radius: 8px !important;
            font-size: 1.05em !important;
            display: block !important;
            border: 1px solid #ddd !important;
        }
        .login-card .field-group input.form-control:focus { border-color: #e74c3c !important; outline: none !important; box-shadow: 0 0 0 3px rgba(231,76,60,0.15) !important; }
        .login-card .text-danger { font-size: 0.85em; margin-top: 4px; display: block; }
        .login-card .row-remember { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .login-card .row-remember label { color: #666; font-weight: normal; margin: 0; }
        .login-card .row-remember a { color: #e74c3c; text-decoration: none; font-weight: 600; font-size: 0.9em; }
        .login-card .btn-signin {
            width: 100%;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px;
            font-size: 1.15em;
            font-weight: bold;
            cursor: pointer;
            display: block;
            box-sizing: border-box;
        }
        .login-card .btn-signin:hover { background: #c0392b; }
        .login-card .signup-row { text-align: center; margin-top: 20px; color: #666; font-size: 0.95em; }
        .login-card .signup-row a { color: #e74c3c; font-weight: 600; text-decoration: none; }
    </style>

    <div class="login-wrap">
        <div class="login-card">
            <h2>Welcome Back</h2>
            <p class="subtitle">Sign in to your Dreamhouse account</p>

            <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                <div class="alert alert-danger" style="border-radius: 8px; margin-bottom: 16px;">
                    <asp:Literal runat="server" ID="FailureText" />
                </div>
            </asp:PlaceHolder>

            <div class="field-group">
                <label>Email</label>
                <asp:TextBox runat="server" ID="UserName" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName" CssClass="text-danger" ErrorMessage="The email field is required." Display="Dynamic" />
            </div>

            <div class="field-group">
                <label>Password</label>
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="The password field is required." Display="Dynamic" />
            </div>

            <div class="row-remember">
                <div>
                    <asp:CheckBox runat="server" ID="RememberMe" />
                    <asp:Label runat="server" AssociatedControlID="RememberMe" style="color:#666;">Remember me</asp:Label>
                </div>
                <a href="/Account/ForgotPassword.aspx">Forgot Password?</a>
            </div>

            <asp:Button runat="server" OnClick="LogIn" Text="Sign In" CssClass="btn-signin" />

            <p class="signup-row">
                Don't have an account? <asp:HyperLink runat="server" ID="RegisterHyperLink" style="color:#e74c3c; font-weight:600;">Sign up</asp:HyperLink>
            </p>
        </div>
    </div>
</asp:Content>
