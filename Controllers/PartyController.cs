using LocalAccountsv2.Models;
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
        public PartyInformation GetPartyInformation(int id)
        {
            SNAPDataContext db = new SNAPDataContext();


            var partyDbRows = from t in db.SNAP_CL_GetPartyInformation(id)
                    select t;

            var localPartyDbRows = partyDbRows.ToList<SNAP_CL_GetPartyInformationResult>();
            
            var firstRow = localPartyDbRows.FirstOrDefault();
            PartyInformation objPartyInfo = new PartyInformation();

            if (firstRow != null)
            {
                objPartyInfo.PartyName = firstRow.PartyName;
                objPartyInfo.PartyType = firstRow.PartyType;
                objPartyInfo.Address1 = firstRow.Address1;
                objPartyInfo.Address2 = firstRow.Address2;
                objPartyInfo.City = firstRow.City;
                objPartyInfo.State = firstRow.State;
                objPartyInfo.ZipCode = firstRow.ZipCode;
                objPartyInfo.Latitude = Convert.ToDecimal(firstRow.Latitude);
                objPartyInfo.Longitude = Convert.ToDecimal(firstRow.Longitude);
                objPartyInfo.Website = firstRow.website;
                objPartyInfo.Phone = firstRow.Phone;
                objPartyInfo.Fax = firstRow.Fax;
                objPartyInfo.Email = firstRow.Email;
                objPartyInfo.DefaultImageFileName = firstRow.DefaultImageFileName;


                var distinctTemplateNames = localPartyDbRows.Select(x => x.ProfileTemplateName).Distinct();

                foreach (var dtName in distinctTemplateNames)
                {
                    // Get a List of ProfileProperties based on the current ProfileTemplate
                    var PPs = from pp in localPartyDbRows
                              where pp.ProfileTemplateName == dtName
                              select pp;

                    
                    // Build the ProfilePropertyList
                    List<ProfileProperty> tempPropList = new List<ProfileProperty>();
                    foreach (var prop in PPs)
                    {
                        tempPropList.Add(new ProfileProperty(prop.PropertyName, prop.PropertyValue));
                    }

                    // Add the <string, List>
                    objPartyInfo.ProfileProperties.Add(dtName.ToString(), tempPropList);
                }
            }
            //else
            //{
            //    return null;
            //}

            return objPartyInfo;
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