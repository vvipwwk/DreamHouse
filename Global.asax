<%@ Application Language="C#" %>
<%@ Import Namespace="PropertyForRentEdit" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="Microsoft.AspNet.Identity" %>
<%@ Import Namespace="Microsoft.AspNet.Identity.EntityFramework" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        RouteConfig.RegisterRoutes(RouteTable.Routes);
        BundleConfig.RegisterBundles(BundleTable.Bundles);
        SeedRoles();
    }

    void SeedRoles()
    {
        using (var roleManager = ApplicationRoleManager.Create())
        {
            string[] roles = new[] { "Buyer", "Seller" };
            foreach (var role in roles)
            {
                if (!roleManager.RoleExists(role))
                {
                    roleManager.Create(new IdentityRole(role));
                }
            }
        }
    }

</script>
