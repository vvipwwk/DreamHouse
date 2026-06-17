<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PropertyForRent.aspx.cs" Inherits="PropertyForRent" MasterPageFile="~/Site.Master" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 30px;">
        <div class="row">
            <div class="col-md-12">
                <h2 class="mb-4" style="font-weight: 700; color: #2C3E50;">Available Properties</h2>

                <% if (IsSeller()) { %>
                <div style="margin-bottom: 20px; display:flex; gap:10px; flex-wrap:wrap;">
                    <a href="AddPropertyForRent.aspx" class="btn" style="background:#e74c3c; color:white; border-radius:24px; padding:10px 22px; font-weight:700; text-decoration:none; display:inline-block;">
                        Publish New Property
                    </a>
                    <a href="PurchaseRecords.aspx" class="btn" style="background:#2c3e50; color:white; border-radius:24px; padding:10px 22px; font-weight:700; text-decoration:none; display:inline-block;">
                        View Purchase Records
                    </a>
                </div>
                <% } %>

                <asp:Panel ID="pnlSearchBar" runat="server" Visible="false" style="margin-bottom: 18px;">
                    <div class="buyer-filter-bar">
                        <i class="glyphicon glyphicon-search" style="color:#aaa; font-size:1.3em;"></i>
                        <asp:TextBox ID="txtFilterInput" runat="server" CssClass="form-control filter-keyword" placeholder="Search city, street, postcode or property no." />
                        <asp:DropDownList ID="ddlPriceRange" runat="server" CssClass="form-control filter-select">
                            <asp:ListItem Text="Any price" Value=""></asp:ListItem>
                            <asp:ListItem Text="Up to $400" Value="0-400"></asp:ListItem>
                            <asp:ListItem Text="$401 - $500" Value="401-500"></asp:ListItem>
                            <asp:ListItem Text="$501 - $650" Value="501-650"></asp:ListItem>
                            <asp:ListItem Text="$651+" Value="651-"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlRooms" runat="server" CssClass="form-control filter-select">
                            <asp:ListItem Text="Any rooms" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlPropertyType" runat="server" CssClass="form-control filter-select">
                            <asp:ListItem Text="Any property" Value=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="btnFilter" runat="server" Text="Apply Filter" CssClass="btn filter-button" OnClick="btnFilter_Click" />
                    </div>
                    <asp:Label ID="lblFilterCount" runat="server" Visible="false" CssClass="filter-count"></asp:Label>
                </asp:Panel>

                <asp:Label ID="PurchaseMessage" runat="server" EnableViewState="false" style="font-weight: bold; display: block; margin-top: 10px;"></asp:Label>
                <hr style="border-top: 2px solid #3498db; width: 60px; margin-left: 0;" />
            </div>
        </div>

        <div class="row">
            <asp:Repeater ID="PropertyRepeater" runat="server" OnItemCommand="PropertyRepeater_ItemCommand">
                <ItemTemplate>
                    <div class="col-md-4" style="margin-bottom: 30px;">
                        <div class="card property-card h-100" style="border: none; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); overflow: hidden; transition: transform 0.3s ease;">
                            <!-- Dynamic Image -->
                            <div style="height: 200px; background: url('<%# GetCityImage(Eval("city"), Eval("propertyNo")) %>') center/cover no-repeat;">
                            </div>
                            <div class="card-body" style="padding: 20px; background: white;">
                                <div style="display: flex; justify-content: space-between; align-items: baseline;">
                                    <h4 class="card-title" style="margin-top: 0; font-weight: bold; color: #333;">
                                        <%# Eval("type") %> in <%# Eval("city") %>
                                    </h4>
                                    <span style="font-size: 1.2em; font-weight: bold; color: #e74c3c;">
                                        $<%# Eval("rent", "{0:0.00}") %><small style="color: #7f8c8d; font-size: 0.6em;">/mo</small>
                                    </span>
                                </div>
                                <p class="text-muted" style="margin-bottom: 15px;">
                                    <i class="glyphicon glyphicon-map-marker"></i> <%# Eval("street") %>, <%# Eval("postcode") %>
                                </p>
                                <div style="display: flex; gap: 15px; margin-bottom: 20px; color: #555;">
                                    <span><i class="glyphicon glyphicon-bed"></i> <%# Eval("rooms") %> Rooms</span>
                                    <span><i class="glyphicon glyphicon-tag"></i> Property: <%# Eval("propertyNo") %></span>
                                </div>
                            </div>
                            <div class="card-footer" style="padding: 15px 20px; background: #f8f9fa; border-top: 1px solid #eaeaea; display: flex; gap: 10px;">
                                <% if (IsSeller()) { %>
                                <a href="EditPropertyForRent.aspx?propertyNo=<%# Eval("propertyNo") %>" class="btn" style="flex: 1; background-color: #3498db; color: white; font-weight: 600; border-radius: 8px; text-align: center; display: inline-block;">Edit Details</a>
                                <a href="PurchaseRecords.aspx?propertyNo=<%# Eval("propertyNo") %>" class="btn" style="flex: 1; background-color: #2c3e50; color: white; font-weight: 600; border-radius: 8px; text-align: center; display: inline-block;">Purchases</a>
                                <% } else { %>
                                <asp:Button ID="btnBuy" runat="server" Text="Enquire / Buy" CssClass="btn" style="flex: 1; background-color: #27ae60; color: white; font-weight: 600; border-radius: 8px;" CommandName="Buy" CommandArgument='<%# Eval("propertyNo") %>' />
                                <% } %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <style>
        .property-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
        }
        .buyer-filter-bar {
            background: white;
            border-radius: 12px;
            padding: 14px 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .filter-keyword {
            border: 1px solid #e5e8ec !important;
            min-width: 260px;
            flex: 2 1 320px;
            box-shadow: none !important;
        }
        .filter-select {
            min-width: 145px;
            flex: 1 1 145px;
            border-color: #e5e8ec;
            box-shadow: none;
        }
        .filter-button {
            background:#e74c3c;
            color:white;
            border-radius:20px;
            padding:7px 22px;
            font-weight:600;
            border:none;
            flex: 0 0 auto;
        }
        .filter-count {
            color:#7f8c8d;
            font-size:0.9em;
            display:block;
            margin-top:8px;
        }
        @media (max-width: 767px) {
            .filter-keyword, .filter-select, .filter-button {
                width: 100%;
                min-width: 100%;
            }
        }
    </style>
</asp:Content>
