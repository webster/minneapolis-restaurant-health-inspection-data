-- Munge business data into a normalized table
INSERT INTO `business`
  ( business_id, name, address, city, state, postal, country )
  SELECT DISTINCT 
    NULL,
    TRIM( `Name of Business` ) AS name,
    TRIM( SUBSTRING( `License Address`, 1, LOCATE( " MINNEAPOLIS, MN", `License Address` ) ) ) AS address,
    "MINNEAPOLIS" AS city,
    "MN" as state,
    RIGHT( `License Address`, 5 ) AS postal,
    "US" as country 
  FROM `InspectionHistory-008`;

CREATE TEMPORARY TABLE `inspection_to_business`
  SELECT InspectionID, business_id
  FROM
    `InspectionHistory-008` i
      LEFT JOIN business b
        ON (
          TRIM( i.`Name of Business` ) = b.name
            AND TRIM( SUBSTRING( `License Address`, 1, LOCATE( " MINNEAPOLIS, MN", `License Address` ) ) ) = b.address
            AND RIGHT( `License Address`, 5 ) = b.postal )
  WHERE business_id IS NOT NULL;

-- Temporarily add a key
ALTER TABLE `InspectionHistory-008` ADD KEY `inspection_id` ( `InspectionID` );

-- Do the migration
INSERT INTO `business_license` ( business_license_id, business_id, license_number )
  SELECT DISTINCT
    NULL AS business_license_id,
    business_id,
    TRIM( `License Number` ) AS license_number
  FROM
    `InspectionHistory-008` i
      JOIN inspection_to_business i2b USING ( InspectionID );

INSERT INTO `code` (code_id, code_section, code_text)
  SELECT NULL, TRIM( `CodeSection` ) AS code_section, TRIM( `StandardOrderText` ) AS code_text
  FROM `InspectionHistory-008` i
  GROUP BY code_section;

INSERT INTO `inspection_order` ( inspection_order_id, inspection_id, license_number, license_code,
  dh_facility_id, kind, purpose, inspected_on, cco, risk_level, code_section,
  is_critical )
  SELECT
    NULL AS inspection_order_id,
    `InspectionID` AS inspection_id,
    TRIM( 'License Number' ) AS license_number,
    IF( `License Code` <> '', SUBSTRING( `License Code`, 2 ), NULL ) AS license_code,
    TRIM( `DH Facility ID` ) AS dh_facility_id,
    TRIM( `Kind of Inspection` ) AS kind,
    TRIM( `Inspection Purpose` ) AS purpose,
    `dateOfInspection` AS inspected_on,
    `CCO` AS cco,
    `Risk Level` AS risk_level,
    `CodeSection` AS code_section,
    IF( `Critical` = "Yes", 1, 0 ) AS is_critical
  FROM `InspectionHistory-008` i;


-- No longer need this key
ALTER TABLE `InspectionHistory-008` DROP KEY `inspection_id`;
