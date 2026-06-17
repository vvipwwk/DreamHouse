<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditPropertyForRent.aspx.cs" Inherits="EditPropertyForRent" MasterPageFile="~/Site.Master" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 30px; max-width: 800px;">
        <asp:Panel ID="propertydb" runat="server">
            
            <div style="margin-bottom: 20px;">
                <asp:LinkButton ID="btnBack" runat="server" OnClick="btnBack_Click" CssClass="btn btn-default" style="border-radius: 20px; font-weight: bold; color: #7f8c8d;">
                    <i class="glyphicon glyphicon-arrow-left"></i> Back to Properties
                </asp:LinkButton>
            </div>

            <div class="card" style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); padding: 40px; margin-bottom: 50px;">
                <h2 style="font-weight: 700; color: #2c3e50; margin-top: 0; margin-bottom: 30px;">Edit Property Details</h2>
                
                <div class="row">
                    <div class="col-md-6 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Property No</label>
                        <asp:TextBox ID="propertyNo" runat="server" CssClass="form-control" ReadOnly="true" style="background-color: #f8f9fa; border-radius: 8px; font-weight:bold;"></asp:TextBox>
                    </div>
                    <div class="col-md-6 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Type</label>
                        <asp:TextBox ID="txtType" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:TextBox>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Street</label>
                        <asp:TextBox ID="txtStreet" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:TextBox>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">City</label>
                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:TextBox>
                    </div>
                    <div class="col-md-6 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Post Code</label>
                        <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:TextBox>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Rooms</label>
                        <asp:TextBox ID="txtRooms" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:TextBox>
                    </div>
                    <div class="col-md-6 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Rent ($)</label>
                        <asp:TextBox ID="txtRent" runat="server" CssClass="form-control" style="border-radius: 8px; font-weight: bold; color: #e74c3c;"></asp:TextBox>
                    </div>
                </div>

                <hr style="margin: 30px 0;" />

                <%-- Property Image Upload --%>
                <h4 style="font-weight: 600; color: #2c3e50; margin-bottom: 20px;">Property Image</h4>

                <%-- Current image preview --%>
                <div style="margin-bottom: 20px;">
                    <asp:Image ID="imgCurrentProperty" runat="server"
                        style="width: 100%; max-height: 260px; object-fit: cover; border-radius: 10px; border: 2px solid #eaeaea; display: none;"
                        AlternateText="Current property image" />
                    <asp:Label ID="lblNoImage" runat="server" Visible="false"
                        style="display: block; padding: 30px; text-align: center; background: #f0f4f8; border-radius: 10px; color: #7f8c8d; font-size: 0.95em;">
                        📷 No image uploaded yet — a city-based default will be shown.
                    </asp:Label>
                </div>

                <div class="form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Upload New Image</label>
                    <div style="border: 2px dashed #3498db; border-radius: 10px; padding: 20px; text-align: center; background: #f8fbff; position: relative; cursor: pointer;"
                         onclick="document.getElementById('fileUploadInput').click();">
                        <div id="uploadPlaceholder" style="pointer-events: none;">
                            <div style="font-size: 2em; margin-bottom: 8px;">🖼️</div>
                            <p style="margin: 0; color: #3498db; font-weight: 600;">Click to select an image</p>
                            <p style="margin: 4px 0 0 0; color: #999; font-size: 0.85em;">JPG, JPEG, PNG, GIF, WEBP — max 5 MB</p>
                        </div>
                        <div id="uploadPreviewBox" style="display: none; pointer-events: none;">
                            <img id="uploadPreviewImg" src="" alt="Preview"
                                 style="max-width: 100%; max-height: 200px; border-radius: 8px; object-fit: cover;" />
                            <p id="uploadFileName" style="margin: 8px 0 0 0; color: #555; font-size: 0.9em;"></p>
                        </div>
                        <asp:FileUpload ID="fileUploadInput" runat="server"
                            style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; opacity: 0; cursor: pointer;"
                            onchange="previewImage(this)" accept="image/*" />
                    </div>
                    <asp:Label ID="lblUploadMessage" runat="server" EnableViewState="false"
                        style="display: block; margin-top: 8px; font-weight: 600;"></asp:Label>
                </div>

                <hr style="margin: 30px 0;" />

                <h4 style="font-weight: 600; color: #2c3e50; margin-bottom: 20px;">Management Details</h4>
                <div class="row">
                    <div class="col-md-4 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Owner No</label>
                        <asp:DropDownList ID="DDLOwnerNo" runat="server" CssClass="form-control" style="border-radius: 8px;">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Staff No</label>
                        <asp:DropDownList ID="DDLStaffNo" runat="server" CssClass="form-control" style="border-radius: 8px;">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 form-group">
                        <label style="color: #7f8c8d; font-weight: 600;">Branch No</label>
                        <asp:DropDownList ID="DDLBranchNo" runat="server" CssClass="form-control" style="border-radius: 8px;">
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="text-right" style="margin-top: 30px;">
                    <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" Text="Save Changes" CssClass="btn btn-primary" style="border-radius: 25px; padding: 12px 30px; font-weight: bold; background-color: #3498db; border: none; font-size: 1.1em; box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);" />
                </div>
            </asp:Panel>
        </div>
    </div>

    <script>
        function previewImage(input) {
            if (!input.files || !input.files[0]) return;

            var file = input.files[0];

            // Validate size (5 MB max)
            if (file.size > 5 * 1024 * 1024) {
                alert('File is too large. Please choose an image under 5 MB.');
                input.value = '';
                return;
            }

            var reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('uploadPlaceholder').style.display = 'none';
                document.getElementById('uploadPreviewBox').style.display = 'block';
                document.getElementById('uploadPreviewImg').src = e.target.result;
                document.getElementById('uploadFileName').textContent = '📁 ' + file.name + ' (' + (file.size / 1024).toFixed(1) + ' KB)';
            };
            reader.readAsDataURL(file);
        }
    </script>
</asp:Content>
