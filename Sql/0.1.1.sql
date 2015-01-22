
CREATE PROCEDURE [dbo].[SNAP_CL_GetPartyByProfileTypeAndLocation]
@vcProfileType varchar(100)
, @vcLocation varchar(100)
, @intRange int

AS

BEGIN 

--NOTE:  Functions by themselves will return records that are greater than the radius desired.  In order to 
--		 return values <= the range, the range will need to be evaluated in the function.

--SET @vcProfileType = 'long-term-senior-housing'
--SET @vcLocation = '30328'
--SET @intRange = 25

--Parameters for a stored proc call.
--SET @vcProfileType = 'medical-equipment'
--SET @vcLocation = 'Dunwoody,GA'
--SET @intRange = 5

--Parameters for a stored proc call.
--SET @vcProfileType = 'diabetes-educator'
--SET @vcLocation = '30512'
--SET @intRange = 25

--Parameters for a stored proc call.
-- SET @vcProfileType = 'home-care'
-- SET @vcLocation = 'Cincinnati,OH'
-- SET @intRange = 15


DECLARE @vcZipForQuery varchar(5)
DECLARE @vcCity varchar(100)
DECLARE @vcState varchar(5)
DECLARE @decZipLong decimal(16,8)
DECLARE @decZipLat decimal(16,8)


--Check demographic info
    IF LEN(@vcLocation) >= 5 AND ISNUMERIC(@vcLocation) = 1
        BEGIN
            SET @vcZipForQuery = LEFT(@vcLocation, 5)
        END
    ELSE
        BEGIN
            SELECT @vcCity = dbo.GetStringElement(1, @vcLocation, ',')
            SELECT @vcState = dbo.GetStringElement(2, @vcLocation, ',')
            
            SELECT @vcZipForQuery = ZipCode FROM SNAP_ZipCodes WHERE City = @vcCity AND [State] = @vcState
            
            IF ISNULL(@vcZipForQuery, '') = ''
                BEGIN
                    SELECT @vcZipForQuery = ZipCode FROM SNAP_ZipCodes WHERE CityAliasName = @vcCity AND [State] = @vcState
                END		
        END
    
    
--Get latitude and longitude for base zip for city	
    SELECT   @decZipLong = Longitude
           , @decZipLat = Latitude 
        FROM SNAP_ZipCodes
        WHERE ZipCode = @vcZipForQuery					


    SELECT 
          vsnp.PartyId
        , vsnp.PartyName
        , vsnp.PartyPhysicalAddress
        , vsnp.PartyPhysicalCity
        , vsnp.PartyPhysicalState
        , vsnp.PartyPhysicalPostalCode
        , vsnp.Latitude
        , vsnp.Longitude
        , dbo.SNAP_GetDistanceEstimate(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, 1) AS Mileage
        , vsnp.PartyPhoneVoice
        , vsnp.PartyPhoneFax
        , vsnp.PartyPhoneMobile
        , vsnp.PartyEmail
        , vsnp.PartyWebsite
        , vsnp.DefaultImageFileName
        , vsnp.PartyPhoneDisplayVoice
        , spr.ProfileTemplateLabel
        , vsfp.FeatureStartDate
    FROM SNAP_PartySummary vsnp 
        JOIN SNAP_Profile spr ON vsnp.PartyID = spr.OwnerPartyID
        JOIN SNAP_ProfileProperty spp ON spr.ProfileID = spp.ProfileID
        LEFT JOIN SNAP_FeaturedParty_Active vsfp ON vsnp.PartyID = vsfp.OwnerPartyID
    WHERE 
        spr.ProfileTemplateLabel = @vcProfileType
        AND	dbo.SNAP_GetDistanceIsInRange(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, @intRange, 1) = 1
        AND	dbo.SNAP_GetDistanceEstimate(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, 1) <= @intRange
    ORDER BY vsfp.FeatureStartDate DESC, Mileage ASC	




END

GO





Create PROCEDURE [dbo].[SNAP_CL_GetPartyByProfileTypeAndLocationAndName]
@ProfileType varchar(100)
, @Location varchar(100)
, @Range int = 5
, @PartyProviderName varchar(100) = ''
AS

BEGIN 

--NOTE:  Functions by themselves will return records that are greater than the radius desired.  In order to 
--		 return values <= the range, the range will need to be evaluated in the function.

--SET @vcProfileType = 'long-term-senior-housing'
--SET @vcLocation = '30328'
--SET @intRange = 25

--Parameters for a stored proc call.
--SET @vcProfileType = 'medical-equipment'
--SET @vcLocation = 'Dunwoody,GA'
--SET @intRange = 5

--Parameters for a stored proc call.
--SET @vcProfileType = 'diabetes-educator'
--SET @vcLocation = '30512'
--SET @intRange = 25

--Parameters for a stored proc call.
-- SET @vcProfileType = 'home-care'
-- SET @vcLocation = 'Cincinnati,OH'
-- SET @intRange = 15


