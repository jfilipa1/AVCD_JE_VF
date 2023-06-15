USE dms_INE_v2;

SELECT tc.NutsID, tc.year, tc.area, tcn.crop_name, r.region_name
FROM temporary_crop tc
JOIN temporary_crop_name tcn ON tc.tc_name_ID = tcn.tc_name_ID
JOIN region r ON tc.NutsID = r.NutsID
WHERE tcn.crop_name <> 'Total' AND r.level_ID = 5;