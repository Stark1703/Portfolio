/*

Cleaning Data in SQL Queries

*/


Select *
From dbo.[Nashville_Housing_data]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate)
From dbo.[Nashville_Housing_data]


Update dbo.[Nashville_Housing_data]
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE dbo.[Nashville_Housing_data]
Add SaleDateConverted Date;

Update dbo.[Nashville_Housing_data]
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From dbo.[Nashville_Housing_data]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.[Nashville_Housing_data] a
JOIN dbo.[Nashville_Housing_data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.[Nashville_Housing_data] a
JOIN dbo.[Nashville_Housing_data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From dbo.[Nashville_Housing_data]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From dbo.[Nashville_Housing_data]


ALTER TABLE dbo.[Nashville_Housing_data]
Add PropertySplitAddress Nvarchar(255);

Update dbo.[Nashville_Housing_data]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE dbo.[Nashville_Housing_data]
Add PropertySplitCity Nvarchar(255);

Update dbo.[Nashville_Housing_data]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From dbo.[Nashville_Housing_data]





Select OwnerAddress
From dbo.[Nashville_Housing_data]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dbo.[Nashville_Housing_data]



ALTER TABLE dbo.[Nashville_Housing_data]
Add OwnerSplitAddress Nvarchar(255);

Update dbo.[Nashville_Housing_data]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE dbo.[Nashville_Housing_data]
Add OwnerSplitCity Nvarchar(255);

Update dbo.[Nashville_Housing_data]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE dbo.[Nashville_Housing_data]
Add OwnerSplitState Nvarchar(255);

Update dbo.[Nashville_Housing_data]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From dbo.[Nashville_Housing_data]




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.[Nashville_Housing_data]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.[Nashville_Housing_data]


Update dbo.[Nashville_Housing_data]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From dbo.[Nashville_Housing_data]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From dbo.[Nashville_Housing_data]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From dbo.[Nashville_Housing_data]


ALTER TABLE dbo.[Nashville_Housing_data]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





























