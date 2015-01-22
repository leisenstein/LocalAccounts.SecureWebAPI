﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;

namespace LocalAccountsv2.Models
{
    public class PartyInformation
    {
        public PartyInformation()
        {
            ProfileProperties = new Dictionary<string, List<ProfileProperty>>();
        }
        public string PartyName { get; set; }
        public string PartyType { get; set; }
        
        // ProfilesTemplateName with an Array of ProfileProperties(Name/Value)
        public Dictionary<string, List<ProfileProperty>> ProfileProperties { get; set; }

        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string Website { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public string DefaultImageFileName { get; set; }

    }
}