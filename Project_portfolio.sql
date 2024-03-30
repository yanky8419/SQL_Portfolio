SELECT *
FROM PortfolioProject..Covid_Deaths
WHERE continent is not NULL
ORDER BY 3,4

--Selecting your data

SELECT location, date,total_cases, new_cases, total_deaths, population
FROM PortfolioProject..Covid_Deaths
ORDER BY 1,2

ALTER TABLE Covid_Deaths
ALTER COLUMN total_cases 
int;

ALTER TABLE Covid_Deaths
ALTER COLUMN total_deaths 
float;


/* Comparing total cases VS total death */

SELECT location, date,total_cases , total_deaths , (total_deaths /total_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
ORDER BY 1,2

SELECT location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%Nigeria%'
ORDER BY 1,2

ALTER TABLE Covid_Deaths
ALTER COLUMN total_cases 
int;

ALTER TABLE Covid_Deaths
ALTER COLUMN total_deaths 
float;



/* Comparing total cases VS population */

SELECT location, date,total_cases, population, (total_cases/population)*100 AS POP_Percentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%Nigeria%'
ORDER BY 1,2

-- Coutries with highest infection rate

SELECT location, population, max(total_cases) AS highestinfectioncount, (max(total_cases)/population)*100 AS POP_Percentage
FROM PortfolioProject..Covid_Deaths
GROUP BY location,population
ORDER BY POP_Percentage DESC


-- Coutries with highest death count per population

SELECT location, max(total_deaths) AS TotaldeathCount
FROM PortfolioProject..Covid_Deaths
--WHERE continent is not NULL
GROUP BY location
ORDER BY TotaldeathCount DESC

SELECT location, max(total_deaths) AS TotaldeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent is not NULL
GROUP BY location
ORDER BY TotaldeathCount DESC

-- FILTER DATA BY CONTINENT

SELECT continent, max(total_deaths) AS TotaldeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotaldeathCount DESC


SELECT continent, max(total_deaths) AS TotaldeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent is NULL
GROUP BY continent
ORDER BY TotaldeathCount DESC


SELECT location, max(total_deaths) AS TotaldeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent is NULL
GROUP BY location
ORDER BY TotaldeathCount DESC


-- Get GLObal Figure by Date

SELECT date,SUM(new_cases)AS Tcases,SUM(CAST(new_deaths as int)) AS Tdeaths 
FROM PortfolioProject..Covid_Deaths
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2


SELECT SUM(CASt(new_cases as int)) AS Tcases,SUM(CAST(new_deaths as int)) AS Tdeaths,SUM(CAST(new_deaths as int))/SUM(CASt(new_cases as int))*100 AS PercentnewDeath
FROM PortfolioProject..Covid_Deaths 
WHERE continent is not NULL
--GROUP BY date
ORDER BY 1,2


SELECT SUM(CAST(new_cases as int)) AS Tcases,SUM(CAST(new_deaths as int)) AS Tdeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100  AS PerctDeath
FROM PortfolioProject..Covid_Deaths
WHERE continent is not NULL
ORDER BY 1,2

SELECT *
FROM PortfolioProject..Covid_Vaccinations



SELECT *
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac
     ON Dea.location= Vac.location
	 and Dea.date= Vac.date


--comparing Population VS Vaccination in the two table

ALTER TABLE PortfolioProject..Covid_Vaccinations
ALTER COLUMN people_vaccinated 
bigint;



SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vac.people_vaccinated,
 SUM(cONVERT(int,Vac.people_vaccinated)) OVER(PARTITION BY Dea.location)
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac
     ON Dea.location= Vac.location
	 and Dea.date= Vac.date
WHERE Dea.continent is not null
ORDER BY 1,2,3



SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vac.people_vaccinated,
 SUM(Vac.people_vaccinated) OVER(PARTITION BY Dea.location) AS Tot_Vacnt
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac
     ON Dea.location= Vac.location
	 and Dea.date= Vac.date
WHERE Dea.continent is not null
ORDER BY 1,2,3


SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vac.people_vaccinated,
 SUM(Vac.people_vaccinated) OVER(PARTITION BY Dea.location ORDER BY Dea.date) AS Updated_vacinated,--(Updated_vacinated/population)*100
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac
     ON Dea.location= Vac.location
	 and Dea.date= Vac.date
WHERE Dea.continent is not null
ORDER BY 2,3

-- USE CTE


with POpvsVac  (continent,location,date,population_density,new_vaccination,Updated_vacinated)

AS

(
SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vac.people_vaccinated,
 SUM(Vac.people_vaccinated) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS Updated_vacinated
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac
     ON Dea.location= Vac.location
	 and Dea.date= Vac.date
WHERE Dea.continent is not null
--ORDER BY 1,2,3
)

SELECT *
FROM POpvsVac

SELECT *,(updated_vacinated/population)*100
FROM POpvsVac

-- or substitute the CTE above with TEMP TABLE bellow

DROP TABLE if exists #PercentpplVacinated
CREATE TABLE #PercentpplVacinated

(
continent nvarchar(255),
location  nvarchar(255),
date   datetime,
population  numeric,
people_vaccinated  numeric,
updated_vacinated  numeric
)



INSERT INTO #PercentpplVacinated
SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vac.people_vaccinated,
 SUM(Vac.people_vaccinated) OVER(PARTITION BY Dea.location ORDER BY Dea.date) AS Updated_vacinated
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac
     ON Dea.location= Vac.location
	 and Dea.date= Vac.date
WHERE Dea.continent is not null
--ORDER BY 1,2,3

SELECT *, (updated_vacinated/population)*100 AS Percentpop_VAC
FROM #PercentpplVacinated


-- Creating VIEWS for Data VIsualization

DROP View if exists PercentpplVacinated
Create View PercentpplVacinated as
SELECT Dea.continent,Dea.location,Dea.date,Dea.population,Vac.people_vaccinated,
 SUM(Vac.people_vaccinated) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS Updated_vacinated
FROM PortfolioProject..Covid_Deaths AS Dea
JOIN PortfolioProject..Covid_Vaccinations AS Vac
     ON Dea.location= Vac.location
	 and Dea.date= Vac.date
WHERE Dea.continent is not null
--ORDER BY 1,2,3

SELECT *
FROM  PercentpplVacinated


Create View Continental_Death as
SELECT continent, max(total_deaths) AS TotaldeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent is not NULL
GROUP BY continent
--ORDER BY TotaldeathCount DESC

SELECT *
FROM  Continental_Death