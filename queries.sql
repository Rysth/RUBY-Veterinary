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
