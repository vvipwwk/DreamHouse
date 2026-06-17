<%@ Page Title="Search Results" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="SearchResults.aspx.cs" Inherits="SearchResults" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 30px; max-width: 960px;">
        <div class="row">
            <div class="col-md-12">
                <h2 style="font-weight: 700; color: #2C3E50;">Search Results</h2>
                <p style="color: #666; margin-bottom: 10px;">
                    Showing properties matching "<strong style="color:#e74c3c;"><%= SearchKeyword %></strong>": &nbsp;<a href="SearchResults.aspx" style="color:#3498db; font-weight:600; text-decoration:none;">Clear search</a>
                </p>
                <p style="color:#7f8c8d; margin-bottom: 20px;"><%= ResultCount %> property(ies) found.</p>
                <hr style="border-top: 2px solid #3498db; width: 60px; margin-left: 0;" />
            </div>
        </div>
        <div class="row">
            <asp:Repeater ID="ResultRepeater" runat="server" OnItemCommand="ResultRepeater_ItemCommand">
                <ItemTemplate>
                    <div class="col-md-4" style="margin-bottom: 30px;">
                        <div class="card property-card h-100" style="border:none; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.1); overflow:hidden; transition:transform .3s ease;">
                            <div style="height:200px; background:url('<%# GetCityImage(Eval("city"), Eval("propertyNo")) %>') center/cover no-repeat;"></div>
                            <div class="card-body" style="padding:20px; background:white;">
                                <div style="display:flex; justify-content:space-between; align-items:baseline;">
                                    <h4 class="card-title" style="margin-top:0; font-weight:bold; color:#333;"><%# Eval("type") %> in <%# Eval("city") %></h4>
                                    <span style="font-size:1.2em; font-weight:bold; color:#e74c3c;">$<%# Eval("rent", "{0:F}") %><small style="color:#7f8c8d; font-size:.6em;">/mo</small></span>
                                </div>
                                <p class="text-muted" style="margin-bottom:15px;"><i class="glyphicon glyphicon-map-marker"></i> <%# Eval("street") %>, <%# Eval("postcode") %></p>
                                <div style="display:flex; gap:15px; margin-bottom:20px; color:#555;"><span><i class="glyphicon glyphicon-bed"></i> <%# Eval("rooms") %> Rooms</span></div>
                            </div>
                            <div class="card-footer" style="padding:15px 20px; background:#f8f9fa; border-top:1px solid #eaeaea; display:flex; gap:10px;">
                                <asp:Button ID="btnBuy" runat="server" Text="Enquire / Buy" CssClass="btn" style="flex:1; background-color:#27ae60; color:white; font-weight:600; border-radius:8px;" CommandName="Buy" CommandArgument='<%# Eval("propertyNo") %>' />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoResults" runat="server" Visible="false">
                <div class="col-md-12">
                    <div style="text-align:center; padding:60px 20px; color:#7f8c8d;">
                        <i class="glyphicon glyphicon-search" style="font-size:3em;"></i>
                        <p style="margin-top:15px; font-size:1.1em;">No properties match your search. Try different keywords.</p>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
    <style>.property-card:hover { transform:translateY(-5px); box-shadow:0 8px 25px rgba(0,0,0,.15) !important; }</style>
</asp:Content>

