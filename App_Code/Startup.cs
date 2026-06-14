using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(PropertyForRentEdit.Startup))]
namespace PropertyForRentEdit
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
