-- ============================================================
--  GriPlanner – Planner Zilnic de Activitate
-- ============================================================

DROP DATABASE IF EXISTS griplanner;

CREATE DATABASE IF NOT EXISTS griplanner
CHARACTER SET utf8mb4
COLLATE utf8mb4_romanian_ci;

USE griplanner;

-- ============================================================
-- TABEL: utilizatori
-- ============================================================

CREATE TABLE utilizatori (
    id_utilizator INT NOT NULL AUTO_INCREMENT,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefon VARCHAR(20),
    parola_hash VARCHAR(255) NOT NULL,
    data_inregistrare DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activ TINYINT(1) NOT NULL DEFAULT 1,

    PRIMARY KEY (id_utilizator)
);

-- ============================================================
-- TABEL: categorii
-- ============================================================

CREATE TABLE categorii (
    id_categorie INT NOT NULL AUTO_INCREMENT,
    id_utilizator INT NOT NULL,
    nume_categorie VARCHAR(100) NOT NULL,
    culoare VARCHAR(7) NOT NULL DEFAULT '#E66414',

    PRIMARY KEY (id_categorie),

    CONSTRAINT fk_categorii_utilizator
        FOREIGN KEY (id_utilizator)
        REFERENCES utilizatori(id_utilizator)
        ON DELETE CASCADE
);

-- ============================================================
-- TABEL: activitati
-- ============================================================

CREATE TABLE activitati (
    id_activitate INT NOT NULL AUTO_INCREMENT,
    id_utilizator INT NOT NULL,
    id_categorie INT NULL,

    titlu VARCHAR(200) NOT NULL,
    descriere TEXT,

    data_activitate DATE NOT NULL,
    ora_inceput TIME,
    ora_sfarsit TIME,

    prioritate ENUM('scazuta','medie','ridicata')
        NOT NULL DEFAULT 'medie',

    status ENUM('neinceputa','in_progres','finalizata','anulata')
        NOT NULL DEFAULT 'neinceputa',

    data_creare DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    data_modificare DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id_activitate),

    CONSTRAINT fk_activitati_utilizator
        FOREIGN KEY (id_utilizator)
        REFERENCES utilizatori(id_utilizator)
        ON DELETE CASCADE,

    CONSTRAINT fk_activitati_categorie
        FOREIGN KEY (id_categorie)
        REFERENCES categorii(id_categorie)
        ON DELETE SET NULL
);

-- ============================================================
-- TABEL: notite
-- ============================================================

CREATE TABLE notite (
    id_notita INT NOT NULL AUTO_INCREMENT,
    id_utilizator INT NOT NULL,

    titlu VARCHAR(200),
    continut TEXT NOT NULL,

    data_notita DATE NOT NULL,
    data_creare DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_notita),

    CONSTRAINT fk_notite_utilizator
        FOREIGN KEY (id_utilizator)
        REFERENCES utilizatori(id_utilizator)
        ON DELETE CASCADE
);

-- ============================================================
-- TABEL: obiective
-- ============================================================

CREATE TABLE obiective (
    id_obiectiv INT NOT NULL AUTO_INCREMENT,
    id_utilizator INT NOT NULL,

    titlu VARCHAR(200) NOT NULL,
    descriere TEXT,

    data_tinta DATE,

    progres TINYINT NOT NULL DEFAULT 0,

    status ENUM('activ','finalizat','abandonat')
        NOT NULL DEFAULT 'activ',

    data_creare DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_obiectiv),

    CONSTRAINT fk_obiective_utilizator
        FOREIGN KEY (id_utilizator)
        REFERENCES utilizatori(id_utilizator)
        ON DELETE CASCADE
);

-- ============================================================
-- TABEL: activitati_obiective
-- ============================================================

CREATE TABLE activitati_obiective (
    id_activitate INT NOT NULL,
    id_obiectiv INT NOT NULL,

    PRIMARY KEY (id_activitate, id_obiectiv),

    CONSTRAINT fk_ao_activitate
        FOREIGN KEY (id_activitate)
        REFERENCES activitati(id_activitate)
        ON DELETE CASCADE,

    CONSTRAINT fk_ao_obiectiv
        FOREIGN KEY (id_obiectiv)
        REFERENCES obiective(id_obiectiv)
        ON DELETE CASCADE
);

-- ============================================================
-- TABEL: remindere
-- ============================================================

