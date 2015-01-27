using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace LocalAccountsv2.Models
{
    [DataContractAttribute(Name="Licenses")]
    public class LicenseInformation
    {
        public LicenseInformation(string i, string a, string e)
        {
            Issuer = i;
            Abbreviation = a;
            ExternalId = e;
        }
        [DataMember(Name = "Issuer")]
        public string Issuer { get; set; }
        [DataMember(Name = "Abbreviation")]
        public string Abbreviation { get; set; }
        [DataMember(Name = "ExternalId")]
        public string ExternalId { get; set; }
    }
}