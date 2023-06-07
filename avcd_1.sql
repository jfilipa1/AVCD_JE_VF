show databases;

-- selectionar base de dados
use dms_INE_v2;

-- ver tabela que se quer processar
select * from permanent_crop pc 
    inner join permanent_crop_name pcn on pc.pc_name_ID = pcn.pc_name_ID
    inner join region r on pc.NutsID = r.NutsID 
where pc.year = 2019 and pcn.crop_name not like 'Total' and r.level_ID = 5
order by pc.NutsID ;

-- seleccionar colunas
select pc.NutsID, pc.`year`, pc.`hold`, pcn.crop_name from permanent_crop pc 
    inner join permanent_crop_name pcn on pc.pc_name_ID = pcn.pc_name_ID
    inner join region r on pc.NutsID = r.NutsID 
where pc.year = 2019 and pcn.crop_name not like 'Total' and r.level_ID = 5
order by pc.NutsID ;

-- apagar tabela se já existir
drop table if exists process_perm_crops;

-- criar tabela temporária para processar
create table dms_ine_v2.process_perm_crops select pc.NutsID, pc.`year`, pc.`hold`, pcn.crop_name from permanent_crop pc 
    inner join permanent_crop_name pcn on pc.pc_name_ID = pcn.pc_name_ID
    inner join region r on pc.NutsID = r.NutsID 
where pc.year = 2019 and pcn.crop_name not like 'Total' and r.level_ID = 5
order by pc.NutsID ;

-- ver tabela
select * from process_perm_crops;

-- ver todas as colunas da tabela pivot, a ser usado em CASE
select distinct  crop_name from process_perm_crops;

-- criar tabela pivot (falta acrescentar as outras culturas)
select NutsID, `year`,
        max(CASE WHEN crop_name = 'Citrus plantations' then `hold` END) AS `Citrus plantations`,
        max(CASE WHEN crop_name = 'Olive plantations' then `hold` END) AS `Olive plantations`,
        max(CASE WHEN crop_name = 'Fresh fruit plantations (excluding citrus plantations)' then `hold` END) AS `Fresh fruit plantations (excluding citrus plantations)`,
        max(CASE WHEN crop_name = 'Fruit plantations (subtropical climate zones)' then `hold` END) AS `Fruit plantations (subtropical climate zones)`,
        max(CASE WHEN crop_name = 'Nuts plantations' then `hold` END) AS `Nuts plantations`,
        max(CASE WHEN crop_name = 'Vineyards' then `hold` END) AS `Vineyards`,
        max(CASE WHEN crop_name = 'Other permanent crops' then `hold` END) AS `Other permanent crops`
FROM process_perm_crops
GROUP BY NutsID;