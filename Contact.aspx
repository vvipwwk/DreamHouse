<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Hero */
        .contact-hero {
            background: linear-gradient(135deg, #2c3e50 0%, #E74C3C 100%);
            color: white;
            text-align: center;
            padding: 60px 20px 50px;
            margin: -20px -15px 0;
        }
        .contact-hero h1 { font-size: 2.4em; font-weight: 800; margin: 0 0 12px; }
        .contact-hero p  { font-size: 1.05em; color: rgba(255,255,255,0.85); max-width: 540px; margin: 0 auto; }

        .contact-wrap { max-width: 1000px; margin: 0 auto; padding: 50px 15px 60px; }

        /* Info cards row */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 48px;
        }
        .info-card {
            background: #fff;
            border: 1.5px solid #eaeaea;
            border-radius: 12px;
            padding: 28px 20px;
            text-align: center;
            transition: box-shadow 0.2s;
        }
        .info-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.08); }
        .info-card .ic-icon {
            width: 54px; height: 54px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            font-size: 1.5em;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 14px;
        }
        .info-card h4 { font-weight: 700; color: #2c3e50; margin: 0 0 8px; font-size: 1em; }
        .info-card p  { color: #666; font-size: 0.88em; line-height: 1.65; margin: 0; }
        .info-card a  { color: #3498db; text-decoration: none; }
        .info-card a:hover { text-decoration: underline; }

        /* Main layout: form + sidebar */
        .contact-body {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 30px;
            align-items: start;
        }

        /* Form card */
        .form-card {
            background: #fff;
            border: 1.5px solid #eaeaea;
            border-radius: 14px;
            padding: 36px;
        }
        .form-card h2 { font-weight: 700; color: #2c3e50; font-size: 1.4em; margin: 0 0 24px; }
        .fc-row { display: flex; gap: 16px; margin-bottom: 18px; }
        .fc-col { flex: 1; }
        .fc-col.full { flex: 0 0 100%; }
        .fc-col label {
            display: block;
            font-size: 0.76em;
            font-weight: 700;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 6px;
        }
        .fc-col label span.req { color: #e74c3c; margin-left: 2px; }
        .fc-col .form-control {
            width: 100%;
            box-sizing: border-box;
            border: 1.5px solid #e0e4e8;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 0.96em;
            color: #2c3e50;
            background: #fff;
            transition: border-color 0.2s;
            font-family: inherit;
        }
        .fc-col .form-control:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.12);
        }
        .fc-col textarea.form-control { resize: vertical; min-height: 130px; }
        .fc-col select.form-control { appearance: auto; }
        .fc-col .text-danger { font-size: 0.82em; display: block; margin-top: 4px; color: #e74c3c; }

        /* Submit button */
        .btn-submit {
            width: 100%;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px;
            font-size: 1.05em;
            font-weight: 700;
            cursor: pointer;
            box-sizing: border-box;
            transition: background 0.2s;
            margin-top: 6px;
        }
        .btn-submit:hover { background: #c0392b; }

        /* Success message */
        .success-box {
            background: #eafaf1;
            border: 1.5px solid #27ae60;
            border-radius: 10px;
            padding: 20px 24px;
            color: #1e8449;
            font-weight: 600;
            text-align: center;
            display: none;
            margin-top: 16px;
        }

        /* Sidebar */
        .sidebar { display: flex; flex-direction: column; gap: 20px; }
        .side-card {
            background: #fff;
            border: 1.5px solid #eaeaea;
            border-radius: 12px;
            padding: 24px;
        }
        .side-card h4 { font-weight: 700; color: #2c3e50; margin: 0 0 16px; font-size: 1em; }

        /* Office hours */
        .hours-list { list-style: none; padding: 0; margin: 0; }
        .hours-list li {
            display: flex;
            justify-content: space-between;
            padding: 7px 0;
            border-bottom: 1px solid #f4f4f4;
            font-size: 0.88em;
            color: #555;
        }
        .hours-list li:last-child { border-bottom: none; }
        .hours-list li span.day  { font-weight: 600; color: #2c3e50; }
        .hours-list li span.open { color: #27ae60; font-weight: 600; }
        .hours-list li span.closed { color: #e74c3c; font-weight: 600; }

        /* Branch list */
        .branch-item {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            margin-bottom: 14px;
        }
        .branch-item:last-child { margin-bottom: 0; }
        .branch-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            background: #3498db;
            margin-top: 5px;
            flex-shrink: 0;
        }
        .branch-item p { margin: 0; font-size: 0.87em; color: #555; line-height: 1.55; }
        .branch-item strong { color: #2c3e50; }

        /* FAQ */
        .faq-item { margin-bottom: 14px; }
        .faq-item:last-child { margin-bottom: 0; }
        .faq-q { font-size: 0.88em; font-weight: 700; color: #2c3e50; margin-bottom: 4px; }
        .faq-a { font-size: 0.85em; color: #666; line-height: 1.6; }

        @media (max-width: 768px) {
            .contact-body { grid-template-columns: 1fr; }
            .info-grid { grid-template-columns: 1fr; }
            .fc-row { flex-direction: column; }
        }
    </style>

    <%-- Hero --%>
    <div class="contact-hero">
        <h1>Contact Us</h1>
        <p>Have a question or need help with a listing? Our team is ready to assist you.</p>
    </div>

    <div class="contact-wrap">

        <%-- Info Cards --%>
        <div class="info-grid">
            <div class="info-card">
                <div class="ic-icon">&#x1f4de;</div>
                <h4>Call Us</h4>
                <p>+65 6123 4567<br /><a href="tel:+6561234567">Mon - Fri, 9am - 6pm</a></p>
            </div>
            <div class="info-card">
                <div class="ic-icon" style="background: linear-gradient(135deg, #e74c3c, #c0392b);">&#x2709;</div>
                <h4>Email Us</h4>
                <p><a href="mailto:support@dreamhouse.sg">support@dreamhouse.sg</a><br />We reply within 1 business day.</p>
            </div>
            <div class="info-card">
                <div class="ic-icon" style="background: linear-gradient(135deg, #27ae60, #229954);">&#x1f4cd;</div>
                <h4>Visit Us</h4>
                <p>1 Raffles Place, #08-01<br />Singapore 048616</p>
            </div>
        </div>

        <div class="contact-body">

            <%-- Contact Form --%>
            <div class="form-card">
                <h2>Send Us a Message</h2>

                <asp:Panel ID="pnlForm" runat="server">

                    <asp:Panel ID="pnlError" runat="server" Visible="false">
                        <div style="background:#fdf0ee; border:1.5px solid #e74c3c; border-radius:8px; padding:12px 16px; margin-bottom:18px; color:#c0392b; font-size:0.9em;">
                            <asp:Label ID="lblError" runat="server" />
                        </div>
                    </asp:Panel>

                    <div class="fc-row">
                        <div class="fc-col">
                            <label>Full Name <span class="req">*</span></label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="e.g. James Lim" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" CssClass="text-danger" ErrorMessage="Please enter your name." Display="Dynamic" />
                        </div>
                        <div class="fc-col">
                            <label>Email Address <span class="req">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="you@email.com" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" CssClass="text-danger" ErrorMessage="Please enter your email." Display="Dynamic" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" CssClass="text-danger"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Please enter a valid email address." Display="Dynamic" />
                        </div>
                    </div>

                    <div class="fc-row">
                        <div class="fc-col">
                            <label>Phone Number</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="+65 XXXX XXXX" />
                        </div>
                        <div class="fc-col">
                            <label>Enquiry Type <span class="req">*</span></label>
                            <asp:DropDownList ID="ddlEnquiry" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select a topic --</asp:ListItem>
                                <asp:ListItem Value="General">General Enquiry</asp:ListItem>
                                <asp:ListItem Value="Property">Property Question</asp:ListItem>
                                <asp:ListItem Value="Listing">List My Property</asp:ListItem>
                                <asp:ListItem Value="Account">Account / Login Issue</asp:ListItem>
                                <asp:ListItem Value="Complaint">Complaint</asp:ListItem>
                                <asp:ListItem Value="Other">Other</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlEnquiry" CssClass="text-danger"
                                ErrorMessage="Please select an enquiry type." Display="Dynamic" InitialValue="" />
                        </div>
                    </div>

                    <div class="fc-row">
                        <div class="fc-col full">
                            <label>Subject <span class="req">*</span></label>
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Brief summary of your message" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSubject" CssClass="text-danger" ErrorMessage="Please enter a subject." Display="Dynamic" />
                        </div>
                    </div>

                    <div class="fc-row">
                        <div class="fc-col full">
                            <label>Message <span class="req">*</span></label>
                            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Tell us more about your enquiry..." />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage" CssClass="text-danger" ErrorMessage="Please enter your message." Display="Dynamic" />
                        </div>
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="btn-submit" OnClick="btnSubmit_Click" />
                </asp:Panel>

                <%-- Success message shown after submit --%>
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                    <div style="text-align:center; padding: 30px 10px;">
                        <div style="font-size:3em; margin-bottom:16px;">&#x2705;</div>
                        <h3 style="color:#27ae60; font-weight:700; margin:0 0 10px;">Message Sent!</h3>
                        <p style="color:#555; margin-bottom:24px;">Thank you, <asp:Label ID="lblSuccessName" runat="server" style="font-weight:700;" />. We've received your enquiry and will get back to you within 1 business day.</p>
                        <a href="/Contact.aspx" style="color:#3498db; font-weight:600; text-decoration:none;">Send another message</a>
                    </div>
                </asp:Panel>
            </div>

            <%-- Sidebar --%>
            <div class="sidebar">

                <%-- Office Hours --%>
                <div class="side-card">
                    <h4>&#x1f551; Office Hours</h4>
                    <ul class="hours-list">
                        <li><span class="day">Monday</span>     <span class="open">9:00am - 6:00pm</span></li>
                        <li><span class="day">Tuesday</span>    <span class="open">9:00am - 6:00pm</span></li>
                        <li><span class="day">Wednesday</span>  <span class="open">9:00am - 6:00pm</span></li>
                        <li><span class="day">Thursday</span>   <span class="open">9:00am - 6:00pm</span></li>
                        <li><span class="day">Friday</span>     <span class="open">9:00am - 6:00pm</span></li>
                        <li><span class="day">Saturday</span>   <span class="open">10:00am - 2:00pm</span></li>
                        <li><span class="day">Sunday</span>     <span class="closed">Closed</span></li>
                    </ul>
                </div>

                <%-- Branch Offices --%>
                <div class="side-card">
                    <h4>&#x1f3e2; Our Branches</h4>
                    <div class="branch-item">
                        <div class="branch-dot"></div>
                        <p><strong>HQ - Raffles Place</strong><br />1 Raffles Place, #08-01, S048616</p>
                    </div>
                    <div class="branch-item">
                        <div class="branch-dot"></div>
                        <p><strong>Tampines Branch</strong><br />10 Tampines Central 1, #03-12, S529536</p>
                    </div>
                    <div class="branch-item">
                        <div class="branch-dot"></div>
                        <p><strong>Jurong Branch</strong><br />2 Jurong East Street 21, #05-08, S609601</p>
                    </div>
                </div>

                <%-- FAQ --%>
                <div class="side-card">
                    <h4>&#x2753; Quick Answers</h4>
                    <div class="faq-item">
                        <div class="faq-q">How do I list my property?</div>
                        <div class="faq-a">Register as a Seller and use the "Add Property" option in your dashboard.</div>
                    </div>
                    <div class="faq-item">
                        <div class="faq-q">How long does approval take?</div>
                        <div class="faq-a">Listings are typically reviewed and approved within 1 business day.</div>
                    </div>
                    <div class="faq-item">
                        <div class="faq-q">Is Dreamhouse free to use?</div>
                        <div class="faq-a">Browsing is completely free. Seller accounts may have a listing fee.</div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
