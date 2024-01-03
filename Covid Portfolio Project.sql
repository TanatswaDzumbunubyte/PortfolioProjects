Select *
From PortfolioProject.dbo.CovidDeaths
order by 3,4

--Select *
--From PortfolioProject.dbo.CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases,total_deaths, population
From PortfolioProject.dbo.CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Showing likelyhood of dying if you contract covid
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where location like '%Zimbabwe'
order by 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid
Select Location, date,population, total_cases, (total_cases/population)*100 as Percentage
From PortfolioProject.dbo.CovidDeaths
Where location like '%Zimbabwe'
order by 1,2


--Looking at countries with highest infection rate 
Select Location, population, MAX(total_cases) as HighestInfectionCount, max ((total_cases/population))*100 as Percentageofpopulationinfected
From PortfolioProject.dbo.CovidDeaths
group by Location, population
order by Percentageofpopulationinfected desc

--Looking at countries with the highest death count per population
Select Location, MAX(cast(total_deaths as int)) as DeathCount
From PortfolioProject.dbo.CovidDeaths
where continent is not null
group by Location
order by DeathCount desc

--Looking at continents with the highest death count per population
Select continent, MAX(cast(total_deaths as int)) as DeathCount
From PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by DeathCount desc

--Looking at continents with the highest death count per population even (nulll ones)
Select location, MAX(cast(total_deaths as int)) as DeathCount
From PortfolioProject.dbo.CovidDeaths
where continent is null
group by location
order by DeathCount desc

--Looking at continents with the highest death count per population
Select continent, MAX(cast(total_deaths as int)) as DeathCount
From PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by DeathCount desc

--Global numbers as per date
Select date,sum(new_cases) as total_cases,  sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100  Percentage
From PortfolioProject.dbo.CovidDeaths
--Where location like '%Zimbabwe'
where continent is not null
group by date
order by 1,2

--Global numbers overrall
Select sum(new_cases) as total_cases,  sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100  Percentage
From PortfolioProject.dbo.CovidDeaths
--Where location like '%Zimbabwe'
where continent is not null
order by 1,2


--Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as int)) over(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent  is not null
order by 2,3

--Looking at total population vs vaccinations USING CTE
With PopvsVac (Continent,Location, Date,Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as int)) over(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent  is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac


--Creating view for data visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as int)) over(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent  is not null

--Testing view PercentPopulationVaccinated
Select *
FROM PercentPopulationVaccinated
