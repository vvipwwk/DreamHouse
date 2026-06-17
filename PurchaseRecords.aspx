<%@ Page Title="Purchase Records" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="PurchaseRecords.aspx.cs" Inherits="PurchaseRecords" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top:30px;">
        <div style="display:flex; justify-content:space-between; gap:16px; align-items:flex-start; flex-wrap:wrap;">
            <div>
                <h2 style="font-weight:700; color:#2C3E50; margin-top:0;">Buyer Purchase Records</h2>
                <p style="color:#6c757d;">View checkout records by property.</p>
            </div>
            <a href="PropertyForRent.aspx" class="btn" style="background:#ecf0f1; color:#2C3E50; border-radius:8px; font-weight:700;">Back to Properties</a>
        </div>

        <div class="records-filter">
            <asp:DropDownList ID="ddlPropertyFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlPropertyFilter_SelectedIndexChanged"></asp:DropDownList>
            <asp:Label ID="lblRecordCount" runat="server" style="color:#7f8c8d; font-weight:600;"></asp:Label>
        </div>

        <asp:GridView ID="gvPurchaseRecords" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered records-table" GridLines="None" EmptyDataText="No purchase records found for this property.">
            <Columns>
                <asp:BoundField DataField="PropertyNo" HeaderText="Property" />
                <asp:BoundField DataField="PropertyType" HeaderText="Type" />
                <asp:BoundField DataField="BuyerName" HeaderText="Buyer" />
                <asp:BoundField DataField="BuyerEmail" HeaderText="Email" />
                <asp:BoundField DataField="ContactNo" HeaderText="Contact" />
                <asp:BoundField DataField="PurchaseDate" HeaderText="Checkout Date" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="{0:$0.00}" />
                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>
    </div>

    <style>
        .records-filter {
            background:#fff;
            border-radius:10px;
            padding:16px;
            box-shadow:0 3px 12px rgba(0,0,0,0.06);
            display:flex;
            align-items:center;
            gap:14px;
            flex-wrap:wrap;
            margin:16px 0 20px;
        }
        .records-filter .form-control {
            max-width:340px;
        }
        .records-table th {
            background:#2C3E50;
            color:#fff;
            border-color:#2C3E50 !important;
        }
    </style>
</asp:Content>
