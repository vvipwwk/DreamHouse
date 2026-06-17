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
                    <div class="form-group">
                        <label>Full Name</label>
                        <asp:TextBox ID="txtBuyerName" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBuyerName" ErrorMessage="Full name is required." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtBuyerEmail" runat="server" CssClass="form-control" TextMode="Email" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBuyerEmail" ErrorMessage="Email is required." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Contact Number</label>
                        <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtContactNo" ErrorMessage="Contact number is required." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Billing Address</label>
                        <asp:TextBox ID="txtBillingAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBillingAddress" ErrorMessage="Billing address is required." CssClass="text-danger" Display="Dynamic" />
                    </div>
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
        }
        .confirm-button {
            background:#27ae60;
            color:#fff;
            border-radius:8px;
            font-weight:700;
            padding:10px 18px;
            border:none;
        }
        .back-button {
            margin-left:8px;
            background:#ecf0f1;
            color:#2C3E50;
            border-radius:8px;
            font-weight:700;
            padding:10px 18px;
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
            gap:12px;
            padding:11px 0;
            border-bottom:1px solid #edf0f2;
        }
        .total-row {
            border-bottom:none;
            font-size:1.15em;
            color:#e74c3c;
        }
    </style>
</asp:Content>
