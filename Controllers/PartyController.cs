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






    }
}