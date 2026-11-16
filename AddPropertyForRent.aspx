
<%@ Page Title="Add Property" Language="C#" AutoEventWireup="true" CodeFile="AddPropertyForRent.aspx.cs" Inherits="AddPropertyForRent" MasterPageFile="~/Site.Master" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 30px; max-width: 860px;">
        <div style="margin-bottom: 20px;">



        </div>

        <div class="card" style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); padding: 40px; margin-bottom: 50px;">
            <h2 style="font-weight: 700; color: #2c3e50; margin-top: 0; margin-bottom: 10px;">Publish New Property</h2>
            <p style="color:#7f8c8d; margin-bottom:30px;">Add the property details below. Buyers will be able to view the listing after it is published.</p>

            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="alert alert-danger" DisplayMode="BulletList" />
            <asp:Label ID="lblMessage" runat="server" EnableViewState="false" style="display:block; margin-bottom:15px; font-weight:600;"></asp:Label>

            <div class="row">
                <div class="col-md-6 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Property No <small style="color:#7f8c8d; font-weight:normal; text-transform:none;">(Max 10 characters)</small></label>
                    <asp:TextBox ID="txtPropertyNo" runat="server" CssClass="form-control" MaxLength="10" style="border-radius: 8px; font-weight:bold;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPropertyNo" ErrorMessage="Property No is required." CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPropertyNo" ValidationExpression="^[A-Za-z0-9]{1,10}$" ErrorMessage="Property No must be 1-10 letters or digits only (no spaces or symbols)." CssClass="text-danger" Display="Dynamic" />
                </div>
                <div class="col-md-6 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Type <small style="color:#7f8c8d; font-weight:normal; text-transform:none;">(Max 20 characters)</small></label>
                    <asp:TextBox ID="txtType" runat="server" CssClass="form-control" MaxLength="20" placeholder="House, Flat, Apartment..." style="border-radius: 8px;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtType" ErrorMessage="Type is required." CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtType" ValidationExpression="^[A-Za-z][A-Za-z \-]{0,19}$" ErrorMessage="Type must be 1-20 letters only (e.g. House, Flat, Apartment)." CssClass="text-danger" Display="Dynamic" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-12 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Street <small style="color:#7f8c8d; font-weight:normal; text-transform:none;">(Max 60 characters)</small></label>
                    <asp:TextBox ID="txtStreet" runat="server" CssClass="form-control" MaxLength="60" style="border-radius: 8px;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStreet" ErrorMessage="Street is required." CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtStreet" ValidationExpression="^.{1,60}$" ErrorMessage="Street cannot exceed 60 characters." CssClass="text-danger" Display="Dynamic" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">City <small style="color:#7f8c8d; font-weight:normal; text-transform:none;">(Max 30 characters)</small></label>
                    <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" MaxLength="30" style="border-radius: 8px;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCity" ErrorMessage="City is required." CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtCity" ValidationExpression="^[A-Za-z][A-Za-z .'\-]{0,29}$" ErrorMessage="City must be 1-30 letters only." CssClass="text-danger" Display="Dynamic" />
                </div>
                <div class="col-md-6 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Post Code <small style="color:#7f8c8d; font-weight:normal; text-transform:none;">(Max 10 characters)</small></label>
                    <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control" MaxLength="10" style="border-radius: 8px;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPostCode" ErrorMessage="Post Code is required." CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPostCode" ValidationExpression="^[A-Za-z0-9][A-Za-z0-9 \-]{0,9}$" ErrorMessage="Post Code must be 1-10 letters, digits, space or hyphen." CssClass="text-danger" Display="Dynamic" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Rooms <small style="color:#7f8c8d; font-weight:normal; text-transform:none;">(Max 2 characters)</small></label>
                    <asp:TextBox ID="txtRooms" runat="server" CssClass="form-control" MaxLength="2" style="border-radius: 8px;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRooms" ErrorMessage="Rooms is required." CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtRooms" ValidationExpression="^[1-9][0-9]?$" ErrorMessage="Rooms must be a whole number from 1 to 99." CssClass="text-danger" Display="Dynamic" />
                </div>
                <div class="col-md-6 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Rent ($) <small style="color:#7f8c8d; font-weight:normal; text-transform:none;">(Max 9 characters)</small></label>
                    <asp:TextBox ID="txtRent" runat="server" MaxLength="9" CssClass="form-control" style="border-radius: 8px; font-weight: bold; color: #e74c3c;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRent" ErrorMessage="Rent is required." CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtRent" ValidationExpression="^[0-9]{1,6}(\.[0-9]{1,2})?$" ErrorMessage="Rent must be a number up to 6 digits with at most 2 decimals (e.g. 650 or 650.50)." CssClass="text-danger" Display="Dynamic" />
                </div>
            </div>

            <hr style="margin: 30px 0;" />

            <h4 style="font-weight: 600; color: #2c3e50; margin-bottom: 20px;">Property Image</h4>
            <div class="form-group">
                <label style="color: #7f8c8d; font-weight: 600;">Upload Image</label>


                <div id="dropZone" style="border: 2px dashed #3498db; border-radius: 10px; padding: 20px; text-align: center; background: #f8fbff; position: relative; cursor: pointer;"
                     onclick="triggerFilePicker()"
                     ondragover="handleDragOver(event)"
                     ondragleave="handleDragLeave(event)"
                     ondrop="handleDrop(event)">
                    <div id="uploadPlaceholder">
                        <p style="margin: 0; color: #3498db; font-weight: 600;">Click to select an image</p>
                        <p style="margin: 4px 0 0 0; color: #999; font-size: 0.85em;">JPG, JPEG, PNG, GIF, WEBP - max 5 MB</p>
                    </div>
                    <div id="uploadPreviewBox" style="display: none;">
                        <img id="uploadPreviewImg" src="" alt="Preview" style="max-width: 100%; max-height: 220px; border-radius: 8px; object-fit: cover;" />
                        <p id="uploadFileName" style="margin: 8px 0 4px 0; color: #555; font-size: 0.9em;"></p>
                        <button type="button" onclick="event.stopPropagation(); clearUpload();"
                            style="background: none; border: 1px solid #ccc; padding: 4px 14px; border-radius: 20px; font-size: 0.85em; color: #e74c3c; cursor: pointer;">
                            ✕ Remove
                        </button>
                    </div>
                    <asp:FileUpload ID="fileUploadInput" runat="server"
                        style="display: none;"
                        onchange="previewImage(this)" accept="image/*" />

                </div>
            </div>

            <hr style="margin: 30px 0;" />

            <h4 style="font-weight: 600; color: #2c3e50; margin-bottom: 20px;">Management Details</h4>
            <div class="row">
                <div class="col-md-4 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Owner No</label>
                    <asp:DropDownList ID="DDLOwnerNo" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:DropDownList>
                </div>
                <div class="col-md-4 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Staff No</label>
                    <asp:DropDownList ID="DDLStaffNo" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:DropDownList>
                </div>
                <div class="col-md-4 form-group">
                    <label style="color: #7f8c8d; font-weight: 600;">Branch No</label>
                    <asp:DropDownList ID="DDLBranchNo" runat="server" CssClass="form-control" style="border-radius: 8px;"></asp:DropDownList>
                </div>
            </div>

            <div class="text-right" style="margin-top: 30px;">
                <asp:Button ID="btnPublish" runat="server" OnClick="btnPublish_Click" Text="Publish Property" CssClass="btn btn-primary" style="border-radius: 25px; padding: 12px 30px; font-weight: bold; background-color: #e74c3c; border: none; font-size: 1.1em; box-shadow: 0 4px 10px rgba(231, 76, 60, 0.3);" />
            </div>
        </div>
    </div>

    <script>

        function triggerFilePicker() {
            var input = document.getElementById('<%= fileUploadInput.ClientID %>');
            if (input) input.click();
        }

        function previewImage(input) {
            if (!input.files || !input.files[0]) return;

            var file = input.files[0];
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

        function clearUpload() {
            var input = document.getElementById('<%= fileUploadInput.ClientID %>');
            if (input) input.value = '';
            document.getElementById('uploadPlaceholder').style.display = 'block';
            document.getElementById('uploadPreviewBox').style.display = 'none';
        }

        function handleDragOver(e) {
            e.preventDefault();
            document.getElementById('dropZone').style.borderColor = '#2980b9';
            document.getElementById('dropZone').style.background = '#eaf4fd';
        }

        function handleDragLeave(e) {
            document.getElementById('dropZone').style.borderColor = '#3498db';
            document.getElementById('dropZone').style.background = '#f8fbff';
        }

        function handleDrop(e) {
            e.preventDefault();
            handleDragLeave(e);
            var files = e.dataTransfer.files;
            if (!files || !files[0]) return;
            var input = document.getElementById('<%= fileUploadInput.ClientID %>');
            var dt = new DataTransfer();
            dt.items.add(files[0]);
            input.files = dt.files;
            previewImage(input);
        }

    </script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            function addCounter(el) {
                if (!el) return;
                var max = el.maxLength;
                var s = document.createElement("small");
                s.style.cssText = "display:block; text-align:right; color:#7f8c8d; margin-top:3px;";
                el.parentNode.insertBefore(s, el.nextSibling);
                function update() {
                    var len = el.value.length;
                    s.textContent = len + " / " + max + " characters";
                    s.style.color = len >= max ? "#e74c3c" : "#7f8c8d";
                }
                el.addEventListener("input", update);
                update();
            }
            addCounter(document.getElementById('<%= txtPropertyNo.ClientID %>'));
            addCounter(document.getElementById('<%= txtType.ClientID %>'));
            addCounter(document.getElementById('<%= txtStreet.ClientID %>'));
            addCounter(document.getElementById('<%= txtCity.ClientID %>'));
            addCounter(document.getElementById('<%= txtPostCode.ClientID %>'));
            addCounter(document.getElementById('<%= txtRooms.ClientID %>'));
            addCounter(document.getElementById('<%= txtRent.ClientID %>'));

            // Rooms: digits only
            var rooms = document.getElementById('<%= txtRooms.ClientID %>');
            if (rooms) rooms.addEventListener('input', function () { this.value = this.value.replace(/[^0-9]/g, '').slice(0, 2); });
            // Rent: digits and one decimal point, max 2 decimals
            var rent = document.getElementById('<%= txtRent.ClientID %>');
            if (rent) rent.addEventListener('input', function () {
                var v = this.value.replace(/[^0-9.]/g, '');
                var p = v.split('.');
                if (p.length > 1) v = p[0] + '.' + p.slice(1).join('').slice(0, 2);
                this.value = v.slice(0, 9);
            });
        });
    </script>
</asp:Content>
