/* Updated Scheme v1 */
/* 
    Requeriment:
    Create a table named animals with the following columns:
        id: integer
        name: string
        date_of_birth: date
        escape_attempts: integer
        neutered: boolean
        weight_kg: decimal
 */

CREATE DATABASE vet_clinic;

CREATE TABLE animals (
    id serial primary key,
    name varchar(100) not null,
    date_of_birth date not null,
    escape_attempts integer not null,
    neutered boolean not null,
    weight_kg decimal not null
);


/* Add a column species of type string to your animals table. */

ALTER TABLE animals
ADD COLUMN species VARCHAR(100);


/* CREATE NEW TABLES - (OWNERS & SPECIES) */

CREATE TABLE owners (
    id serial primary key,
    full_name varchar(100) not null,
    age integer not null,
    email varchar(100)
);

CREATE TABLE species (
    id serial primary key,
    name varchar(100) not null
);

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id integer REFERENCES species(id);

ALTER TABLE animals
ADD COLUMN owners_id integer REFERENCES owners(id);



CREATE TABLE vets (
    id serial primary key,
    name varchar(100) not null,
    age integer not null,
    date_of_graduation date not null
);

CREATE TABLE specializations (
    id serial primary key,
    vet_id int REFERENCES vets(id),
    species_id int REFERENCES species(id)
);

CREATE TABLE visits (
    id serial primary key,
    animal_id int REFERENCES animals(id),
    vets_id int REFERENCES vets(id),
    date_of_visit date not null
);

/* Preparation - Week 2 */

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

/* 
    Optimized
    - Created an INDEX for the animals ID help us to optimize A LOT the performance of the query.
 */
CREATE INDEX idx_animal_id ON visits (animal_id);
CREATE INDEX idx_vets_id ON visits (vets_id);
CREATE INDEX idx_email ON owners (email);