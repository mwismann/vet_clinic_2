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