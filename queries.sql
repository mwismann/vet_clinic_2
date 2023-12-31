/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose names ends in "mon".
SELECT name
FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name
FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name
FROM animals
WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth
FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg.
SELECT name, escape_attempts
FROM animals
WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT *
FROM animals
WHERE neutered = true;

-- Find all animas not named Gabumon.
SELECT *
FROM animals
WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT *
FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;


BEGIN; -- Begin transaction
UPDATE animals
SET species = 'unspecified'; -- Make changes

SELECT species FROM animals; -- Check changes
ROLLBACK; -- Undo changes

SELECT species FROM animals; -- Check reverted changes

BEGIN; -- Begin transaction
UPDATE animals
SET species = 'digimon' WHERE name LIKE '%mon'; -- Make changes

SELECT species FROM animals; -- Check changes

UPDATE animals
SET species = 'pokemon' WHERE name NOT LIKE '%mon'; -- Make changes

SELECT species FROM animals; -- Check changes
COMMIT;

SELECT species FROM animals; -- Check committed changes

BEGIN; -- Begin transaction
DELETE FROM animals;
ROLLBACK;

SELECT * FROM animals;

BEGIN; -- Begin transaction
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT * FROM animals;


-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT (escape_attempts) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


-- What animals belong to Melody Pond?
SELECT animals.name
FROM animals INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name
FROM animals INNER JOIN species
ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name
FROM owners LEFT JOIN animals
ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(animals.name)
FROM species LEFT JOIN animals
ON species.id = animals.species_id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, species.name, owners.full_name
FROM animals INNER JOIN owners
ON animals.owner_id = owners.id INNER JOIN species
ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell'
AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, animals.escape_attempts, owners.full_name
FROM animals INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester'
AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name, COUNT(animals.name)
FROM owners LEFT JOIN animals
ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY COUNT(*) DESC
LIMIT 1;


-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name, MAX(visits.date_of_visit)
FROM visits INNER JOIN animals
ON visits.animal_id = animals.id
INNER JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
GROUP BY animals.name, vets.name
ORDER BY MAX(visits.date_of_visit)
DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals.name)
FROM visits INNER JOIN animals
ON visits.animal_id = animals.id
INNER JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name
FROM vets LEFT JOIN specializations
ON vets.id = specializations.vet_id
LEFT JOIN species
ON specializations.species_id = species.id

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, vets.name, visits.date_of_visit
FROM visits INNER JOIN animals
ON visits.animal_id = animals.id
INNER JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.animal_id)
FROM visits INNER JOIN animals
ON visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY COUNT(visits.animal_id)
DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name, vets.name, MIN(visits.date_of_visit)
FROM visits INNER JOIN animals
ON visits.animal_id = animals.id
INNER JOIN vets
ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY animals.name, vets.name
ORDER BY MIN(visits.date_of_visit)
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, vets.name, visits.date_of_visit
FROM visits INNER JOIN animals
ON visits.animal_id = animals.id
INNER JOIN vets
ON visits.vet_id = vets.id
ORDER BY visits.date_of_visit
DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(visits.animal_id)
FROM visits INNER JOIN animals
ON visits.animal_id = animals.id
INNER JOIN vets
ON visits.vet_id = vets.id
INNER JOIN specializations
ON vets.id = specializations.vet_id
WHERE specializations.species_id != animals.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS "specialty", COUNT(visits.id)
FROM (
	SELECT id, name
    FROM vets
    WHERE name = 'Maisy Smith'
) AS filtered_vets
JOIN visits ON visits.vet_id = filtered_vets.id
JOIN animals ON animals.id = visits.animal_id
JOIN species ON species.id = animals.species_id
GROUP BY species.name
ORDER BY COUNT(visits.id)
DESC LIMIT 1;

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits WHERE animal_id = 4;

EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;

EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';