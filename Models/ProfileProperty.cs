using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LocalAccountsv2.Models
{
    public class ProfileProperty
    {
        public ProfileProperty(string n, string v)
        {
            PropertyName = n;
            PropertyValue = v;
        }
        public string PropertyName { get; set; }
        public string PropertyValue { get; set; }
    }
}