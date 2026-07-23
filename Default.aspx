<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)), url('https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
            border-radius: 20px;
            padding: 100px 40px;
            text-align: center;
            color: white;
            margin-bottom: 50px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .hero-title {
            font-size: 4em;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
        .hero-subtitle {
            font-size: 1.5em;
            margin-bottom: 40px;
            font-weight: 300;
        }
        .search-container {
            background: white;
            border-radius: 50px;
            padding: 6px;
            display: flex;
            align-items: center;
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            box-sizing: border-box;
        }
        .search-input {
            border: none;
            padding: 15px 20px;
            font-size: 1.2em;
            flex-grow: 1;
            flex-shrink: 1;
            flex-basis: 0;
            min-width: 0;
            max-width: 100%;
            box-sizing: border-box;
            outline: none;
            color: #333;
            background: transparent;
        }
        .search-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-size: 1.2em;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            flex-grow: 0;
            flex-shrink: 0;
            white-space: nowrap;
        }
        .search-btn:hover {
            background-color: #c0392b;
        }
        .feature-card {
            text-align: center;
            padding: 30px;
            border-radius: 15px;
            background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }
        .feature-card:hover {
            transform: translateY(-10px);
        }
        .feature-icon {
            font-size: 3em;
            color: #3498db;
            margin-bottom: 20px;
        }
        @media (max-width: 767px) {
            .hero-section {
                padding: 70px 18px;
                border-radius: 14px;
            }
            .hero-title {
                font-size: 2.6em;
            }
            .hero-subtitle {
                font-size: 1.15em;
            }
            .search-container {
                border-radius: 24px;
                flex-direction: column;
                align-items: stretch;
                gap: 8px;
                padding: 10px;
            }
            .search-input {
                width: 100%;
                font-size: 1em;
                padding: 13px 16px;
            }
            .search-btn {
                width: 100%;
                margin-left: 0;
                padding: 12px 20px;
            }
        }
    </style>

    <div class="hero-section">
        <h1 class="hero-title">Find your next perfect stay</h1>
        <p class="hero-subtitle">Discover houses, flats, and premium properties tailored for you.</p>

        <asp:Panel ID="pnlSearch" runat="server">
            <div class="search-container">
                <input type="text" id="txtSearchInput" class="search-input" placeholder="Where do you want to live? (e.g., Glasgow)" onkeydown="if(event.key==='Enter'){doSearch();return false;}" />
                <button type="button" class="search-btn" onclick="doSearch()">Search</button>
            </div>
        </asp:Panel>
    </div>

    <div class="row" style="margin-top: 60px; margin-bottom: 40px;">
        <div class="col-md-12 text-center">
            <h2 style="font-weight: 700; color: #2c3e50; margin-bottom: 40px;">Why book with Dreamhouse?</h2>
        </div>
        <div class="col-md-4">
            <div class="feature-card">
                <i class="glyphicon glyphicon-globe feature-icon"></i>
                <h3 style="font-weight: 600; color: #333;">Wide Selection</h3>
                <p class="text-muted">Explore hundreds of properties across top cities to find your perfect match.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card">
                <i class="glyphicon glyphicon-lock feature-icon"></i>
                <h3 style="font-weight: 600; color: #333;">Secure Booking</h3>
                <p class="text-muted">Our dedicated agents ensure every transaction is transparent and secure.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card">
                <i class="glyphicon glyphicon-heart feature-icon"></i>
                <h3 style="font-weight: 600; color: #333;">Premium Support</h3>
                <p class="text-muted">We provide 24/7 assistance to make your moving process seamless.</p>
            </div>
        </div>
    </div>

    <script>
        function doSearch() {
            var input = document.getElementById('txtSearchInput');
            var keyword = input.value.trim();
            if (keyword.length > 0) {
                window.location.href = 'SearchResults.aspx?q=' + encodeURIComponent(keyword);
            } else {
                alert('Please enter a search keyword (e.g., city, street, or property type).');
            }
        }
    </script>
</asp:Content>
