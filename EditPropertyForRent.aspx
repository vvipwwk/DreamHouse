
<%@ Page Title="Edit Property" Language="C#" AutoEventWireup="true" CodeFile="EditPropertyForRent.aspx.cs" Inherits="EditPropertyForRent" MasterPageFile="~/Site.Master" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .edit-wrap {
            max-width: 780px;
            margin: 30px auto 60px;
        }
        .edit-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 40px 44px;
        }
        .edit-card h2 {
            font-weight: 700;
            color: #2c3e50;
            margin: 0 0 30px 0;
            font-size: 1.7em;
        }
        .edit-card h4 {
            font-weight: 700;
            color: #2c3e50;
            margin: 0 0 18px 0;
            font-size: 1.1em;
        }
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 18px;
        }
        .form-col { flex: 1; }
        .form-col.full { flex: 0 0 100%; }
        .form-col label {
            display: block;
            font-size: 0.8em;
            font-weight: 700;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 6px;
        }
        .form-col .form-control {
            width: 100%;
            box-sizing: border-box;
            border: 1.5px solid #e0e4e8;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 0.97em;
            color: #2c3e50;
            background: #fff;
            transition: border-color 0.2s;
        }
        .form-col .form-control:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.12);
        }
        .form-col .form-control[readonly] {
            background: #f4f6f8;
            color: #555;
            font-weight: 700;
        }
        .form-col .form-control.rent-field {
            color: #e74c3c;
            font-weight: 700;
        }
        .section-divider {
            border: none;
            border-top: 1.5px solid #f0f0f0;
            margin: 28px 0;
        }
        /* Image section */
        .current-img {
            width: 100%;
            max-height: 260px;
            object-fit: cover;
            border-radius: 10px;
            border: 1.5px solid #eaeaea;
            margin-bottom: 16px;
            display: none;
        }
        .no-img-placeholder {
            padding: 28px;
            text-align: center;
            background: #f4f6f8;
            border-radius: 10px;
            color: #7f8c8d;
            font-size: 0.92em;
            margin-bottom: 16px;
        }
        .upload-zone {
            border: 2px dashed #3498db;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            background: #f8fbff;
            cursor: pointer;
        }
        .upload-zone p { margin: 0; }
        .upload-zone .click-text { color: #3498db; font-weight: 600; }
        .upload-zone .hint-text  { color: #aaa; font-size: 0.82em; margin-top: 4px !important; }
        #uploadPreviewBox { display: none; }
        #uploadPreviewImg { max-width: 100%; max-height: 220px; border-radius: 8px; object-fit: cover; }
        #uploadFileName   { margin: 8px 0 4px 0; color: #555; font-size: 0.88em; }
        .btn-remove-img {
            background: none; border: 1px solid #ccc;
            padding: 4px 14px; border-radius: 20px;
            font-size: 0.83em; color: #e74c3c; cursor: pointer;
        }
        /* Action buttons */
        .action-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 32px;
        }
        .action-left { display: flex; gap: 10px; flex-wrap: wrap; }
        .btn-action {
            border: none;
            border-radius: 25px;
            padding: 11px 24px;
            font-size: 0.95em;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-action:hover { opacity: 0.85; }
        .btn-delete { background: #e74c3c; color: white; }
        .btn-hide   { background: #f39c12; color: white; }
        .btn-save   { background: #3498db; color: white; padding: 11px 32px; font-size: 1em; }
    </style>

    <div class="edit-wrap">
        <asp:Panel ID="propertydb" runat="server">
            <div class="edit-card">
                <h2>Edit Property Details</h2>

                <%-- Row 1: Property No + Type --%>
                <div class="form-row">
                    <div class="form-col">
                        <label>Property No</label>
                        <asp:TextBox ID="propertyNo" runat="server" CssClass="form-control" ReadOnly="true" />
                    </div>
                    <div class="form-col">
                        <label>Type <span style="text-transform:none; font-weight:normal;">(Max 20 characters)</span></label>
                        <asp:TextBox ID="txtType" runat="server" MaxLength="20" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtType" ErrorMessage="Type is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtType" ValidationExpression="^[A-Za-z][A-Za-z \-]{0,19}$" ErrorMessage="Type must be 1-20 letters only (e.g. House, Flat, Apartment)." CssClass="text-danger" Display="Dynamic" />
                    </div>
                </div>

                <%-- Row 2: Street (full width) --%>
                <div class="form-row">
                    <div class="form-col full">
                        <label>Street <span style="text-transform:none; font-weight:normal;">(Max 60 characters)</span></label>
                        <asp:TextBox ID="txtStreet" runat="server" MaxLength="60" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStreet" ErrorMessage="Street is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtStreet" ValidationExpression="^.{1,60}$" ErrorMessage="Street cannot exceed 60 characters." CssClass="text-danger" Display="Dynamic" />
                    </div>
                </div>

                <%-- Row 3: City + Post Code --%>
                <div class="form-row">
                    <div class="form-col">
                        <label>City <span style="text-transform:none; font-weight:normal;">(Max 30 characters)</span></label>
                        <asp:TextBox ID="txtCity" runat="server" MaxLength="30" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCity" ErrorMessage="City is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtCity" ValidationExpression="^[A-Za-z][A-Za-z .'\-]{0,29}$" ErrorMessage="City must be 1-30 letters only." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="form-col">
                        <label>Post Code <span style="text-transform:none; font-weight:normal;">(Max 10 characters)</span></label>
                        <asp:TextBox ID="txtPostCode" runat="server" MaxLength="10" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPostCode" ErrorMessage="Post Code is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPostCode" ValidationExpression="^[0-9]{1,10}$" ErrorMessage="Post Code must contain digits only (maximum 10 digits)." CssClass="text-danger" Display="Dynamic" />
                    </div>
                </div>

                <%-- Row 4: Rooms + Rent --%>
                <div class="form-row">
                    <div class="form-col">
                        <label>Rooms <span style="text-transform:none; font-weight:normal;">(Max 2 characters)</span></label>
                        <asp:TextBox ID="txtRooms" runat="server" MaxLength="2" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRooms" ErrorMessage="Rooms is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtRooms" ValidationExpression="^[1-9][0-9]?$" ErrorMessage="Rooms must be a whole number from 1 to 99." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="form-col">
                        <label>Rent ($) <span style="text-transform:none; font-weight:normal;">(Max 9 characters)</span></label>
                        <asp:TextBox ID="txtRent" runat="server" MaxLength="9" CssClass="form-control rent-field" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRent" ErrorMessage="Rent is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtRent" ValidationExpression="^[0-9]{1,6}(\.[0-9]{1,2})?$" ErrorMessage="Rent must be a number up to 6 digits with at most 2 decimals (e.g. 650 or 650.50)." CssClass="text-danger" Display="Dynamic" />
                    </div>
                </div>

                <hr class="section-divider" />

                <%-- Property Image --%>
                <h4>Property Image</h4>

                <asp:Image ID="imgCurrentProperty" runat="server" CssClass="current-img" AlternateText="Current property image" />
                <asp:Label ID="lblNoImage" runat="server" Visible="false">
                    <div class="no-img-placeholder">No image uploaded yet — a city-based default will be shown.</div>
                </asp:Label>

                <div class="form-col" style="margin-bottom:18px;">
                    <label>Upload New Image</label>
                    <div id="dropZone" class="upload-zone"
                         onclick="triggerFilePicker()"
                         ondragover="handleDragOver(event)"
                         ondragleave="handleDragLeave(event)"
                         ondrop="handleDrop(event)">
                        <div id="uploadPlaceholder">
                            <p class="click-text">Click to select an image</p>
                            <p class="hint-text">JPG, JPEG, PNG, GIF, WEBP — max 5 MB</p>
                        </div>
                        <div id="uploadPreviewBox">
                            <img id="uploadPreviewImg" src="" alt="Preview" />
                            <p id="uploadFileName"></p>
                            <button type="button" class="btn-remove-img" onclick="event.stopPropagation(); clearUpload();">Remove</button>
                        </div>
                        <asp:FileUpload ID="fileUploadInput" runat="server" style="display:none;" onchange="previewImage(this)" accept="image/*" />
                    </div>
                    <asp:Label ID="lblUploadMessage" runat="server" EnableViewState="false" style="display:block; margin-top:8px; font-weight:600;"></asp:Label>
                </div>

                <hr class="section-divider" />

                <%-- Management Details --%>
                <h4>Management Details</h4>
                <div class="form-row">
                    <div class="form-col">
                        <label>Owner No</label>
                        <asp:DropDownList ID="DDLOwnerNo" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-col">
                        <label>Staff No</label>
                        <asp:DropDownList ID="DDLStaffNo" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-col">
                        <label>Branch No</label>
                        <asp:DropDownList ID="DDLBranchNo" runat="server" CssClass="form-control" />
                    </div>
                </div>

                <%-- Action Buttons --%>
                <div class="action-row">
                    <div class="action-left">
                        <asp:Button ID="btnDelete" runat="server" CausesValidation="false" OnClick="btnDelete_Click"
                            Text="Delete Property" CssClass="btn-action btn-delete"
                            OnClientClick="return confirm('Permanently delete this property? This cannot be undone.');" />
                        <asp:Button ID="btnToggleHide" runat="server" CausesValidation="false" OnClick="btnToggleHide_Click"
                            Text="Hide from Buyers" CssClass="btn-action btn-hide" />
                    </div>
                    <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click"
                        Text="Save Changes" CssClass="btn-action btn-save" />
                </div>

            </div>
        </asp:Panel>
    </div>

    <script>
        function triggerFilePicker() {
            var input = document.getElementById('<%= fileUploadInput.ClientID %>');
            if (input) input.click();
        }
        function previewImage(input) {
            if (!input.files || !input.files[0]) return;
            var file = input.files[0];
            if (file.size > 5 * 1024 * 1024) { alert('File too large. Max 5 MB.'); input.value = ''; return; }
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('uploadPlaceholder').style.display = 'none';
                document.getElementById('uploadPreviewBox').style.display = 'block';
                document.getElementById('uploadPreviewImg').src = e.target.result;
                document.getElementById('uploadFileName').textContent = file.name + ' (' + (file.size/1024).toFixed(1) + ' KB)';
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
            document.getElementById('dropZone').style.background  = '#eaf4fd';
        }
        function handleDragLeave(e) {
            document.getElementById('dropZone').style.borderColor = '#3498db';
            document.getElementById('dropZone').style.background  = '#f8fbff';
        }
        function handleDrop(e) {
            e.preventDefault(); handleDragLeave(e);
            var files = e.dataTransfer.files;
            if (!files || !files[0]) return;
            var input = document.getElementById('<%= fileUploadInput.ClientID %>');
            var dt = new DataTransfer(); dt.items.add(files[0]); input.files = dt.files;
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
            addCounter(document.getElementById('<%= txtType.ClientID %>'));
            addCounter(document.getElementById('<%= txtStreet.ClientID %>'));
            addCounter(document.getElementById('<%= txtCity.ClientID %>'));
            addCounter(document.getElementById('<%= txtPostCode.ClientID %>'));
            addCounter(document.getElementById('<%= txtRooms.ClientID %>'));
            addCounter(document.getElementById('<%= txtRent.ClientID %>'));

            // Numeric-only restrictions (typing, pasting and dropping text are all filtered)
            function restrict(id, clean, allowedKey) {
                var el = document.getElementById(id);
                if (!el) return;
                el.setAttribute('inputmode', 'decimal');
                el.addEventListener('keypress', function (e) {
                    if (e.ctrlKey || e.metaKey || e.key.length > 1) return;
                    if (!allowedKey.test(e.key)) e.preventDefault();
                });
                el.addEventListener('input', function () {
                    var v = clean(this.value);
                    if (v !== this.value) this.value = v;
                });
            }
            restrict('<%= txtPostCode.ClientID %>', function (v) { return v.replace(/[^0-9]/g, '').slice(0, 10); }, /[0-9]/);
            restrict('<%= txtRooms.ClientID %>', function (v) { return v.replace(/[^0-9]/g, '').slice(0, 2); }, /[0-9]/);
            restrict('<%= txtRent.ClientID %>', function (v) {
                v = v.replace(/[^0-9.]/g, '');
                var p = v.split('.');
                if (p.length > 1) v = p[0].slice(0, 6) + '.' + p.slice(1).join('').slice(0, 2);
                else v = v.slice(0, 6);
                return v;
            }, /[0-9.]/);
        });
    </script>
</asp:Content>
