/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
	id INT NOT NULL,
	name VARCHAR(20),
	date_of_birth DATE NOT NULL,
	escape_attempts INT NOT NULL,
	neutered BOOL NOT NULL,
	weight_kg DEC(4,2) NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE animals ADD species VARCHAR(20);

-- Create a table called owners with the following columns:
CREATE TABLE owners (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	full_name VARCHAR(200) NOT NULL,
	age INT NOT NULL 
);

-- Create a table called species with the following columns:
CREATE TABLE species (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(200) NOT NULL
);

-- Modify animals table as follows: Set id as auto incremented primary key.
ALTER TABLE animals
ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;


-- Modify animals table as follows: Remove the species column.
ALTER TABLE animals
DROP COLUMN species;

-- Modify animals table as follows: Add a column called species_id which references the id column of the species table.
ALTER TABLE animals
ADD COLUMN species_id INT REFERENCES species(id);

-- Modify animals table as follows: Add a column called owner_id which references the id column of the owners table.
ALTER TABLE animals
ADD COLUMN owner_id INT REFERENCES owners(id);

-- Create a table named vets with the following columns:
CREATE TABLE vets (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(200) NOT NULL,
	age INT NOT NULL,
	date_of_graduation DATE NOT NULL
)

-- Create a join table called specializations:
CREATE TABLE specializations (
	id INT GENERATED ALWAYS AS IDENTITY,
	vet_id INT REFERENCES vets(id),
	species_id INT REFERENCES species(id)
)

-- Create a join table called visits:
CREATE TABLE visits (
  id INT GENERATED ALWAYS AS IDENTITY,
  animal_id INT REFERENCES animals(id),
  vet_id INT REFERENCES vets(id),
  date_of_visit DATE NOT NULL
)

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

CREATE INDEX ix_visit_animal ON visits (animal_id);

CREATE INDEX ix_visits ON visits (vet_id, id, animal_id, date_of_visit);

CREATE INDEX ix_visits ON visits (vet_id, id, animal_id, date_of_visit);