DECLARE @vcZipForQuery varchar(5)
DECLARE @vcCity varchar(100)
DECLARE @vcState varchar(5)
DECLARE @decZipLong decimal(16,8)
DECLARE @decZipLat decimal(16,8)



--Check demographic info
    IF LEN(@Location) >= 5 AND ISNUMERIC(@Location) = 1
        BEGIN
            SET @vcZipForQuery = LEFT(@Location, 5)
        END
    ELSE
        BEGIN
            SELECT @vcCity = dbo.GetStringElement(1, @Location, ',')
            SELECT @vcState = dbo.GetStringElement(2, @Location, ',')
            
            SELECT @vcZipForQuery = ZipCode FROM SNAP_ZipCodes WHERE City = @vcCity AND [State] = @vcState
            
            IF ISNULL(@vcZipForQuery, '') = ''
                BEGIN
                    SELECT @vcZipForQuery = ZipCode FROM SNAP_ZipCodes WHERE CityAliasName = @vcCity AND [State] = @vcState
                END		
        END
    
    
--Get latitude and longitude for base zip for city	
    SELECT   @decZipLong = Longitude
           , @decZipLat = Latitude 
        FROM SNAP_ZipCodes
        WHERE ZipCode = @vcZipForQuery					


    SELECT 
          vsnp.PartyId
        , vsnp.PartyName
        , vsnp.PartyPhysicalAddress
        , vsnp.PartyPhysicalCity
        , vsnp.PartyPhysicalState
        , vsnp.PartyPhysicalPostalCode
        , vsnp.Latitude
        , vsnp.Longitude
        , dbo.SNAP_GetDistanceEstimate(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, 1) AS Mileage
        , vsnp.PartyPhoneVoice
        , vsnp.PartyPhoneFax
        , vsnp.PartyPhoneMobile
        , vsnp.PartyEmail
        , vsnp.PartyWebsite
        , vsnp.DefaultImageFileName
        , vsnp.PartyPhoneDisplayVoice
        , spr.ProfileTemplateLabel
        , vsfp.FeatureStartDate
    FROM SNAP_PartySummary vsnp 
        JOIN SNAP_Profile spr ON vsnp.PartyID = spr.OwnerPartyID
        JOIN SNAP_ProfileProperty spp ON spr.ProfileID = spp.ProfileID
        LEFT JOIN SNAP_FeaturedParty_Active vsfp ON vsnp.PartyID = vsfp.OwnerPartyID
    WHERE 
        spr.ProfileTemplateLabel = @ProfileType
        AND vsnp.PartyName LIKE '%' + @PartyProviderName + '%'
        AND	dbo.SNAP_GetDistanceIsInRange(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, @Range, 1) = 1
        AND	dbo.SNAP_GetDistanceEstimate(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, 1) <= @Range
    ORDER BY vsfp.FeatureStartDate DESC, Mileage ASC	




END

GO





CREATE PROCEDURE [dbo].[SNAP_CL_GetPartyByProfileTypeAndProfilePropertyAndLocationAndName]
@vcProfileType varchar(100),
@vcProfileTypeProperty varchar(100),
@vcLocation varchar(100),
@intRange int,
@vcPartyProviderName varchar(100)

AS

BEGIN 

--NOTE:  Functions by themselves will return records that are greater than the radius desired.  In order to 
--		 return values <= the range, the range will need to be evaluated in the function.

--SET @vcProfileType = 'long-term-senior-housing'
--SET @vcProfileTypeProperty = 'skilled-nursing'
--SET @vcLocation = '30328'
--SET @intRange = 25
--SET @vcPartyProviderName = ''

--Parameters for a stored proc call.
--SET @vcProfileType = 'medical-equipment'
--SET @vcProfileTypeProperty = ''
--SET @vcLocation = 'Dunwoody,GA'
--SET @intRange = 5
--SET @vcPartyProviderName = ''

--Parameters for a stored proc call.
--SET @vcProfileType = 'diabetes-educator'
--SET @vcProfileTypeProperty = ''
--SET @vcLocation = '30512'
--SET @intRange = 25
--SET @vcPartyProviderName = ''

