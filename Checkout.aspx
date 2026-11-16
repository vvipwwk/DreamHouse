<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="Checkout" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top:30px; max-width:980px;">
        <h2 style="font-weight:700; color:#2C3E50;">Checkout</h2>
        <p style="color:#6c757d; margin-bottom:20px;">Review your billing summary and contact details before confirming the enquiry.</p>
        <asp:Label ID="lblMessage" runat="server" EnableViewState="false" style="font-weight:700; display:block; margin-bottom:15px;"></asp:Label>

        <div class="row">
            <div class="col-md-7">
                <div class="checkout-panel">
                    <h3>Buyer Details</h3>
                    
                    <%-- Full Name (Max 35 chars) --%>
                    <div class="form-group">
                        <label>Full Name <small style="color:#7f8c8d; font-weight:normal;">(Max 35 characters)</small></label>
                        <asp:TextBox ID="txtBuyerName" runat="server" CssClass="form-control" MaxLength="35" placeholder="e.g. John Doe" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBuyerName" ErrorMessage="Full name is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtBuyerName" ValidationExpression="^.{1,35}$" ErrorMessage="Full name cannot exceed 35 characters." CssClass="text-danger" Display="Dynamic" />
                    </div>

                    <%-- Email --%>
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtBuyerEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="60" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBuyerEmail" ErrorMessage="Email is required." CssClass="text-danger" Display="Dynamic" />
                    </div>

                    <%-- Contact Number (+60/+65, max 9 numeric digits) --%>
                    <div class="form-group">
                        <label>Contact Number <small style="color:#7f8c8d; font-weight:normal;">(Prefix + Max 9 numeric digits only)</small></label>
                        <div style="display:flex; gap:10px;">
                            <asp:DropDownList ID="ddlCountryCode" runat="server" CssClass="form-control" style="max-width:130px; font-weight:600;">
                                <asp:ListItem Text="+60 (MY)" Value="+60" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="+65 (SG)" Value="+65"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-control" MaxLength="9" placeholder="e.g. 123456789" />
                        </div>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtContactNo" ErrorMessage="Contact number is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtContactNo" ValidationExpression="^[0-9]{1,9}$" ErrorMessage="Contact number must contain only numeric digits (maximum 9 digits, no symbols or letters)." CssClass="text-danger" Display="Dynamic" />
                    </div>

                    <%-- Billing Address (35 to 50 characters per address line) --%>
                    <div class="form-group">
                        <label>Billing Address <small style="color:#7f8c8d; font-weight:normal;">(35 to 50 characters per address line)</small></label>
                        <div style="margin-bottom:10px;">
                            <asp:TextBox ID="txtAddressLine1" runat="server" CssClass="form-control" MaxLength="50" placeholder="Address Line 1 (35 - 50 characters)" />
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:3px;">
                                <div>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAddressLine1" ErrorMessage="Address Line 1 is required." CssClass="text-danger" Display="Dynamic" />
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAddressLine1" ValidationExpression="^.{35,50}$" ErrorMessage="Address Line 1 must be between 35 and 50 characters." CssClass="text-danger" Display="Dynamic" />
                                </div>
                                <small id="lblLine1Count" style="color:#7f8c8d;"></small>
                            </div>
                        </div>
                        <div>
                            <asp:TextBox ID="txtAddressLine2" runat="server" CssClass="form-control" MaxLength="50" placeholder="Address Line 2 (Optional, 35 - 50 characters)" />
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:3px;">
                                <div>
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAddressLine2" ValidationExpression="^(.{35,50})?$" ErrorMessage="Address Line 2 must be between 35 and 50 characters (or left empty)." CssClass="text-danger" Display="Dynamic" />
                                </div>
                                <small id="lblLine2Count" style="color:#7f8c8d;"></small>
                            </div>
                        </div>
                    </div>

                    <%-- Payment Method --%>
                    <div class="form-group">
                        <label>Payment Method</label>
                        <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Online Banking" Value="Online Banking"></asp:ListItem>
                            <asp:ListItem Text="Credit / Debit Card" Value="Credit / Debit Card"></asp:ListItem>
                            <asp:ListItem Text="Cash Deposit" Value="Cash Deposit"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:Button ID="btnConfirmCheckout" runat="server" Text="Confirm Checkout" CssClass="btn confirm-button" OnClick="btnConfirmCheckout_Click" />
                    <a href="PropertyForRent.aspx" class="btn back-button">Back to Properties</a>
                </div>
            </div>

            <div class="col-md-5">
                <div class="checkout-panel summary-panel">
                    <h3>Billing Summary</h3>
                    <p class="summary-title"><asp:Literal ID="litPropertyTitle" runat="server"></asp:Literal></p>
                    <p class="summary-address"><asp:Literal ID="litPropertyAddress" runat="server"></asp:Literal></p>
                    <div class="summary-row"><span>Monthly rent</span><strong><asp:Literal ID="litMonthlyRent" runat="server"></asp:Literal></strong></div>
                    <div class="summary-row"><span>Service fee (5%)</span><strong><asp:Literal ID="litServiceFee" runat="server"></asp:Literal></strong></div>
                    <div class="summary-row"><span>Tax (6%)</span><strong><asp:Literal ID="litTaxAmount" runat="server"></asp:Literal></strong></div>
                    <div class="summary-row total-row"><span>Total due</span><strong><asp:Literal ID="litTotalAmount" runat="server"></asp:Literal></strong></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Live validation & character count for Address Line 1
            var line1 = document.getElementById('<%= txtAddressLine1.ClientID %>');
            var count1 = document.getElementById('lblLine1Count');
            function checkLine1() {
                if (!line1 || !count1) return;
                var len = line1.value.trim().length;
                count1.textContent = len + " / 50 characters (min 35)";
                count1.style.color = (len >= 35 && len <= 50) ? "#27ae60" : (len === 0 ? "#7f8c8d" : "#e74c3c");
            }
            if (line1) {
                line1.addEventListener('input', checkLine1);
                checkLine1();
            }

            // Live validation & character count for Address Line 2
            var line2 = document.getElementById('<%= txtAddressLine2.ClientID %>');
            var count2 = document.getElementById('lblLine2Count');
            function checkLine2() {
                if (!line2 || !count2) return;
                var len = line2.value.trim().length;
                if (len === 0) {
                    count2.textContent = "Optional (35 - 50 chars)";
                    count2.style.color = "#7f8c8d";
                } else {
                    count2.textContent = len + " / 50 characters (min 35)";
                    count2.style.color = (len >= 35 && len <= 50) ? "#27ae60" : "#e74c3c";
                }
            }
            if (line2) {
                line2.addEventListener('input', checkLine2);
                checkLine2();
            }

            // Restrict contact number to numeric only and max 9 digits
            var contact = document.getElementById('<%= txtContactNo.ClientID %>');
            if (contact) {
                contact.addEventListener('input', function () {
                    this.value = this.value.replace(/[^0-9]/g, '').slice(0, 9);
                });
            }
        });
    </script>

    <style>
        .checkout-panel {
            background:#fff;
            border-radius:10px;
            padding:24px;
            box-shadow:0 4px 16px rgba(0,0,0,0.08);
            margin-bottom:24px;
        }
        .checkout-panel h3 {
            margin-top:0;
            font-weight:700;
            color:#2C3E50;
            font-size:1.35em;
            margin-bottom:20px;
        }
        .confirm-button {
            background:#27ae60;
            color:#fff;
            border-radius:8px;
            font-weight:700;
            padding:10px 18px;
            border:none;
        }
        .confirm-button:hover {
            background:#219150;
            color:#fff;
        }
        .back-button {
            margin-left:8px;
            background:#ecf0f1;
            color:#2C3E50;
            border-radius:8px;
            font-weight:700;
            padding:10px 18px;
            text-decoration:none;
        }
        .summary-title {
            font-weight:700;
            color:#333;
            margin-bottom:4px;
        }
        .summary-address {
            color:#7f8c8d;
            margin-bottom:18px;
        }
        .summary-row {
            display:flex;
            justify-content:space-between;
            margin-bottom:10px;
            color:#555;
        }
        .total-row {
            border-top:1px solid #eaeaea;
            padding-top:12px;
            margin-top:12px;
            font-size:1.15em;
            color:#e74c3c;
        }
    </style>
</asp:Content>
