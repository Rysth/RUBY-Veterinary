/* Populate database with Animals Data. */

/* 
  Requeriment:
    Animal: His name is Agumon. He was born on Feb 3rd, 2020, and currently weighs 10.23kg. He was neutered and he has never tried to escape.
    Animal: Her name is Gabumon. She was born on Nov 15th, 2018, and currently weighs 8kg. She is neutered and she has tried to escape 2 times.
    Animal: His name is Pikachu. He was born on Jan 7th, 2021, and currently weighs 15.04kg. He was not neutered and he has tried to escape once.
    Animal: Her name is Devimon. She was born on May 12th, 2017, and currently weighs 11kg. She is neutered and she has tried to escape 5 times.
 */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES 
  ('Agumon', '2020-02-03', 0, TRUE ,10.23),
  ('Gabumon', '2018-11-15', 2, TRUE , 8),
  ('Pikachu', '2021-01-07', 1, FALSE , 15.04),
  ('Devimon', '2017-04-12', 5, TRUE , 11);


/* Requeriment: 
  Insert the following data:
    Animal: His name is Charmander. He was born on Feb 8th, 2020, and currently weighs -11kg. He is not neutered and he has never tried to escape.
    Animal: Her name is Plantmon. She was born on Nov 15th, 2021, and currently weighs -5.7kg. She is neutered and she has tried to escape 2 times.
    Animal: His name is Squirtle. He was born on Apr 2nd, 1993, and currently weighs -12.13kg. He was not neutered and he has tried to escape 3 times.
    Animal: His name is Angemon. He was born on Jun 12th, 2005, and currently weighs -45kg. He is neutered and he has tried to escape once.
    Animal: His name is Boarmon. He was born on Jun 7th, 2005, and currently weighs 20.4kg. He is neutered and he has tried to escape 7 times.
    Animal: Her name is Blossom. She was born on Oct 13th, 1998, and currently weighs 17kg. She is neutered and she has tried to escape 3 times.
    Animal: His name is Ditto. He was born on May 14th, 2022, and currently weighs 22kg. He is neutered and he has tried to escape 4 times.
*/


INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES 
  ('Charmander', '2020-02-08', 0, FALSE , -11),
  ('Plantmon', '2021-11-15', 2, TRUE , -5.7),
  ('Squirtle', '1993-04-02', 3, FALSE , -12.13),
  ('Angemon', '2005-06-12', 1, TRUE , -45),
  ('Boarmon', '2005-06-7', 7, TRUE , 20.4),
  ('Blossom', '1998-10-13', 3, TRUE , 17),
  ('Ditto', '2022-05-14', 4, TRUE , 22);


/* 
  Requeriment:
    Sam Smith 34 years old.
    Jennifer Orwell 19 years old.
    Bob 45 years old.
    Melody Pond 77 years old.
    Dean Winchester 14 years old.
    Jodie Whittaker 38 years old.
 */

INSERT INTO owners (full_name, age) VALUES 
  ('Sam Smith', 34),
  ('Jennifer Orwell', 19),
  ('Bob', 45),
  ('Melody Pond', 77),
  ('Dean Winchester', 14),
  ('Jodie Whittaker', 38);
 
INSERT INTO species (name) VALUES 
  ('Pokemon'),
  ('Digimon');

UPDATE animals
SET species_id = CASE
                   WHEN name LIKE '%mon' THEN 2 -- Digimon
                   ELSE 1 -- Pokemon
                 END;

UPDATE animals
SET owners_id = CASE
                 WHEN name = 'Agumon' THEN 1
                 WHEN name IN ('Gabumon', 'Pikachu') THEN 2
                 WHEN name IN ('Devimon', 'Plantmon') THEN 3
                 WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN 4
                 WHEN name IN ('Angemon', 'Boarmon') THEN 5
               END;


