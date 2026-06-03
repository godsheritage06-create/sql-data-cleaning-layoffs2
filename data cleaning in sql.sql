-- Data cleaing project of total laid off 2019 to 2022
select*
from layoffss;


-- create a working table from actual table

create table layoffs_2
select*
from layoffss;

select *
from layoffs_2;

-- check for duplicates

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company,
                         location,
                         total_laid_off,
                         `date`,
                         percentage_laid_off,
                         industry,
                         `source`,
                         stage,
                         funds_raised,
                         country,
                         date_added
            ORDER BY company
        ) AS row_num
    FROM layoffs_2
)
SELECT *
FROM RowNumCTE
where row_num >1;
-- no duplicates


-- standardizing data
select distinct company
from layoffs_2
order by 1;

update layoffs_2
set  company = 'paid'
where company like '#%';

update layoffs_2
set company = 'open'
where company like '&%';

update layoffs_2
set company = trim(company);

select distinct industry 
from layoffs_2
order by 1;

select distinct country
from layoffs_2
order by 1;

select *
from layoffs_2
where (total_laid_off = '' or total_laid_off is null) and  (percentage_laid_off = '' or percentage_laid_off is null);

-- Removing rows where both layoff metrics are null, as they provide no analytical value for this specific study

delete 
from layoffs_2
where total_laid_off = ''  and  percentage_laid_off = ''
 ;
 
 select *
 from layoffs_2
 where total_laid_off = '' or percentage_laid_off = '';
 
 -- changing rows where total laid off or percentage laid off or funds raised has no numerical value to null
update layoffs_2
set total_laid_off = null
where total_laid_off = '' ;

update layoffs_2
set percentage_laid_off = null
where percentage_laid_off = '';

update layoffs_2
set funds_raised= null
where funds_raised = '';

select distinct stage
from layoffs_2
order by 1;

update layoffs_2
set stage = 'unknown'
where stage ='';

-- changed null values to N/A 
update layoffs_2
set total_laid_off = 'N/A'
where total_laid_off is null;

update layoffs_2
set percentage_laid_off = 'N/A'
where percentage_laid_off is null;

update layoffs_2
set funds_raised = 'N/A'
where funds_raised is null;

-- final cleaned dataset
select*
from layoffs_2
