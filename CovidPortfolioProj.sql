-- select data we are going to be using

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject.coviddeaths
order by 1,2;
-- order by location and date

-- looking at Total cases vs total deaths

select location ,date ,total_cases ,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject.coviddeaths
order by 1,2;

-- looking at Total cases vs total deaths where location contains 'Republic'

select location ,date ,total_cases ,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject.coviddeaths
where location like '%Republic%'
order by 1,2;
--  shows likelihood of dying if you contract covid in your country


-- Looking at tota cases vs population
-- shows what percentage of population got covid
select location ,date ,population, total_cases, (total_cases/population)*100 as Casespercentage
from PortfolioProject.coviddeaths
-- where location like '%African%'
order by 1,2;

-- Looking at Countries with Highest infection rate compared to population
 
select location ,population, MAX(total_cases) as HighestInfectionCount , MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject.coviddeaths
group by location,population
order by PercentPopulationInfected desc;

-- Showing countries with highest death count per population

select location,MAX(total_deaths) as TotalDeathCount
from PortfolioProject.coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc;

-- Lets break things down by continent
-- showing continents with highest death count per population
select continent,MAX(total_deaths) as TotalDeathCount
from PortfolioProject.coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- Breaking Global Numbers

select  date, sum(new_cases) as total_cases,sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from PortfolioProject.coviddeaths
where continent is not null
group by date -- means per day
order by 1,2;

-- Total cases 

select sum(new_cases) as total_cases,sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from PortfolioProject.coviddeaths;


-- New table

select * 
from PortfolioProject.covidvaccinations;

-- join both tables on location and date

select * 
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date;

use PortfolioProject;


select * from PercentPopulationVaccinated;


with PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject.coviddeaths as dea
join PortfolioProject.covidvaccinations as vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac;

-- Create Temp Table

Drop Table if exists PercentPopulationVaccinated;

Create Table PercentPopulationVaccinated(
Continent varchar(255),
location varchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations vac 
ON dea.location=vac.location 
and dea.date=vac.date;


Select *,(RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated;
 
-- creating view to store data for later visualisation

Drop Table if exists PercentPopulationVaccinated;
Create View PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject.coviddeaths as dea
join PortfolioProject.covidvaccinations as vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null;

select * 
from PercentPopulationVaccinated;
 