CREATE TABLE remindere (
    id_reminder INT NOT NULL AUTO_INCREMENT,
    id_activitate INT NOT NULL,

    data_reminder DATETIME NOT NULL,
    mesaj VARCHAR(255),

    trimis TINYINT(1) NOT NULL DEFAULT 0,

    PRIMARY KEY (id_reminder),

    CONSTRAINT fk_remindere_activitate
        FOREIGN KEY (id_activitate)
        REFERENCES activitati(id_activitate)
        ON DELETE CASCADE
);

-- ============================================================
-- INSERT UTILIZATORI
-- ============================================================

INSERT INTO utilizatori
(nume, prenume, email, telefon, parola_hash)
VALUES
('Popescu', 'Andrei', 'andrei.popescu@email.com', '0712345678', SHA2('parola123',256)),
('Ionescu', 'Maria', 'maria.ionescu@email.com', '0723456789', SHA2('parola456',256)),
('Gabi', 'Test', 'gabi@griplanner.com', NULL, SHA2('admin123',256));

-- ============================================================
-- INSERT CATEGORII
-- ============================================================

INSERT INTO categorii
(id_utilizator, nume_categorie, culoare)
VALUES
(1, 'Munca', '#E66414'),
(1, 'Sport', '#2ECC71'),
(1, 'Personal', '#3498DB'),
(2, 'Studiu', '#9B59B6'),
(2, 'Familie', '#E74C3C');

-- ============================================================
-- INSERT ACTIVITATI
-- ============================================================

INSERT INTO activitati
(
    id_utilizator,
    id_categorie,
    titlu,
    descriere,
    data_activitate,
    ora_inceput,
    ora_sfarsit,
    prioritate,
    status
)
VALUES
(1,1,'Meeting saptamanal','Discutie cu echipa despre proiect','2026-05-07','09:00:00','10:00:00','ridicata','finalizata'),

(1,2,'Alergare in parc','5 km dimineata','2026-05-07','07:00:00','07:45:00','medie','finalizata'),

(1,3,'Cumparat alimente',NULL,'2026-05-07','18:00:00','19:00:00','scazuta','neinceputa'),

(1,1,'Raport lunar','Pregatire raport pentru manager','2026-05-08','14:00:00','16:00:00','ridicata','neinceputa'),

(2,4,'Invatat baza de date','MySQL – relatii intre tabele','2026-05-07','10:00:00','12:00:00','ridicata','in_progres'),

(2,5,'Iesire cu familia','Parc si restaurant','2026-05-09','12:00:00','20:00:00','medie','neinceputa');

-- ============================================================
-- INSERT NOTITE
-- ============================================================

INSERT INTO notite
(id_utilizator, titlu, continut, data_notita)
VALUES
(1,'Idei proiect','Sa implementez functia de export PDF pentru planner.','2026-05-07'),

(1,NULL,'Nu uita sa cumperi cadoul pentru ziua de nastere.','2026-05-07'),

(2,'Rezumat curs','Cheile straine asigura integritatea referentiala.','2026-05-07');

-- ============================================================
-- INSERT OBIECTIVE
-- ============================================================

INSERT INTO obiective
(id_utilizator, titlu, descriere, data_tinta, progres, status)
VALUES
(1,'Finalizare proiect GriPlanner','Aplicatie completa cu baza de date','2026-06-30',40,'activ'),

(1,'Alergare 10 km','Antrenament zilnic 30 min','2026-07-01',20,'activ'),

(2,'Promovare examen BD','Nota minima 9','2026-06-15',60,'activ');

-- ============================================================
-- INSERT ACTIVITATI_OBIECTIVE
-- ============================================================

INSERT INTO activitati_obiective
(id_activitate, id_obiectiv)
VALUES
(1,1),
(4,1),
(2,2),
(5,3);

-- ============================================================
-- INSERT REMINDERE
-- ============================================================

INSERT INTO remindere
(id_activitate, data_reminder, mesaj)
VALUES
(4,'2026-05-08 13:30:00','Pregateste-te pentru raportul lunar!'),

(6,'2026-05-09 11:00:00','Iesire cu familia – nu uita rezervarea!');

-- ============================================================
-- QUERY TEST
-- ============================================================

SELECT * FROM utilizatori;
SELECT * FROM categorii;
SELECT * FROM activitati;
SELECT * FROM notite;
SELECT * FROM obiective;
SELECT * FROM remindere;