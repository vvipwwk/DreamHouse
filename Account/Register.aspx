<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Account_Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <style>
        .body-content { padding-left: 0 !important; padding-right: 0 !important; }
        .register-wrap {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
            margin-left: -15px;
            margin-right: -15px;
            padding: 40px 15px;
        }
        .register-card {
            background: rgba(255,255,255,0.97);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 480px;
        }
        .register-card h2 { text-align: center; font-weight: 700; color: #333; margin-top: 0; }
        .register-card .subtitle { text-align: center; color: #666; margin-bottom: 30px; }
        .register-card .field-group { margin-bottom: 20px; }
        .register-card .field-group label.fl { font-weight: 600; color: #555; display: block; margin-bottom: 6px; }
        .register-card .field-group input.form-control {
            width: 100% !important;
            box-sizing: border-box !important;
            padding: 12px !important;
            border-radius: 8px !important;
            font-size: 1.05em !important;
            display: block !important;
            border: 1px solid #ddd !important;
        }
        .register-card .field-group input.form-control:focus { border-color: #e74c3c !important; outline: none !important; box-shadow: 0 0 0 3px rgba(231,76,60,0.15) !important; }
        .register-card .text-danger { font-size: 0.85em; margin-top: 4px; display: block; }
        .role-selector { display: flex; gap: 12px; margin-bottom: 8px; }
        .role-option {
            flex: 1; display: flex; align-items: center; gap: 10px;
            padding: 14px 18px; border: 2px solid #e0e0e0; border-radius: 10px;
            cursor: pointer; font-weight: 600; color: #555; background: #fafafa; transition: all 0.2s;
        }
        .role-option.active-buyer  { border-color: #3498db; background: #eaf4fd; color: #2c3e50; }
        .role-option.active-seller { border-color: #e74c3c; background: #fdf0ee; color: #2c3e50; }
        #roleHint { font-size: 0.85em; color: #888; margin: 6px 0 20px 0; }
        .btn-signup {
            width: 100%; background: #e74c3c; color: white; border: none;
            border-radius: 8px; padding: 14px; font-size: 1.15em; font-weight: bold;
            cursor: pointer; display: block; box-sizing: border-box; margin-top: 10px;
        }
        .btn-signup:hover { background: #c0392b; }
        .signin-row { text-align: center; margin-top: 20px; color: #666; font-size: 0.95em; }
        .signin-row a { color: #e74c3c; font-weight: 600; text-decoration: none; }
    </style>

    <div class="register-wrap">
        <div class="register-card">
            <h2>Create Account</h2>
            <p class="subtitle">Join Dreamhouse and start your journey!</p>

            <p class="text-danger"><asp:Literal runat="server" ID="ErrorMessage" /></p>

            <div style="margin-bottom: 4px;">
                <label style="font-weight:700; color:#333; display:block; margin-bottom:10px;">I want to join as:</label>
                <div class="role-selector">
                    <label id="lblBuyer" class="role-option active-buyer" onclick="selectRole('Buyer')">
                        <asp:RadioButton runat="server" ID="rdBuyer" GroupName="UserRole" Checked="true" style="accent-color:#3498db;" />
                        Buyer
                    </label>
                    <label id="lblSeller" class="role-option" onclick="selectRole('Seller')">
                        <asp:RadioButton runat="server" ID="rdSeller" GroupName="UserRole" style="accent-color:#e74c3c;" />
                        Seller
                    </label>
                </div>
                <p id="roleHint">Buyers can browse properties and make enquiries.</p>
            </div>

            <div class="field-group">
                <label class="fl">Email</label>
                <asp:TextBox runat="server" ID="Email" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" CssClass="text-danger" ErrorMessage="The email field is required." Display="Dynamic" />
            </div>

            <div class="field-group">
                <label class="fl">Password</label>
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="The password field is required." Display="Dynamic" />
            </div>

            <div class="field-group">
                <label class="fl">Confirm Password</label>
                <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword" CssClass="text-danger" Display="Dynamic" ErrorMessage="The confirm password field is required." />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" CssClass="text-danger" Display="Dynamic" ErrorMessage="The password and confirmation password do not match." />
            </div>

            <asp:Button runat="server" OnClick="CreateUser_Click" Text="Sign Up" CssClass="btn-signup" />

            <p class="signin-row">
                Already have an account? <a href="/Account/Login.aspx">Sign in</a>
            </p>
        </div>
    </div>

    <script>
        function selectRole(role) {
            document.getElementById('lblBuyer').className  = 'role-option' + (role === 'Buyer'  ? ' active-buyer'  : '');
            document.getElementById('lblSeller').className = 'role-option' + (role === 'Seller' ? ' active-seller' : '');
            document.getElementById('roleHint').textContent = role === 'Buyer'
                ? 'Buyers can browse properties and make enquiries.'
                : 'Sellers can list, edit and manage their properties.';
        }
        window.onload = function () { selectRole('Buyer'); };
    </script>
</asp:Content>
