show databases;

-- selectionar base de dados
use dms_INE_v2;

-- ver tabela que se quer processar
select * from temporary_crop tc 
    inner join temporary_crop_name tcn on tc.tc_name_ID = tcn.tc_name_ID
    inner join region r on tc.NutsID = r.NutsID 
where tc.year = 2019 and tcn.crop_name not like 'Total' and r.level_ID = 5
order by tc.NutsID ;

-- seleccionar colunas
select tc.NutsID, tc.`year`, tc.`area`, tcn.crop_name from temporary_crop tc 
    inner join temporary_crop_name tcn on tc.tc_name_ID = tcn.tc_name_ID
    inner join region r on tc.NutsID = r.NutsID 
where tc.year = 2019 and tcn.crop_name not like 'Total' and r.level_ID = 5
order by tc.NutsID ;

-- apagar tabela se já existir
drop table if exists process_temp_crops;

-- criar tabela temporária para processar
create table dms_ine_v2.process_temp_crops select tc.NutsID, tc.`year`, tc.`area`, tcn.crop_name from temporary_crop tc 
    inner join temporary_crop_name tcn on tc.tc_name_ID = tcn.tc_name_ID
    inner join region r on tc.NutsID = r.NutsID 
where tc.year = 2019 and tcn.crop_name not like 'Total' and r.level_ID = 5
order by tc.NutsID ;

-- ver tabela
select * from process_temp_crops;

-- ver todas as colunas da tabela pivot, a ser usado em CASE
select distinct  crop_name from process_temp_crops;

-- criar tabela pivot (falta acrescentar as outras culturas)
select NutsID, `year`,
        max(CASE WHEN crop_name = 'Cereals' then `area` END) AS `Cereals`,
        max(CASE WHEN crop_name = 'Dried pulses' then `area` END) AS `Dried pulses`,
        max(CASE WHEN crop_name = 'Temporary grasses and grazings' then `area` END) AS `Temporary grasses and grazings`,
        max(CASE WHEN crop_name = 'Fodder plants' then `area` END) AS `Fodder plants`,
        max(CASE WHEN crop_name = 'Potatoes' then `area` END) AS `Potatoes`,
        max(CASE WHEN crop_name = 'Sugarbeets' then `area` END) AS `Sugarbeets`,
        max(CASE WHEN crop_name = 'Industrial crops' then `area` END) AS `Industrial crops`,
        max(CASE WHEN crop_name = 'Fresh vegetables' then `area` END) AS `Fresh vegetables`,
        max(CASE WHEN crop_name = 'Flowers and ornamental plants' then `area` END) AS `Flowers and ornamental plants`,
        max(CASE WHEN crop_name = 'Other temporary crops' then `area` END) AS `Other temporary crops`
FROM process_temp_crops
GROUP BY NutsID;