--Parameters for a stored proc call.
-- SET @vcProfileType = 'home-care'
-- SET @vcProfileTypeProperty = ''
-- SET @vcLocation = 'Cincinnati,OH'
-- SET @intRange = 15
-- SET @vcPartyProviderName = ''


    DECLARE @vcZipForQuery varchar(5)
    DECLARE @vcCity varchar(100)
    DECLARE @vcState varchar(5)
    DECLARE @decZipLong decimal(16,8)
    DECLARE @decZipLat decimal(16,8)
    DECLARE @intProviderNameLength int
    
    SET @vcPartyProviderName = ISNULL(@vcPartyProviderName, '')
    
    --Check demographic info
    IF LEN(@vcLocation) >= 5 AND ISNUMERIC(@vcLocation) = 1
        BEGIN
            SET @vcZipForQuery = LEFT(@vcLocation, 5)
        END
    ELSE
        BEGIN
            SELECT @vcCity = dbo.GetStringElement(1, @vcLocation, ',')
            SELECT @vcState = dbo.GetStringElement(2, @vcLocation, ',')
            
            SELECT @vcZipForQuery = ZipCode FROM SNAP_ZipCodes WHERE City = @vcCity AND [State] = @vcState
            
            IF ISNULL(@vcZipForQuery, '') = ''
                BEGIN
                    SELECT @vcZipForQuery = ZipCode FROM SNAP_ZipCodes WHERE CityAliasName = @vcCity AND [State] = @vcState
                END		
        END
        
        
    --Get latitude and longitude for base zip for city	
    SELECT @decZipLong = Longitude, @decZipLat = Latitude 
    FROM SNAP_ZipCodes
    WHERE ZipCode = @vcZipForQuery					
    
    
    
    SELECT 
        vsnp.PartyId,
        vsnp.PartyName,
        vsnp.PartyPhysicalAddress,
        vsnp.PartyPhysicalCity,
        vsnp.PartyPhysicalState,
        vsnp.PartyPhysicalPostalCode,
        vsnp.Latitude,
        vsnp.Longitude,
        dbo.SNAP_GetDistanceEstimate(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, 1) AS Mileage,
        vsnp.PartyPhoneVoice,
        vsnp.PartyPhoneFax,
        vsnp.PartyPhoneMobile,
        vsnp.PartyEmail,
        vsnp.PartyWebsite,
        vsnp.DefaultImageFileName,
        vsnp.PartyPhoneDisplayVoice,
        spr.ProfileTemplateLabel,
        vsfp.FeatureStartDate
    FROM SNAP_PartySummary vsnp 
        JOIN SNAP_Profile spr ON vsnp.PartyID = spr.OwnerPartyID
        JOIN SNAP_ProfileProperty spp ON spr.ProfileID = spp.ProfileID
        LEFT JOIN SNAP_FeaturedParty_Active vsfp ON vsnp.PartyID = vsfp.OwnerPartyID
    WHERE
        spr.ProfileTemplateLabel = @vcProfileType
        AND spp.PropertyValue = @vcProfileTypeProperty
        AND dbo.SNAP_GetDistanceIsInRange(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, @intRange, 1) = 1
        AND dbo.SNAP_GetDistanceEstimate(@decZipLong, @decZipLat, vsnp.Longitude, vsnp.Latitude, 1) <= @intRange
        AND vsnp.PartyName LIKE '%' + @vcPartyProviderName + '%'
    ORDER BY
        vsfp.FeatureStartDate DESC, Mileage ASC	




END

GO









CREATE PROCEDURE [dbo].[SNAP_CL_GetPartyInformation]
 @partyId int

AS

BEGIN 

    
    SELECT 
          -- p.[PartyId] ,
           p.[Name] [PartyName]
          ,p.[PartyTypeLabel] [PartyType]
          -- ,pr.ProfileId
          ,pr.ProfileTemplateLabel [ProfileTemplateName]
          ,pp.PropertyName 
          ,pp.PropertyValue
    	  , a.Address [Address1]
    	  , a.ApartmentOrSuite [Address2]
    	  , a.City
    	  , a.State [State]
    	  , a.PostalCode [ZipCode]
    	  , a.Latitude
    	  , a.Longitude 
    	  , w.URL [website]
    	  , ph.PhoneNumber [Phone]
    	  , pf.PhoneNumber [Fax]
    	  , e.EmailAddress [Email]
    	  , g.DefaultImageFileName [DefaultImageFileName]
      FROM [SNAP_Party] p
           LEFT JOIN SNAP_Profile pr ON pr.OwnerPartyId = p.PartyId
           LEFT JOIN SNAP_ProfileProperty pp ON pp.ProfileId = pr.ProfileId
    	   LEFT JOIN SNAP_Address a ON a.PartyId = p.PartyId AND a.Purpose = 'Physical Address' AND a.IsPreferred = 1
    	   LEFT JOIN SNAP_Website w ON w.PartyId = p.PartyId AND w.IsPreferred = 1
    	   LEFT JOIN SNAP_PhoneNumber ph ON ph.PartyId = p.PartyId AND ph.Purpose = 'Phone' AND ph.IsPreferred = 1
    	   LEFT JOIN SNAP_PhoneNumber pf ON pf.PartyId = p.PartyId AND pf.Purpose = 'Fax' AND ph.IsPreferred = 1
    	   LEFT JOIN SNAP_EmailAddress e ON p.PartyId = e.PartyId AND e.Purpose = 'general'	AND e.IsPreferred = 1
    	   LEFT JOIN SNAP_PartyGallery g ON	p.PartyId = g.PartyId
      WHERE 1=1 
            AND p.PartyId = @partyId
            AND [dbo].[SNAP_IsActive](p.EffectiveDate, p.UntilDate, GETDATE()) = 1
    
END


