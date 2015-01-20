using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace LocalAccountsv2.Controllers
{
    public class PartyController : ApiController
    {
        [HttpGet]
        public SNAP_Party Get(int id)
        {
            SNAPDataContext db = new SNAPDataContext();
            var p = from c in db.SNAP_Parties
                    where c.PartyId == id
                    select c;

            if (p != null)
                return p.First();
            else
                return null;
        }


        [HttpGet]
        [Authorize]
        public IEnumerable<SNAP_GetPartyForProfile_UseDistanceRangeResult> GetUseDistanceRange(string profile, string property, string location, int range, string providername)
        {
            // http://localhost:8080/api/Search/GetUseDistanceRange?profile=medical-equipment&property=&location=30328&range=10&providername=
            SNAPDataContext db = new SNAPDataContext();
            if (property == null)
                property = "";
            if (providername == null)
                providername = "";

            var t = db.SNAP_GetPartyForProfile_UseDistanceRange(profile, property, location, range, providername);
            return t;
        }



        [HttpGet]
        [Authorize(Roles="AF")]
        public IEnumerable<SNAP_GetPartyForProfile_UseDistanceRangeResult> GetUseDistanceRangeAF(string profile, string property, string location, int range, string providername)
        {
            location = "60601";  // change to show different results for testing.
            // http://localhost:8080/api/Search/GetUseDistanceRange?profile=medical-equipment&property=&location=30328&range=10&providername=
            SNAPDataContext db = new SNAPDataContext();
            if (property == null)
                property = "";
            if (providername == null)
                providername = "";

            var t = db.SNAP_GetPartyForProfile_UseDistanceRange(profile, property, location, range, providername);
            return t;
        }



    }
}