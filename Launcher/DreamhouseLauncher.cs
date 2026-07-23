using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

class DreamhouseLauncher : Form
{
    const int    PORT       = 58457;
    const string APP_NAME   = "Dreamhouse";
    const string LAUNCH_URL = "http://localhost:58457";

    static readonly string[] IIS_PATHS = {
        @"C:\Program Files\IIS Express\iisexpress.exe",
        @"C:\Program Files (x86)\IIS Express\iisexpress.exe"
    };

    Process    _iisProcess;
    NotifyIcon _trayIcon;
    Label      _statusLabel;
    Button     _btnOpen;
    Button     _btnStop;
    Panel      _statusDot;

    [STAThread]
    static void Main()
    {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new DreamhouseLauncher());
    }

    DreamhouseLauncher()
    {
        BuildUI();
        SetupTrayIcon();
        this.Shown += (s, e) => StartServer();
    }

    void BuildUI()
    {
        this.Text            = APP_NAME + " Launcher";
        this.Size            = new Size(420, 320);
        this.StartPosition   = FormStartPosition.CenterScreen;
        this.FormBorderStyle = FormBorderStyle.FixedSingle;
        this.MaximizeBox     = false;
        this.BackColor       = Color.FromArgb(245, 247, 250);
        this.Icon = new Icon(Path.Combine(Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location), "favicon.ico"));
        this.Font            = new Font("Segoe UI", 9f);

        // Header
        var header = new Panel { Dock = DockStyle.Top, Height = 70, BackColor = Color.FromArgb(231, 76, 60) };
        var title  = new Label {
            Text = "Dreamhouse", ForeColor = Color.White,
            Font = new Font("Segoe UI", 18f, FontStyle.Bold),
            AutoSize = false, TextAlign = ContentAlignment.MiddleCenter, Dock = DockStyle.Fill
        };
        header.Controls.Add(title);

        // Status dot
        _statusDot = new Panel { Size = new Size(12, 12), Location = new Point(40, 108), BackColor = Color.Gray };
        MakeCircle(_statusDot);

        _statusLabel = new Label {
            Text = "Starting...", Location = new Point(60, 104),
            Size = new Size(310, 24),
            Font = new Font("Segoe UI", 10f, FontStyle.Bold),
            ForeColor = Color.FromArgb(44, 62, 80)
        };

        // URL clickable link
        var urlLabel = new Label {
            Text = LAUNCH_URL, Location = new Point(40, 135), Size = new Size(340, 20),
            ForeColor = Color.FromArgb(52, 152, 219), Cursor = Cursors.Hand,
            Font = new Font("Segoe UI", 9f, FontStyle.Underline)
        };
        urlLabel.Click += (s, e) => OpenBrowser();

        // Divider
        var divider = new Panel { Location = new Point(30, 168), Size = new Size(355, 1), BackColor = Color.FromArgb(220, 220, 220) };

        // Buttons
        _btnOpen = MakeButton("Open in Browser", Color.FromArgb(52, 152, 219), 40, 188);
        _btnStop = MakeButton("Stop Server",     Color.FromArgb(231, 76, 60),   210, 188);
        var btnTray = MakeButton("Minimize to Tray", Color.FromArgb(127, 140, 141), 40, 238);

        _btnOpen.Click  += (s, e) => OpenBrowser();
        _btnStop.Click  += (s, e) => StopServer();
        btnTray.Click   += (s, e) => this.Hide();

        // Footer
        var footer = new Label {
            Text = "Closing the window minimizes to tray  —  right-click tray icon to exit",
            Location = new Point(0, 288), Size = new Size(420, 18),
            TextAlign = ContentAlignment.MiddleCenter,
            ForeColor = Color.Gray, Font = new Font("Segoe UI", 7.5f)
        };

        this.Controls.AddRange(new Control[] {
            header, _statusDot, _statusLabel, urlLabel, divider,
            _btnOpen, _btnStop, btnTray, footer
        });

        // Close button → minimize to tray
        this.FormClosing += (s, e) => {
            if (e.CloseReason == CloseReason.UserClosing) { e.Cancel = true; this.Hide(); }
        };
    }

    Button MakeButton(string text, Color color, int x, int y)
    {
        var btn = new Button {
            Text = text, Location = new Point(x, y), Size = new Size(160, 36),
            BackColor = color, ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Font = new Font("Segoe UI", 9f, FontStyle.Bold), Cursor = Cursors.Hand
        };
        btn.FlatAppearance.BorderSize = 0;
        return btn;
    }

    void MakeCircle(Panel p)
    {
        var path = new System.Drawing.Drawing2D.GraphicsPath();
        path.AddEllipse(0, 0, p.Width, p.Height);
        p.Region = new Region(path);
    }

    void SetupTrayIcon()
    {
        var menu = new ContextMenuStrip();
        menu.Items.Add("Open Dreamhouse", null, (s, e) => { ShowWindow(); OpenBrowser(); });
        menu.Items.Add("Show Launcher",   null, (s, e) => ShowWindow());
        menu.Items.Add(new ToolStripSeparator());
        menu.Items.Add("Exit",            null, (s, e) => ExitApp());

        _trayIcon = new NotifyIcon {
            Text = APP_NAME + " - Running",
            Icon = new Icon(Path.Combine(Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location), "favicon.ico")),
            ContextMenuStrip = menu,
            Visible = true
        };
        _trayIcon.DoubleClick += (s, e) => ShowWindow();
    }

    void ShowWindow()
    {
        this.Show();
        this.WindowState = FormWindowState.Normal;
        this.BringToFront();
    }

    void StartServer()
    {
        string iisExe = null;
        foreach (var p in IIS_PATHS) if (File.Exists(p)) { iisExe = p; break; }

        if (iisExe == null)
        {
            SetStatus(false, "IIS Express not found!");
            MessageBox.Show(
                "IIS Express is not installed.\n\nDownload from:\nhttps://www.microsoft.com/en-us/download/details.aspx?id=48264",
                "Missing: IIS Express", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }

        // Site path = one level up from Launcher\ folder (the project root)
        string sitePath = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);

        try
        {
            _iisProcess = new Process {
                StartInfo = new ProcessStartInfo {
                    FileName  = iisExe,
                    Arguments = $"/path:\"{sitePath}\" /port:{PORT} /clr:v4.0",
                    UseShellExecute = false, CreateNoWindow = true
                },
                EnableRaisingEvents = true
            };
            _iisProcess.Exited += (s, e) =>
                this.Invoke((Action)(() => SetStatus(false, "Server stopped")));

            _iisProcess.Start();
            SetStatus(true, "Server is running");

            // Auto-open browser after short delay
            System.Threading.Tasks.Task.Delay(1800).ContinueWith(_ =>
                this.Invoke((Action)OpenBrowser));
        }
        catch (Exception ex)
        {
            SetStatus(false, "Error: " + ex.Message);
        }
    }

    void StopServer()
    {
        try { if (_iisProcess != null && !_iisProcess.HasExited) _iisProcess.Kill(); } catch { }
        _iisProcess = null;
        SetStatus(false, "Server stopped");
    }

    void OpenBrowser()
    {
        try { Process.Start(new ProcessStartInfo(LAUNCH_URL) { UseShellExecute = true }); } catch { }
    }

    void SetStatus(bool running, string msg)
    {
        _statusLabel.Text    = msg;
        _statusDot.BackColor = running ? Color.FromArgb(39, 174, 96) : Color.FromArgb(192, 57, 43);
        _btnOpen.Enabled     = running;
        _btnStop.Enabled     = running;
        _trayIcon.Text       = APP_NAME + (running ? " - Running" : " - Stopped");
        MakeCircle(_statusDot);
    }

    void ExitApp()
    {
        StopServer();
        _trayIcon.Visible = false;
        Application.Exit();
    }

    protected override void OnFormClosed(FormClosedEventArgs e) { ExitApp(); base.OnFormClosed(e); }
}
