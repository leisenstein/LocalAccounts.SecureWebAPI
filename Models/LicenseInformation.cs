using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LocalAccountsv2.Models
{
    public class LicenseInformation
    {
        public LicenseInformation(string i, string a, string e)
        {
            Issuer = i;
            Abbreviation = a;
            ExternalId = e;
        }
        public string Issuer { get; set; }
        public string Abbreviation { get; set; }
        public string ExternalId { get; set; }
    }
}