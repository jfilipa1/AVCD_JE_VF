USE dms_INE_v2;

SELECT pc.NutsID, pc.year, pc.area, pcn.crop_name, r.region_name
FROM permanent_crop pc
JOIN permanent_crop_name pcn ON pc.pc_name_ID = pcn.pc_name_ID
JOIN region r ON pc.NutsID = r.NutsID
WHERE pcn.crop_name <> 'Total' AND r.level_ID = 5;