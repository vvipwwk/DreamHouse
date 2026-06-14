using System.Web;

namespace PropertyForRentEdit
{
    public static class HelperUtilities
    {
        public static string GetCityImage(object cityObj, object propertyNoObj)
        {
            string propNo = propertyNoObj?.ToString() ?? "";
            if (!string.IsNullOrEmpty(propNo))
            {
                string[] extensions = { "jpg", "jpeg", "png", "gif", "webp" };
                string folder = HttpContext.Current.Server.MapPath("~/Images/Properties/");
                foreach (var ext in extensions)
                {
                    if (System.IO.File.Exists(System.IO.Path.Combine(folder, propNo + "." + ext)))
                        return VirtualPathUtility.ToAbsolute("~/Images/Properties/" + propNo + "." + ext);
                }
            }

            string city = cityObj?.ToString()?.ToLower() ?? "";

            if (city.Contains("glasgow"))
                return "https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("edinburgh"))
                return "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("aberdeen"))
                return "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("dundee"))
                return "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("london"))
                return "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("manchester"))
                return "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("bristol"))
                return "https://images.unsplash.com/photo-1570129477492-45c003edd2be?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("birmingham"))
                return "https://images.unsplash.com/photo-1486325212027-8081e485255e?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("leeds"))
                return "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("liverpool"))
                return "https://images.unsplash.com/photo-1523217582562-09d0def993a6?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("sheffield"))
                return "https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6?auto=format&fit=crop&w=600&q=80";
            if (city.Contains("cambridge") || city.Contains("oxford"))
                return "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=600&q=80";

            return "https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?auto=format&fit=crop&w=600&q=80";
        }

        public static bool IsCurrentUserInRole(string role)
        {
            var ctx = System.Web.HttpContext.Current;
            return ctx != null && ctx.User != null && ctx.User.IsInRole(role);
        }
    }
}
