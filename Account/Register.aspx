<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Account_Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div style="min-height: 80vh; display: flex; align-items: center; justify-content: center; background: url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;">
        <div style="background: rgba(255, 255, 255, 0.97); padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); width: 100%; max-width: 480px;">
            <h2 style="text-align: center; font-weight: 700; color: #333; margin-top: 0;">Create Account</h2>
            <p style="text-align: center; color: #666; margin-bottom: 30px;">Join Dreamhouse and start your journey!</p>
            
            <p class="text-danger">
                <asp:Literal runat="server" ID="ErrorMessage" />
            </p>
            
            <%-- Role Selector --%>
            <div style="margin-bottom: 24px;">
                <label style="font-weight: 700; color: #333; display: block; margin-bottom: 10px;">I want to join as:</label>
                <div style="display: flex; gap: 12px;">
                    <label id="lblBuyer" style="flex: 1; display: flex; align-items: center; gap: 10px; padding: 14px 18px; border: 2px solid #e0e0e0; border-radius: 10px; cursor: pointer; transition: all 0.2s; font-weight: 600; color: #555; background: #fafafa;"
                           onclick="selectRole('Buyer', this)">
                        <asp:RadioButton runat="server" ID="rdBuyer" GroupName="UserRole" Checked="true" style="accent-color: #3498db;" />
                        <span>🏠 Buyer</span>
                    </label>
                    <label id="lblSeller" style="flex: 1; display: flex; align-items: center; gap: 10px; padding: 14px 18px; border: 2px solid #e0e0e0; border-radius: 10px; cursor: pointer; transition: all 0.2s; font-weight: 600; color: #555; background: #fafafa;"
                           onclick="selectRole('Seller', this)">
                        <asp:RadioButton runat="server" ID="rdSeller" GroupName="UserRole" style="accent-color: #e74c3c;" />
                        <span>🔑 Seller</span>
                    </label>
                </div>
                <p id="roleHint" style="font-size: 0.85em; color: #888; margin-top: 8px; margin-bottom: 0;">
                    Buyers can browse and enquire about properties. Sellers can list and manage properties.
                </p>
            </div>

            <div class="form-group">
                <label style="font-weight: 600; color: #555;">Email / User Name</label>
                <asp:TextBox runat="server" ID="Email" CssClass="form-control" style="padding: 12px; border-radius: 8px; font-size: 1.1em;" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" CssClass="text-danger" ErrorMessage="The email field is required." Display="Dynamic" />
            </div>
            
            <div class="form-group" style="margin-top: 20px;">
                <label style="font-weight: 600; color: #555;">Password</label>
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" style="padding: 12px; border-radius: 8px; font-size: 1.1em;" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="The password field is required." Display="Dynamic" />
            </div>
            
            <div class="form-group" style="margin-top: 20px;">
                <label style="font-weight: 600; color: #555;">Confirm Password</label>
                <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control" style="padding: 12px; border-radius: 8px; font-size: 1.1em;" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword" CssClass="text-danger" Display="Dynamic" ErrorMessage="The confirm password field is required." />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" CssClass="text-danger" Display="Dynamic" ErrorMessage="The password and confirmation password do not match." />
            </div>
            
            <div class="form-group" style="margin-top: 30px;">
                <asp:Button runat="server" OnClick="CreateUser_Click" Text="Sign Up" CssClass="btn" style="width: 100%; background: #e74c3c; color: white; padding: 12px; border-radius: 8px; font-size: 1.2em; font-weight: bold; border: none;" />
            </div>
            
            <p style="text-align: center; margin-top: 20px; color: #666;">
                Already have an account? <a href="/Account/Login.aspx" style="color: #e74c3c; font-weight: 600;">Sign in</a>
            </p>
        </div>
    </div>

    <script>
        function selectRole(role, clickedLabel) {
            // Reset both
            document.getElementById('lblBuyer').style.borderColor = '#e0e0e0';
            document.getElementById('lblBuyer').style.background = '#fafafa';
            document.getElementById('lblSeller').style.borderColor = '#e0e0e0';
            document.getElementById('lblSeller').style.background = '#fafafa';
            // Highlight selected
            if (role === 'Buyer') {
                document.getElementById('lblBuyer').style.borderColor = '#3498db';
                document.getElementById('lblBuyer').style.background = '#eaf4fd';
                document.getElementById('roleHint').textContent = 'Buyers can browse properties and make enquiries.';
            } else {
                document.getElementById('lblSeller').style.borderColor = '#e74c3c';
                document.getElementById('lblSeller').style.background = '#fdf0ee';
                document.getElementById('roleHint').textContent = 'Sellers can list, edit and manage their properties.';
            }
        }
        // Set initial highlight on page load
        window.onload = function () { selectRole('Buyer', null); };
    </script>
</asp:Content>
