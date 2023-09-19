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