/*Queries that provide answers to the questions from all projects.*/

/* The following lines contains the logic make to create the different queries. */

/* 1) Find all animals whose name ends in "mon". */
SELECT * from animals WHERE name LIKE '%mon';

/* 2) List the name of all animals born between 2016 and 2019. */
SELECT * from animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';

/* 3) List the name of all animals that are neutered and have less than 
3 escape attempts. */
SELECT * from animals WHERE neutered = TRUE AND escape_attempts < 3;

/* 4) List the date of birth of all animals named either "Agumon" or "Pikachu". */
SELECT date_of_birth from animals WHERE name = 'Agumon' OR name = 'Pikachu';

/* 5) List name and escape attempts of animals that weigh more than 10.5kg. */
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;

/* 6) Find all animals that are neutered. */
SELECT * from animals WHERE neutered = TRUE;

/* 7) Find all animals not named Gabumon. */
SELECT * from animals WHERE name != 'Gabumon';

/* 8) Find all animals with a weight between 10.4kg and 17.3kg 
(including the animals with the weights that equals precisely 10.4kg or 17.3kg) */
SELECT * from animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


/* TRANSACTIONS */

/* 1) Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. 
Then roll back the change and verify that the species columns went back to the state before the transaction. */

BEGIN
UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;
COMMIT;


/* 
 2) Update the animals table by setting the species column to digimon for all animals that have a name ending in mon. 
 3) Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
*/

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

SELECT * FROM animals;
COMMIT;

/* 4) Inside a transaction delete all records in the animals table, then roll back the transaction. */

BEGIN;
DELETE FROM animals;
ROLLBACK;

/* 
  5) Delete all animals born after Jan 1st, 2022. Create a savepoint for the transaction. 
  6) Update all animals' weight to be their weight multiplied by -1. Rollback to the savepoint
  7) Update all animals' weights that are negative to be their weight multiplied by -1. Commit transaction
*/

BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT safe_point;

UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO safe_point;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;


/* How many animals are there? */
SELECT COUNT(*) FROM animals;

/* How many animals have never tried to escape? */
SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

/* What is the average weight of animals? */
SELECT AVG(weight_kg) FROM animals;

/* Who escapes the most, neutered or not neutered animals? */
SELECT CASE
           WHEN neutered = TRUE THEN 'Neutered'
           ELSE 'Not Neutered'
       END AS neutered_status,
       SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered
ORDER BY total_escape_attempts DESC
LIMIT 1;

/* What is the minimum and maximum weight of each type of animal? */
SELECT species,
       MIN(weight_kg) AS min_weight,
       MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT species,
       AVG(escape_attempts) as average_escapes
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01'
GROUP BY species;


/* 1) What animals belong to Melody Pond? */
SELECT owners.full_name as Name, animals.name as Animal
FROM animals
INNER JOIN owners
ON animals.owners_id = owners.id
WHERE owners.id = 4;


/* 2) List of all animals that are pokemon (their type is Pokemon).*/
SELECT species.name as Species, animals.name as Animal
FROM animals
INNER JOIN species
ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

/* 3) List all owners and their animals, remember to include those that don't own any animal. */
SELECT owners.full_name as Owner, animals.name as Animal
FROM animals
FULL JOIN owners
ON animals.owners_id = owners.id;

/* 4) How many animals are there per species? */
SELECT species.name as Specie, COUNT(*) as Quantity
FROM animals
INNER JOIN species
ON animals.species_id = species.id
GROUP BY species.name;

/* 5) List all Digimon owned by Jennifer Orwell. */
SELECT owners.full_name as Owner,species.name as Specie, animals.name as Animal
FROM animals
INNER JOIN owners ON animals.owners_id = owners.id
INNER JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

/* 6) List all animals owned by Dean Winchester that haven't tried to escape. */
SELECT owners.full_name as Owner, animals.name as Animal, animals.escape_attempts as Escapes
FROM animals
INNER JOIN owners ON animals.owners_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

/* 7) Who owns the most animals? */
SELECT owners.full_name as Owner, animal_counts.max_quantity as Quantity
FROM owners
INNER JOIN (
    SELECT owners_id, COUNT(*) as max_quantity
    FROM animals
    GROUP BY owners_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
) as animal_counts
ON owners.id = animal_counts.owners_id;

/* PROJECT PART #4 */

/* 1) Who was the last animal seen by William Tatcher? */
SELECT 
    (SELECT name FROM vets WHERE id = visits.vets_id) as Veterinary, 
    (SELECT name FROM animals WHERE id = visits.animal_id) as Animal
FROM visits
WHERE visits.vets_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
ORDER BY visits.date_of_visit DESC
LIMIT 1;

/* 2) How many different animals did Stephanie Mendez see? */
SELECT 
    (SELECT name FROM vets WHERE id = visits.vets_id) as Veterinary, 
    (SELECT COUNT(DISTINCT animal_id) FROM visits WHERE vets_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')) as Quantity
FROM visits
WHERE visits.vets_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
LIMIT 1;

/* 3) List all vets and their specialties, including vets with no specialties. */
SELECT 
    vets.name as Veterinary, 
    COALESCE(species.name, 'No Specialty') as Specialties
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id
ORDER BY vets.name;

/* 4) List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT
    vets.name as Veterinary,
    animals.name as Animal,
    visits.date_of_visit as Visited
FROM vets
INNER JOIN visits ON vets.id = visits.vets_id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30' AND vets.name = 'Stephanie Mendez';
ORDER BY vets.name;

/* 5) What animal has the most visits to vets? */
SELECT
    animals.name as Animal,
    COUNT(visits.animal_id) as Quantity
FROM animals
INNER JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY Quantity DESC
LIMIT 1;

/* 6) Who was Maisy Smith's first visit? */
SELECT
  vets.name as Veterinary,
  animals.name as Animal,
  visits.date_of_visit as FirstVisit
FROM vets
INNER JOIN visits ON vets.id = visits.vets_id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY FirstVisit
LIMIT 1;

/* 7) Details for most recent visit: animal information, vet information, and date of visit. */
SELECT
  animals.name as Animal,
  vets.name as Veterinary,
  visits.date_of_visit as RecentVisit
FROM animals
INNER JOIN visits ON animals.id = visits.animal_id
INNER JOIN vets ON visits.vets_id = vets.id
ORDER BY RecentVisit DESC
LIMIT 1;

/* 8) How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(*) as VisitsWithoutSpecialization
FROM visits
INNER JOIN vets ON visits.vets_id = vets.id
LEFT JOIN specializations ON vets.id = specializations.vet_id AND visits.animal_id = specializations.species_id
WHERE specializations.vet_id IS NULL;

/* 9) What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT
    species.name as Specialty,
    COUNT(visits.id) as VisitCount
FROM species
INNER JOIN specializations ON species.id = specializations.species_id
INNER JOIN vets ON specializations.vet_id = vets.id
INNER JOIN visits ON vets.id = visits.vets_id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
GROUP BY Specialty
ORDER BY VisitCount DESC
LIMIT 1;

/* Preparation - Week 2 */

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vets_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
INSERT INTO owners (full_name, age, email) SELECT 'Owner ' || generate_series(1, 2500000), generate_series(1, 2500000) + 20, 'owner_' || generate_series(1, 2500000) || '@mail.com';
