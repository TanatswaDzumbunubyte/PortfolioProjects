Select *
From PortfolioProject.dbo.NashvilleHousing

--Standardize date format
Select SaleDateConverted
From PortfolioProject.dbo.NashvilleHousing

Select SaleDate, convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

--Add SaleDateConverted column
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted =CONVERT(Date,SaleDate)

--Populating Address Data

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing


Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing A
JOIN PortfolioProject.DBO.NashvilleHousing B
	on a.ParcelID = b.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing A
JOIN PortfolioProject.DBO.NashvilleHousing B
	on a.ParcelID = b.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]



---Breaking out Address Into Individual Columns(Address, City, State)


--Select PropertyAddress
--From PortfolioProject.dbo.NashvilleHousing

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

--Breaking out Address Into Individual Columns(Address, City, State) for owners address' using PARSENAME function

Select *
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)


--Change Y and N to yes or no in "Sold as vacanat" field

select Distinct(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2 



select SoldAsVacant
,case when SoldAsVacant ='Y' THEN 'YES'
	when SoldAsVacant ='N' THEN 'NO'
	ELSE SoldAsVacant
	END
From PortfolioProject.dbo.NashvilleHousing
--update with case function
update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = case when SoldAsVacant ='Y' THEN 'YES'
	when SoldAsVacant ='N' THEN 'NO'
	ELSE SoldAsVacant
	END 
------------------------------------------------------------------------------------------------------------
--Removal of duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY	ParcelID,	
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-------------------------------------------------------------------------------------------------------------------------------------

--Deleting unused columns

Select*
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate