using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace LocalAccountsv2.Models
{
    [DataContractAttribute(Name="ProfileProperties")]
    public class ProfileProperty
    {
        public ProfileProperty(string n, string v)
        {
            PropertyName = n;
            PropertyValue = v;
        }
        [DataMember(Name="PropertyName")]
        public string PropertyName { get; set; }
        [DataMember(Name = "PropertyValue")]
        public string PropertyValue { get; set; }
    }
}