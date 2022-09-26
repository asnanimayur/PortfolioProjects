SELECT * FROM PortfolioProject.housing;

-- Cleaning Data

-- 1) Standarized Date Format

select SaleDate
from PortfolioProject.housing;

select SaleDate,convert(SaleDate,date)
from PortfolioProject.housing;

alter table housing
add SaleDateConverted date;

update housing
set SaleDateConverted = convert(SaleDate,date);

select SaleDateConverted,convert(SaleDate,date)
from PortfolioProject.housing;

-- 2) Populate Property Address

select *
from PortfolioProject.housing
where PropertyAddress ='' ;

-- order by parcel id as its same for address's
select *
from PortfolioProject.housing
order by ParcelID;

-- we join table with itself

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from PortfolioProject.housing a
join PortfolioProject.housing b
on a.ParcelID=b.ParcelID 
and a.UniqueID <> b.UniqueID
where a.PropertyAddress ='';


-- 3) Breaking our address into Individual columns(address, city,state)

select PropertyAddress
from PortfolioProject.housing;

SELECT SUBSTRING(PropertyAddress, 1,LOCATE(',', PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress, LOCATE(',',PropertyAddress)+1 ,length(PropertyAddress)) AS Address
FROM PortfolioProject.housing;


Alter table housing
add PropertyySplitAddress nvarchar(255);

update housing
set PropertyySplitAddress =SUBSTRING(PropertyAddress, 1,locate(',',PropertyAddress)-1);


Alter table housing
add PropertyCityy nvarchar(255);

update housing
set PropertyCityy =SUBSTRING(PropertyAddress, locate(',',PropertyAddress)+1 ,length(PropertyAddress)) ;

select *
from PortfolioProject.housing;


-- change owner address

select OwnerAddress
from PortfolioProject.housing;

select substring(OwnerAddress,1,locate(',',OwnerAddress)-1) as Address,
substring(OwnerAddress,locate(',',OwnerAddress)+1,length(OwnerAddress)) as Address
from PortfolioProject.housing;

Alter table housing
add OwnerSplitAddress nvarchar(255);

update housing
set OwnerSplitAddress =substring(OwnerAddress,1,locate(',',OwnerAddress)-1);


Alter table housing
add OwnerCity nvarchar(255);

update housing
set OwnerCity =substring(OwnerAddress,locate(',',OwnerAddress)+1,length(OwnerAddress));


select *
from PortfolioProject.housing;

-- 4) Convert Y and N to yes and now

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.housing
group by SoldAsVacant
order by 2;

select SoldAsVacant, case when SoldAsVacant='Y' Then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end
from PortfolioProject.housing;

update housing 
set SoldAsVacant = case when SoldAsVacant='Y' Then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end;

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.housing
group by SoldAsVacant
order by 2;

-- 5) Remove Duplicates
with rowNumCte as (
select *,
row_number() over (
partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
order by UniqueId) row__num
from PortfolioProject.housing
)
Delete
from rowNumCte
where row__num >1;


-- 6) Delete unused columns

alter table housing
drop column OwnerAddress;

ALTER TABLE housing
    DROP PropertyAddress,
    DROP TaxDistrict;

alter table housing
drop column SaleDate;
select * from PortfolioProject.housing;
