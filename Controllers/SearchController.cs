using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace LocalAccountsv2.Controllers
{
    public class SearchController : ApiController
    {
        [HttpGet]
        public IEnumerable<SNAP_CL_GetPartyForProfile_UseDistanceRangeResult> GetUseDistanceRange(string profile, string property, string location, int range, string providername)
        {
            // http://localhost:8080/api/Search/GetUseDistanceRange?profile=medical-equipment&property=&location=30328&range=10&providername=
            SNAPDataContext db = new SNAPDataContext();
            if (property == null)
                property = "";
            if (providername == null)
                providername = "";

            var t = db.SNAP_CL_GetPartyForProfile_UseDistanceRange(profile, property, location, range, providername);
            return t;
        }


        


    }
}
