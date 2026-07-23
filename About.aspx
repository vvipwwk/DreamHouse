<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .about-hero {
            background: linear-gradient(135deg, #2c3e50 0%, #E74C3C 100%);
            color: white;
            text-align: center;
            padding: 70px 20px 60px;
            margin: -20px -15px 0;
        }
        .about-hero h1 { font-size: 2.6em; font-weight: 800; margin: 0 0 14px; }
        .about-hero p  { font-size: 1.15em; color: rgba(255,255,255,0.85); max-width: 600px; margin: 0 auto; }

        .about-wrap { max-width: 1000px; margin: 0 auto; padding: 0 15px 60px; }

        /* Mission */
        .mission-section {
            display: flex;
            gap: 40px;
            align-items: center;
            padding: 60px 0 40px;
        }
        .mission-text { flex: 1; }
        .mission-text h2 { font-weight: 700; color: #2c3e50; font-size: 1.8em; margin: 0 0 16px; }
        .mission-text p  { color: #555; line-height: 1.8; font-size: 1.02em; margin-bottom: 14px; }
        .mission-img {
            flex: 1;
            background: linear-gradient(135deg, #eaf4fd, #d5e8f8);
            border-radius: 14px;
            height: 260px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 5em;
        }

        /* Stats */
        .stats-section {
            background: #f8f9fa;
            border-radius: 14px;
            padding: 40px;
            display: flex;
            justify-content: space-around;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 60px;
        }
        .stat-item { text-align: center; }
        .stat-item .stat-num {
            font-size: 2.4em;
            font-weight: 800;
            color: #e74c3c;
            display: block;
            line-height: 1;
        }
        .stat-item .stat-label { color: #7f8c8d; font-size: 0.9em; margin-top: 6px; font-weight: 600; }

        /* Why us */
        .why-section h2 { font-weight: 700; color: #2c3e50; font-size: 1.8em; text-align: center; margin-bottom: 36px; }
        .why-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 60px;
        }
        .why-card {
            background: #fff;
            border: 1.5px solid #eaeaea;
            border-radius: 12px;
            padding: 28px 24px;
            text-align: center;
            transition: box-shadow 0.2s;
        }
        .why-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.08); }
        .why-card .icon { font-size: 2.2em; margin-bottom: 14px; }
        .why-card h4 { font-weight: 700; color: #2c3e50; margin: 0 0 10px; font-size: 1.05em; }
        .why-card p  { color: #666; font-size: 0.9em; line-height: 1.65; margin: 0; }

        /* Team */
        .team-section h2 { font-weight: 700; color: #2c3e50; font-size: 1.8em; text-align: center; margin-bottom: 36px; }
        .team-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 60px;
        }
        .team-card {
            background: #fff;
            border: 1.5px solid #eaeaea;
            border-radius: 12px;
            padding: 28px 20px;
            text-align: center;
        }
        .team-avatar {
            width: 80px; height: 80px;
            border-radius: 50%;
            margin: 0 auto 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2em;
            font-weight: 800;
            color: white;
        }
        .team-card h4 { font-weight: 700; color: #2c3e50; margin: 0 0 4px; }
        .team-card .role { color: #e74c3c; font-size: 0.85em; font-weight: 600; margin-bottom: 10px; }
        .team-card p { color: #666; font-size: 0.88em; line-height: 1.6; margin: 0; }

        /* CTA */
        .cta-section {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border-radius: 14px;
            padding: 50px 40px;
            text-align: center;
            color: white;
            margin-bottom: 20px;
        }
        .cta-section h2 { font-size: 1.8em; font-weight: 800; margin: 0 0 14px; }
        .cta-section p  { font-size: 1em; color: rgba(255,255,255,0.88); margin-bottom: 28px; }
        .cta-btn {
            display: inline-block;
            background: white;
            color: #e74c3c;
            font-weight: 700;
            font-size: 1em;
            padding: 14px 36px;
            border-radius: 50px;
            text-decoration: none;
            transition: transform 0.2s;
        }
        .cta-btn:hover { transform: scale(1.04); text-decoration: none; color: #c0392b; }

        @media (max-width: 768px) {
            .mission-section { flex-direction: column; }
            .why-grid, .team-grid { grid-template-columns: 1fr 1fr; }
            .stats-section { gap: 30px; }
        }
        @media (max-width: 480px) {
            .why-grid, .team-grid { grid-template-columns: 1fr; }
        }
    </style>

    <%-- Hero --%>
    <div class="about-hero">
        <h1>About Dreamhouse</h1>
        <p>Your trusted partner in finding the perfect property <br> Connecting buyers, renters, and sellers across the world since 2018.</p>
    </div>

    <div class="about-wrap">

        <%-- Mission --%>
        <div class="mission-section">
            <div class="mission-text">
                <h2>Our Mission</h2>
                <p>At Dreamhouse, we believe everyone deserves a place to call home. Our platform makes the rental and property search process simple, transparent, and stress-free, whether you're a first-time renter or an experienced investor.</p>
                <p>We connect thousands of property seekers with verified listings across the world, backed by a dedicated team of professionals who care about getting you the right match.</p>
            </div>
            <div class="mission-img"><img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80" width="465" height="260"></div>
        </div>

        <%-- Stats --%>
        <div class="stats-section">
            <div class="stat-item">
                <span class="stat-num">2,400+</span>
                <div class="stat-label">Active Listings</div>
            </div>
            <div class="stat-item">
                <span class="stat-num">8,500+</span>
                <div class="stat-label">Happy Tenants</div>
            </div>
            <div class="stat-item">
                <span class="stat-num">320+</span>
                <div class="stat-label">Verified Sellers</div>
            </div>
            <div class="stat-item">
                <span class="stat-num">6</span>
                <div class="stat-label">Years of Service</div>
            </div>
        </div>

        <%-- Why Us --%>
        <div class="why-section">
            <h2>Why Choose Dreamhouse?</h2>
            <div class="why-grid">
                <div class="why-card">
                    <div class="icon">&#x2714;&#xfe0f;</div>
                    <h4>Verified Listings</h4>
                    <p>Every property on our platform is reviewed and verified by our team before going live to ensure accuracy and legitimacy.</p>
                </div>
                <div class="why-card">
                    <div class="icon">&#x1f50d;</div>
                    <h4>Wide Selection</h4>
                    <p>Explore hundreds of properties across top cities to find your perfect match. Filter by city, price, type, and number of rooms to quickly narrow down listings that match exactly what you need.</p>
                </div>
                <div class="why-card">
                    <div class="icon">&#x1f512;</div>
                    <h4>Secure Platform</h4>
                    <p>Your data and transactions are protected with industry-standard security. Buyer and seller accounts are fully separated.</p>
                </div>
                <div class="why-card">
                    <div class="icon">&#x1f4ac;</div>
                    <h4>Direct Enquiries</h4>
                    <p>Contact property owners directly through our built-in enquiry system - no middlemen, no hidden fees.</p>
                </div>
                <div class="why-card">
                    <div class="icon">&#x1f4f1;</div>
                    <h4>Mobile Friendly</h4>
                    <p>Browse and manage your listings from any device. Our responsive design works perfectly on phones and tablets.</p>
                </div>
                <div class="why-card">
                    <div class="icon">&#x1f3e2;</div>
                    <h4>Branch Network</h4>
                    <p>Our branch offices across the world provide in-person support for buyers and sellers who prefer face-to-face service.</p>
                </div>
            </div>
        </div>

        <%-- Team --%>
        <div class="team-section">
            <h2>Meet Our Team</h2>
            <div class="team-grid">
                <div class="team-card">
                    <div class="team-avatar" style="background: linear-gradient(135deg, #3498db, #2980b9);">JL</div>
                    <h4>James Lim</h4>
                    <div class="role">Chief Executive Officer</div>
                    <p>With 15 years in Singapore real estate, James leads Dreamhouse's vision to make property accessible for everyone.</p>
                </div>
                <div class="team-card">
                    <div class="team-avatar" style="background: linear-gradient(135deg, #e74c3c, #c0392b);">SC</div>
                    <h4>Sarah Chen</h4>
                    <div class="role">Head of Operations</div>
                    <p>Sarah oversees our branch network and ensures every listing meets Dreamhouse's quality and verification standards.</p>
                </div>
                <div class="team-card">
                    <div class="team-avatar" style="background: linear-gradient(135deg, #27ae60, #229954);">DW</div>
                    <h4>David Wong</h4>
                    <div class="role">Lead Developer</div>
                    <p>David built and maintains the Dreamhouse platform, ensuring it's fast, secure, and easy to use for all our users.</p>
                </div>
            </div>
        </div>

        <%-- CTA --%>
        <div class="cta-section">
            <h2>Ready to Find Your Dream Property?</h2>
            <p>Browse thousands of verified listings across the world today - it only takes a minute to get started.</p>
            <a href="/PropertyForRent.aspx" class="cta-btn">Browse Properties</a>
        </div>

    </div>
</asp:Content>
