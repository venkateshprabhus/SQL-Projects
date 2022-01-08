--------ANALYSIS ON DEATH DUE TO COVID--------

Select * From PortfolioProjects..CovidDeaths
Where continent is not null
Order by 3,4

------LOCATION WISE ANALYSIS------
--Total cases vs Total Deaths
Select location,date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage From PortfolioProjects..CovidDeaths
--Where location  in ('India','Unites States')
Where continent is not null
Order by 1,2

--Total cases vs Population
Select location,date, population, new_cases, total_cases, (total_cases/population)*100 as CovidPercentage From PortfolioProjects..CovidDeaths
--Where location  in ('India','Unites States')
Where continent is not null
Order by 1,2

--Looking at the Countries with Highest Infection Rate compared to Population
Select location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population)*100 )as CovidPercentage From PortfolioProjects..CovidDeaths
--Where location  in ('India','Unites States')
Where continent is not null
group by location, population
Order by 4 desc

--Countries with Highest Death Count
Select location, population, MAX(cast(total_deaths as int)) as Total_Death_Count, MAX((total_deaths/population)*100) as Death_Percentage From PortfolioProjects..CovidDeaths
--Where location  in ('India','Unites States')
Where continent is not null
group by location, population
Order by 3 desc

--------CONTINENT WISE ANALYSIS--------
--Continent with Highest Death Count
Select location, MAX(cast(total_deaths as int)) as Total_Death_Count, MAX((total_deaths/population)*100) as Death_Percentage From PortfolioProjects..CovidDeaths
--Where location  in ('India','Unites States')
Where continent is null and location in ('Europe', 'Asia', 'North America', 'South America', 'Africa', 'World', 'European Union', 'Oceania')
group by location
Order by 2 desc

------GLOBAL NUMBERS----
--Total death due to covid all around the globe
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
where continent is not null 
order by 1,2
-------ANALYSIS ON COVID VACCINATION-------

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as totalPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as TotalPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 