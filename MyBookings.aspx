<%@ Page Title="My Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="MyBookings.aspx.cs" Inherits="MyBookings" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 30px; max-width: 1050px;">
        <div class="row">
            <div class="col-md-12">
                <h2 style="font-weight: 700; color: #2C3E50;">My Bookings & Rentals</h2>
                <p style="color: #7f8c8d; font-size: 1.05em;">
                    View your booked properties. When you are ready to finish your stay, click <strong>Check Out & Release</strong> to return the property back to the public so others can rent it.
                </p>
                <asp:Label ID="lblStatusMessage" runat="server" EnableViewState="false" style="display:block; margin: 15px 0; font-weight: 600;"></asp:Label>
                <hr style="border-top: 2px solid #3498db; width: 60px; margin-left: 0; margin-bottom: 25px;" />
            </div>
        </div>

        <div class="row">
            <asp:Repeater ID="rptBookings" runat="server" OnItemCommand="rptBookings_ItemCommand">
                <ItemTemplate>
                    <div class="col-md-6" style="margin-bottom: 25px;">
                        <div class="card h-100" style="border: 1px solid #e5e5e5; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); overflow: hidden; background: #fff; display: flex; flex-direction: column;">
                            <div style="height: 180px; background: url('<%# GetCityImage(Eval("city"), Eval("PropertyNo")) %>') center/cover no-repeat; position: relative;">
                                <div style="position: absolute; top: 12px; right: 12px;">
                                    <%# IsActive(Eval("Status")) ? "<span class='badge' style='background: #27ae60; font-size: 0.85em; padding: 6px 12px;'>Currently Rented</span>" : "<span class='badge' style='background: #7f8c8d; font-size: 0.85em; padding: 6px 12px;'>Checked Out / Released</span>" %>
                                </div>
                            </div>
                            <div style="padding: 20px; flex: 1;">
                                <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 8px;">
                                    <h4 style="margin: 0; font-weight: 700; color: #333;">
                                        <%# Eval("type") %> in <%# Eval("city") %>
                                    </h4>
                                    <span style="font-size: 1.25em; font-weight: 700; color: #e74c3c;">
                                        $<%# Eval("rent", "{0:0.00}") %><small style="color: #888; font-size: 0.6em;">/mo</small>
                                    </span>
                                </div>
                                <p style="color: #666; margin-bottom: 12px;">
                                    <i class="glyphicon glyphicon-map-marker"></i> <%# Eval("street") %>, <%# Eval("postcode") %>
                                </p>
                                <div style="background: #f8f9fa; border-radius: 8px; padding: 12px; font-size: 0.9em; color: #555; margin-bottom: 15px;">
                                    <div><strong>Property No:</strong> <%# Eval("PropertyNo") %></div>
                                    <div><strong>Booked On:</strong> <%# Eval("PurchaseDate", "{0:MMM dd, yyyy HH:mm}") %></div>
                                    <div><strong>Payment Method:</strong> <%# Eval("PaymentMethod") %></div>
                                    <div><strong>Total Paid:</strong> $<%# Eval("TotalAmount", "{0:0.00}") %></div>
                                </div>
                            </div>
                            <div style="padding: 15px 20px; background: #fafafa; border-top: 1px solid #eee; text-align: right;">
                                <asp:Button ID="btnCheckoutRelease" runat="server"
                                    Text="Check Out & Release Property"
                                    CommandName="Release"
                                    CommandArgument='<%# Eval("PropertyNo") %>'
                                    Visible='<%# IsActive(Eval("Status")) %>'
                                    CssClass="btn"
                                    style="background-color: #e67e22; color: #fff; font-weight: 700; border-radius: 8px; padding: 8px 18px;"
                                    OnClientClick="return confirm('Are you sure you want to check out of this property? It will immediately be released back to the public for other buyers to rent.');" />
                                <span style="color: #888; font-style: italic; font-size: 0.9em;" visible='<%# !IsActive(Eval("Status")) %>'>Stay completed</span>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoBookings" runat="server" Visible="false">
                <div class="col-md-12">
                    <div style="text-align: center; padding: 60px 20px; background: #fff; border-radius: 12px; border: 1px dashed #ccc; margin-top: 10px;">
                        <i class="glyphicon glyphicon-home" style="font-size: 3.5em; color: #bdc3c7;"></i>
                        <h4 style="margin-top: 15px; color: #555;">No bookings yet</h4>
                        <p style="color: #888; margin-bottom: 20px;">You haven't rented any properties yet. Explore available properties to find your dream stay!</p>
                        <a href="PropertyForRent.aspx" class="btn btn-primary" style="background: #e74c3c; border: none; border-radius: 20px; padding: 10px 24px; font-weight: 600;">Browse Properties</a>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
