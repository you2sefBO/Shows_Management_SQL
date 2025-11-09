CREATE TABLE Client (
    idClt INTEGER PRIMARY KEY,        
    nomClt VARCHAR2(30) NOT NULL,     
    prenomClt VARCHAR2(30) NOT NULL,  
    tel VARCHAR2(15) NOT NULL,       
    email VARCHAR2(50) NOT NULL,     
    motP VARCHAR2(100) NOT NULL       
);

CREATE TABLE Lieu (
    idLieu INTEGER PRIMARY KEY,
    NomLieu VARCHAR2(30) NOT NULL,
    Adresse VARCHAR2(100) NOT NULL,
    capacite NUMBER NOT NULL
);

CREATE TABLE Artiste (
    idArt INTEGER PRIMARY KEY,
    NomArt VARCHAR2(30) NOT NULL,
    PrenomArt VARCHAR2(30) NOT NULL,
    specialite VARCHAR2(10) NOT NULL
);

CREATE TABLE SPECTACLE (
    idSpec INTEGER PRIMARY KEY,
    Titre VARCHAR2(20) NOT NULL,
    dateS DATE NOT NULL,
    h_debut NUMBER(4,2) NOT NULL,
    dureeS NUMBER(4,2) NOT NULL,
    nbrSpectateur INTEGER NOT NULL,
    idLieu INTEGER,
    
    CONSTRAINT chk_spect_durees CHECK (dureeS BETWEEN 1 AND 4),
    CONSTRAINT FK_spect_Lieux FOREIGN KEY(idLieu) REFERENCES Lieu(idLieu)
);

CREATE TABLE Rubrique (
    idRub INTEGER PRIMARY KEY,
    idSpec INTEGER NOT NULL,
    idArt INTEGER NOT NULL,
    H_debutR NUMBER(4,2) NOT NULL,
    dureeRub NUMBER(4,2) NOT NULL,
    type VARCHAR2(10),
    
    CONSTRAINT fk_rub_spect FOREIGN KEY(idSpec) REFERENCES SPECTACLE(idSpec) ON DELETE CASCADE,
    CONSTRAINT fk_rub_art FOREIGN KEY(idArt) REFERENCES Artiste(idArt) ON DELETE CASCADE
);

CREATE TABLE BILLET (
    idBillet INTEGER PRIMARY KEY,
    categorie VARCHAR2(10),
    prix NUMBER(5,2) NOT NULL,
    idSpec INTEGER NOT NULL,
    Vendu VARCHAR(3) NOT NULL,
    
    CONSTRAINT chk_billet_PRIX CHECK (prix BETWEEN 10 AND 300),
    CONSTRAINT fk_billet_spec FOREIGN KEY (idSpec) REFERENCES SPECTACLE(idSpec),
    CONSTRAINT chk_billet_vendu CHECK (vendu IN ('Oui', 'Non'))
);

CREATE SEQUENCE Seq_lieu 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE Seq_client 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE Seq_billet 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE Seq_spectacle 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE Seq_rubrique 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'CABARET RESTAURANT SHEHERAZADE', 'Médina Mediterranea - Yasmine-Hammamet - Tunisie', 100);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'TH  TRE EL HAMRA', '28,rue El Jazira - Tunis - Tunisie', 550);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'Th  tre Municipal de Tunis', 'Avenue Bourguiba - Tunis - Tunisie', 1145);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'CIN MA TUNISIA ODYSSE', 'Medina Mediterranea - Yasmine-Hammamet - Tunisie', 1368);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'L ETOILE DU NORD', '41,avenue Farhat-Hached - Tunis - Tunisie', 1080);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'Path Tunis City', 'Cebalet ben ammar, route de bizerte km 17 Ariana, Tunis 2032, Tunisie', 1183);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'CENTRE DOUAR EL HASFI', 'Route du Zoo-Paradis - 2200 - Tozeur - Tunisie', 713);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'EL MAWEL', '5, rue Amine-Abbassi - Tunis - Tunisie', 1276);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'EL TEATRO', 'Avenue Ouled Haffouz - Tunis - Tunisie', 1440);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'ZINEBLEDI', 'route de tunis km12 - 4000 - Sousse - Tunisie', 1333);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'Le Colise', 'Avenue Habib Bourguiba, Tunis, Tunisie', 813);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'Cine Jamil', 'Rue du docteur Mohamed Ben Salah, Ariana, Tunisie', 1479);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'L agora', 'Rue 1 La marsa', 996);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'Alhambra  z phyr ', 'Centre Commercial Z phyr La Marsa', 915);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'Cin Madart', 'Rue Hbib Bourguiba - Monoprix Dermech, Tunisie', 1106);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite) VALUES (Seq_lieu.NEXTVAL, 'theatre opera', 'CITE DE LA CULTURE A TUNIS', 1800);


CREATE INDEX idx_spectacle ON SPECTACLE(idLieu);
CREATE INDEX idx_billet ON BILLET(idSpec);
CREATE INDEX idx_rubrique ON Rubrique(idSpec, idArt);

CREATE OR REPLACE TRIGGER trg_verif_client
BEFORE INSERT OR UPDATE ON Client
FOR EACH ROW
BEGIN 
    IF NOT (:NEW.email LIKE '%@%' AND :NEW.email LIKE '%.%') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Format de l''email invalide.');
    END IF;
    IF LENGTH(:NEW.tel) != 8 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Numéro de téléphone invalide. Veuillez vérifier qu''il contient uniquement 8 chiffres.');
    END IF;
END;
/
INSERT INTO Client (idClt, nomClt, prenomClt, tel, email, motP)
VALUES (Seq_client.NEXTVAL, 'Samir', 'Jbali', '87654321', 'jane.smith/example.com', 'password123');

INSERT INTO Client (idClt, nomClt, prenomClt, tel, email, motP)
VALUES (Seq_client.NEXTVAL, 'Basma', 'Chaouch', 'abcdef1', 'charlie.brown@example.com', 'password123');


CREATE OR REPLACE TRIGGER trg_verif_capacite
BEFORE INSERT OR UPDATE ON Lieu
FOR EACH ROW
BEGIN
    IF (:NEW.capacite < 100 OR :NEW.capacite > 2000) THEN
        RAISE_APPLICATION_ERROR(-20003, 'La capacité doit être comprise entre 100 et 2000.');
    END IF;
END;
/
/*INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite)
VALUES (2, 'Petit Cinéma', 'Rue Exemple, Tunis', 50);
INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite)
VALUES (3, 'Grande Salle', 'Rue Exemple, Tunis', 2500);*/

CREATE OR REPLACE TRIGGER trg_verif_artiste
BEFORE INSERT OR UPDATE ON Artiste
FOR EACH ROW
BEGIN
    IF (:NEW.specialite NOT IN ('danseur', 'acteur', 'musicien', 'magicien', 'imitateur', 'humoriste', 'chanteur')) THEN
        RAISE_APPLICATION_ERROR(-20004, 'La spécialité de l''artiste doit être l''une des suivantes : danseur, acteur, musicien, magicien, imitateur, humoriste, chanteur.');
    END IF;

    IF LENGTH(:NEW.NomArt) = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Le nom de l''artiste ne peut pas être vide.');
    END IF;
END;
/

/*INSERT INTO Artiste (idArt, NomArt, PrenomArt, specialite)
VALUES (2, 'Jannet Group', 'Jannet', 'pianiste');

INSERT INTO Artiste (idArt, NomArt, PrenomArt, specialite)
VALUES (3, '', 'Unknown', 'chanteur');*/


CREATE OR REPLACE TRIGGER trg_verif_spectacle
BEFORE INSERT OR UPDATE ON Spectacle
FOR EACH ROW
DECLARE
    capaciteLieu INTEGER;
    nbrRubriques INTEGER;
    nbrSpectaclesLieu INTEGER;
BEGIN
    
    SELECT capacite INTO capaciteLieu
    FROM Lieu
    WHERE idLieu = :NEW.idLieu;

    IF :NEW.nbrSpectateur > capaciteLieu THEN
        RAISE_APPLICATION_ERROR(-20006, 'Le nombre de spectateurs prévu dépasse la capacité du lieu.');
    END IF;

    IF :NEW.dateS <= SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007, 'La date du spectacle doit être supérieure à la date du jour.');
    END IF;

    SELECT COUNT(*) INTO nbrSpectaclesLieu
    FROM Spectacle
    WHERE idLieu = :NEW.idLieu AND dateS = :NEW.dateS AND idSpec != :NEW.idSpec;

    IF nbrSpectaclesLieu > 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Le lieu est déjà réservé pour un autre spectacle à cette date.');
    END IF;
END;
/
/*INSERT INTO Spectacle (idSpec, Titre, dateS, h_debut, dureeS, nbrSpectateur, idLieu)
VALUES (2, 'Concert de Rock', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 18.00, 3.00, 3000, 1);
INSERT INTO Spectacle (idSpec, Titre, dateS, h_debut, dureeS, nbrSpectateur, idLieu)
VALUES (3, 'Théâtre Moderne', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 19.00, 2.00, 200, 2);
INSERT INTO Spectacle (idSpec, Titre, dateS, h_debut, dureeS, nbrSpectateur, idLieu)
VALUES (4, 'Opéra', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 21.00, 1.50, 100, 1);*/

CREATE OR REPLACE TRIGGER trg_verif_rubrique
BEFORE INSERT OR UPDATE ON Rubrique
FOR EACH ROW
DECLARE
    dateSpectacle DATE;
    heureDebutSpectacle NUMBER(4,2);
    dureeSpectacle NUMBER(4,2);
    nbrRubriques INTEGER;
BEGIN
    
    SELECT h_debut, dureeS
    INTO heureDebutSpectacle, dureeSpectacle
    FROM Spectacle
    WHERE idSpec = :NEW.idSpec;

    IF (:NEW.H_debutR < heureDebutSpectacle) OR (:NEW.H_debutR > (heureDebutSpectacle + dureeSpectacle)) THEN
        RAISE_APPLICATION_ERROR(-20009, 'La date de la rubrique doit être comprise entre le début et la fin du spectacle.');
    END IF;

    IF (:NEW.H_debutR + :NEW.dureeRub) > (heureDebutSpectacle + dureeSpectacle) THEN
        RAISE_APPLICATION_ERROR(-20010, 'La rubrique doit commencer et finir pendant la durée du spectacle.');
    END IF;

    IF (:NEW.type NOT IN ('comedie', 'théatre', 'dance', 'imitation', 'magie', 'musique', 'chant')) THEN
        RAISE_APPLICATION_ERROR(-20011, 'Le type de la rubrique doit être : comedie, théatre, dance, imitation, magie, musique, chant.');
    END IF;
    
END;
/
CREATE OR REPLACE TRIGGER trg_count_rubrique
BEFORE INSERT ON Rubrique
FOR EACH ROW
DECLARE
    nbrRubriques INTEGER;
BEGIN
    SELECT COUNT(Idrub) INTO nbrRubriques
    FROM Rubrique
    WHERE idSpec = :NEW.idSpec;

    IF nbrRubriques >= 3 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Un spectacle ne peut pas avoir plus de 3 rubriques.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20013, 'Un spectacle ne peut pas avoir moins de 1 rubrique.');
        NULL;
END;
/
CREATE OR REPLACE TRIGGER trg_verif_billet
BEFORE INSERT OR UPDATE ON Billet
FOR EACH ROW
DECLARE
    prixGold    NUMBER(5, 2) := NULL;
    prixSilver  NUMBER(5, 2) := NULL;
    prixNormale NUMBER(5, 2) := NULL;
    numspectacle INTEGER;
BEGIN

    SELECT COUNT(*)
    INTO numspectacle
    FROM Spectacle
    WHERE idSpec = :NEW.idSpec;

    IF numspectacle = 0 THEN
        RAISE_APPLICATION_ERROR(-20014, 'Le spectacle associé au billet n''existe pas.');
    END IF;

    BEGIN
        SELECT prix INTO prixGold
        FROM Billet
        WHERE idSpec = :NEW.idSpec AND categorie = 'Gold'
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            prixGold := NULL;
    END;

    BEGIN
        SELECT prix INTO prixSilver
        FROM Billet
        WHERE idSpec = :NEW.idSpec AND categorie = 'Silver'
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            prixSilver := NULL;
    END;

    BEGIN
        SELECT prix INTO prixNormale
        FROM Billet
        WHERE idSpec = :NEW.idSpec AND categorie = 'Normale'
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            prixNormale := NULL;
    END;

    IF :NEW.categorie NOT IN ('Gold', 'Silver', 'Normale') THEN
        RAISE_APPLICATION_ERROR(-20015, 'La catégorie du billet doit être : Gold, Silver ou Normale.');
    END IF;

    IF :NEW.categorie = 'Silver' AND prixNormale IS NOT NULL AND :NEW.prix <= prixNormale THEN
        RAISE_APPLICATION_ERROR(-20016, 'Le prix d''un billet Silver doit être supérieur à celui des billets Normale pour ce spectacle.');
    END IF;

    IF :NEW.categorie = 'Gold' AND prixSilver IS NOT NULL AND :NEW.prix <= prixSilver THEN
        RAISE_APPLICATION_ERROR(-20017, 'Le prix d''un billet Gold doit être supérieur à celui des billets Silver pour ce spectacle.');
    END IF;

    IF :NEW.categorie = 'Normale' AND prixSilver IS NOT NULL AND :NEW.prix >= prixSilver THEN
        RAISE_APPLICATION_ERROR(-20018, 'Le prix d''un billet Normale doit être inférieur à celui des billets Silver pour ce spectacle.');
    END IF;

    IF prixNormale IS NOT NULL AND prixSilver IS NOT NULL AND prixGold IS NOT NULL THEN
        IF prixNormale >= prixSilver THEN
            RAISE_APPLICATION_ERROR(-20019, 'Le prix d''un billet Normale doit être inférieur à celui des billets Silver pour ce spectacle.');
        END IF;

        IF prixSilver >= prixGold THEN
            RAISE_APPLICATION_ERROR(-20020, 'Le prix d''un billet Silver doit être inférieur à celui des billets Gold pour ce spectacle.');
        END IF;
    END IF;

END;
/

INSERT INTO Artiste (idArt, NomArt, PrenomArt, specialite)
VALUES (1, 'Jamil', 'Yassine', 'magicien');
INSERT INTO Artiste (idArt, NomArt, PrenomArt, specialite)
VALUES (2, 'Ben Ismail', 'Yosra', 'musicien');
INSERT INTO Artiste (idArt, NomArt, PrenomArt, specialite)
VALUES (3, 'Jallouli', 'Issa', 'danseur');
INSERT INTO Artiste (idArt, NomArt, PrenomArt, specialite)
VALUES (4, 'Dridi', 'Fida', 'acteur');

/*INSERT INTO Spectacle (idSpec, Titre, dateS, h_debut, dureeS, nbrSpectateur, idLieu)
VALUES (1, 'Spectacle de Magie', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 20.00, 2.00, 50, 1);*/

/*INSERT INTO Rubrique (idRub, idSpec, idArt, H_debutR, dureeRub, type)
VALUES (2, 1, 2, 18.00, 1.00, 'dance');
INSERT INTO Rubrique (idRub, idSpec, idArt, H_debutR, dureeRub, type)
VALUES (3, 1, 3, 21.00, 2.50, 'comedie');
INSERT INTO Rubrique (idRub, idSpec, idArt, H_debutR, dureeRub, type)
VALUES (4, 1, 4, 20.30, 1.00, 'acrobaties');*/

/*INSERT INTO Rubrique (idRub, idSpec, idArt, H_debutR, dureeRub, type)
VALUES (1, 1, 1, 20.00, 0.30, 'magie');
INSERT INTO Rubrique (idRub, idSpec, idArt, H_debutR, dureeRub, type)
VALUES (2, 1, 2, 20.30, 0.30, 'musique');
INSERT INTO Rubrique (idRub, idSpec, idArt, H_debutR, dureeRub, type)
VALUES (3, 1, 3, 21.00, 0.30, 'dance');
INSERT INTO Rubrique (idRub, idSpec, idArt, H_debutR, dureeRub, type)
VALUES (4, 1, 4, 21.30, 0.30, 'comedie');*/

/*INSERT INTO Billet (idBillet, categorie, prix, idSpec, Vendu)
VALUES (1, 'Platinium', 160, 1, 'Non');  

INSERT INTO Billet (idBillet, categorie, prix, idSpec, Vendu)
VALUES (2, 'Silver', 90, 1, 'Non');

INSERT INTO Billet (idBillet, categorie, prix, idSpec, Vendu)
VALUES (3, 'Normale', 270, 1, 'Non');*/


CREATE OR REPLACE PACKAGE PlanificateurEsp AS

PROCEDURE ajouter_lieu(idLieu  Lieu.idLieu%TYPE,
NomLieu  Lieu.NomLieu%TYPE,Adresse  Lieu.Adresse%TYPE,
capacite  Lieu.capacite%TYPE);

PROCEDURE modifier_lieu(idL  Lieu.idLieu%TYPE,
NomL  Lieu.NomLieu%TYPE,cap  Lieu.capacite%TYPE );

PROCEDURE supprimer_lieu(idL  Lieu.idLieu%TYPE);

FUNCTION chercher_lieu(NomL  Lieu.NomLieu%TYPE DEFAULT NULL,
Adr  Lieu.Adresse%TYPE DEFAULT NULL,
cap  Lieu.capacite%TYPE DEFAULT NULL
) RETURN SYS_REFCURSOR;

END PlanificateurEsp;
/

CREATE OR REPLACE PACKAGE BODY PlanificateurEsp AS

PROCEDURE ajouter_lieu(idLieu  Lieu.idLieu%TYPE,
NomLieu  Lieu.NomLieu%TYPE,Adresse  Lieu.Adresse%TYPE,
capacite Lieu.capacite%TYPE) IS

BEGIN
    INSERT INTO Lieu (idLieu, NomLieu, Adresse, capacite)
    VALUES (idLieu, NomLieu, Adresse, capacite);
END ajouter_lieu;

PROCEDURE modifier_lieu(idL  Lieu.idLieu%TYPE,
NomL  Lieu.NomLieu%TYPE,cap  Lieu.capacite%TYPE) IS
BEGIN
    UPDATE Lieu
    SET NomLieu = NomL,capacite = cap
    WHERE idLieu = idL;
END modifier_lieu;

PROCEDURE supprimer_lieu(idL Lieu.idLieu%TYPE) IS
    nbrSpectacles INTEGER;
BEGIN
    SELECT COUNT(idSpec) INTO nbrSpectacles
    FROM Spectacle S
    WHERE S.idLieu = idL;

    IF nbrSpectacles > 0 THEN
       RAISE_APPLICATION_ERROR(-20005, 'Le lieu ne peut pas être supprimé car des spectacles y sont associés.');
    ELSE
        DELETE FROM Lieu
        WHERE idLieu = idL;
    END IF;
END supprimer_lieu;

FUNCTION chercher_lieu(NomL  Lieu.NomLieu%TYPE DEFAULT NULL,
Adr  Lieu.Adresse%TYPE DEFAULT NULL,
cap  Lieu.capacite%TYPE DEFAULT NULL) RETURN SYS_REFCURSOR AS
cur SYS_REFCURSOR;

BEGIN
    OPEN cur FOR
    SELECT idLieu, NomLieu, Adresse, capacite
    FROM Lieu
    WHERE  (NomLieu = NomL OR NomLieu IS NULL)
    AND (Adresse = Adr OR Adresse IS NULL)
    AND (capacite = cap OR capacite IS NULL);

    RETURN cur;
END chercher_lieu;

END PlanificateurEsp;
/

CREATE OR REPLACE PACKAGE PlanificateurEvt AS

PROCEDURE  ajouter_spectacle(idS Spectacle.idSpec%TYPE,
tit Spectacle.titre%TYPE,dS Spectacle.dateS%TYPE,
h_d Spectacle.h_debut%TYPE,durS Spectacle.dureeS%TYPE,
nbrSpec Spectacle.nbrSpectateur%TYPE,idL Spectacle.idLieu%TYPE );

PROCEDURE annuler_spectacle(idSpec  Spectacle.idSpec%TYPE);

PROCEDURE modifier_spectacle(idS Spectacle.idSpec%TYPE,
tit Spectacle.titre%TYPE,dS Spectacle.dateS%TYPE,
h_d Spectacle.h_debut%TYPE,durS Spectacle.dureeS%TYPE,
nbrSpec Spectacle.nbrSpectateur%TYPE,idL Spectacle.idLieu%TYPE );

PROCEDURE chercher_spectacle(idSpec Spectacle.idSpec%TYPE,
titre Spectacle.titre%TYPE);

PROCEDURE ajouter_rubrique(idRub Rubrique.idRub%TYPE, 
idSpec Spectacle.idSpec%TYPE,idArt Artiste.idArt%TYPE,
typeRub Rubrique.type%TYPE,H_debutR Rubrique.H_debutR%TYPE, 
dureeRub Rubrique.dureeRub%TYPE);

PROCEDURE modifier_rubrique(idR Rubrique.idRub%type,
idA Artiste.idArt%type, dureeR Rubrique.dureeRub%type, 
H_debR Rubrique.H_debutR%type );

PROCEDURE supprimer_rubrique(idRub Rubrique.idRub%TYPE);

PROCEDURE chercher_rubrique_idSpec(idS Spectacle.idSpec%TYPE);

PROCEDURE chercher_rubrique_nomA(nomArtiste Artiste.NomArt%TYPE);

END PlanificateurEvt;
/

CREATE OR REPLACE PACKAGE BODY PlanificateurEvt AS

PROCEDURE ajouter_spectacle(idS Spectacle.idSpec%TYPE,
tit Spectacle.titre%TYPE,dS Spectacle.dateS%TYPE,
h_d Spectacle.h_debut%TYPE,durS Spectacle.dureeS%TYPE,
nbrSpec Spectacle.nbrSpectateur%TYPE,idL Spectacle.idLieu%TYPE) IS
BEGIN
    INSERT INTO Spectacle (idSpec, titre, dateS, h_debut, dureeS, nbrSpectateur, idLieu)
    VALUES (idS, tit, dS,h_d,durS,nbrSpec, idL);
END ajouter_spectacle;

PROCEDURE annuler_spectacle(idSpec Spectacle.idSpec%TYPE) IS
BEGIN
    DELETE FROM Spectacle WHERE idSpec = idSpec;
END annuler_spectacle;

PROCEDURE modifier_spectacle(idS Spectacle.idSpec%TYPE,
tit Spectacle.titre%TYPE,dS Spectacle.dateS%TYPE,
h_d Spectacle.h_debut%TYPE,durS Spectacle.dureeS%TYPE,
nbrSpec Spectacle.nbrSpectateur%TYPE,idL Spectacle.idLieu%TYPE ) IS

BEGIN
    UPDATE Spectacle
    SET titre = tit, dateS = dS, h_debut = h_d, dureeS = durS,
    nbrSpectateur = nbrSpec, idLieu = idL
    WHERE idSpec = idS;
END modifier_spectacle;

PROCEDURE chercher_spectacle(idSpec Spectacle.idSpec%TYPE,
titre Spectacle.titre%TYPE) IS
CURSOR spectacle_cursor IS
SELECT idSpec, titre, dateS, h_debut, dureeS, nbrSpectateur, idLieu
FROM Spectacle
WHERE (idSpec = idSpec OR idSpec IS NULL)
AND (titre = titre OR titre IS NULL);

rec_spectacle Spectacle%ROWTYPE;

BEGIN
    OPEN spectacle_cursor;
    LOOP
        FETCH spectacle_cursor INTO rec_spectacle;
        EXIT WHEN spectacle_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || rec_spectacle.idSpec || ', Titre: ' || rec_spectacle.titre || 
                            ', Date: ' || TO_CHAR(rec_spectacle.dateS, 'YYYY-MM-DD') || 
                            ', Heure début: ' || rec_spectacle.h_debut || 
                            ', Durée: ' || rec_spectacle.dureeS ||
                            ', Nombre Spectateurs: ' || rec_spectacle.nbrSpectateur ||
                            ', Identifiant de lieu: ' || rec_spectacle.idLieu);
    END LOOP;
    CLOSE spectacle_cursor;    
END chercher_spectacle;

PROCEDURE ajouter_rubrique(idRub Rubrique.idRub%TYPE, 
idSpec Spectacle.idSpec%TYPE, idArt Artiste.idArt%TYPE,
typeRub Rubrique.type%TYPE, H_debutR Rubrique.H_debutR%TYPE, 
dureeRub Rubrique.dureeRub%TYPE) IS

BEGIN
    INSERT INTO Rubrique(idRub, idSpec, idArt, type, H_debutR, dureeRub)
    VALUES(idRub, idSpec, idArt, typeRub, H_debutR, dureeRub);
END ajouter_rubrique;

PROCEDURE modifier_rubrique(idR Rubrique.idRub%type,
idA Artiste.idArt%type, dureeR Rubrique.dureeRub%type, 
H_debR Rubrique.H_debutR%type ) IS

BEGIN
    UPDATE Rubrique SET idArt = idA, dureeRub = dureeR, H_debutR = H_debR
    WHERE idRub =idR ;
    
END modifier_rubrique;

PROCEDURE supprimer_rubrique(idRub Rubrique.idRub%type) IS
BEGIN
    DELETE FROM Rubrique WHERE idRub = idRub;
END supprimer_rubrique;

PROCEDURE chercher_rubrique_idSpec(idS Spectacle.idSpec%TYPE) IS
CURSOR rubrique_cursor IS
SELECT idRub,idSpec,idArt, H_debutR, dureeRub,type
FROM Rubrique
WHERE idSpec=idS;

rec_rubrique Rubrique%ROWTYPE;
BEGIN
    OPEN rubrique_cursor;
    LOOP
        FETCH rubrique_cursor INTO rec_rubrique;
        EXIT WHEN rubrique_cursor%NOTFOUND ;

        DBMS_OUTPUT.PUT_LINE('Rubrique ID: ' || rec_rubrique.idRub || 
                                 'Spectacle ID: ' || rec_rubrique.idSpec ||
                                 ', Artiste: ' || rec_rubrique.idArt||
                                 ', Heure début: ' || rec_rubrique.H_debutR || 
                                 ', Durée: ' || rec_rubrique.dureeRub || 
                                 ', Type: ' || rec_rubrique.type );
    END LOOP;
    CLOSE rubrique_cursor;
END chercher_rubrique_idSpec;

PROCEDURE chercher_rubrique_nomA(nomArtiste Artiste.NomArt%type) AS
CURSOR rubrique_cursor IS
SELECT R.idRub,R.idSpec, R.idArt, R.H_debutR, R.dureeRub,R.type
FROM Rubrique R, Artiste A
WHERE R.idArt = A.idArt
AND A.NomArt = nomArtiste;

rec_rubrique Rubrique%ROWTYPE;

BEGIN
    OPEN rubrique_cursor;
    LOOP
        FETCH rubrique_cursor INTO rec_rubrique;
        EXIT WHEN rubrique_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Rubrique ID: ' || rec_rubrique.idRub || 
                             'Spectacle ID: ' || rec_rubrique.idSpec ||
                             ', Artiste: ' || rec_rubrique.idArt||
                             ', Heure début: ' || rec_rubrique.H_debutR || 
                             ', Durée: ' || rec_rubrique.dureeRub || 
                             ', Artiste: ' || rec_rubrique.idArt||
                             ', Type: ' || rec_rubrique.type );
    END LOOP;
    CLOSE rubrique_cursor;
END chercher_rubrique_nomA;
END PlanificateurEvt;
/
BEGIN
    PlanificateurEvt.ajouter_spectacle(1, 'Spectacle de Magie', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 20, 2, 50, 1);
END;
/
SELECT * FROM Spectacle;
BEGIN 
    PlanificateurEvt.modifier_spectacle(1, 'Spectacle de Magie', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 20, 2, 500, 2);
END;
/
SELECT * FROM Spectacle;
SET SERVEROUTPUT ON
BEGIN 
    PlanificateurEvt.chercher_spectacle(1, NULL);
END;
/
BEGIN 
    PlanificateurEvt.ajouter_rubrique(1, 1, 1, 'musique',21,1);
END;
/
SELECT * FROM Rubrique;
BEGIN 
    PlanificateurEvt.modifier_rubrique(1, 1,1,20);
END;
/
SELECT * FROM Rubrique;
BEGIN 
    PlanificateurEvt.chercher_rubrique_idSpec(1);
END;
/
//SELECT * FROM Rubrique;
BEGIN 
    PlanificateurEvt.chercher_rubrique_nomA('Jamil');
END;
/
BEGIN 
    PlanificateurEvt.supprimer_rubrique(1);
END;
/
SELECT * FROM Rubrique;

BEGIN
    PlanificateurEvt.annuler_spectacle(1);
END;
/
SELECT * FROM Spectacle;
CREATE OR REPLACE PACKAGE GestCommandesBillets AS

    PROCEDURE ajouter_billet(idBillet IN INTEGER, categorie IN VARCHAR2, prix IN NUMBER, idSpec IN INTEGER, vendu IN VARCHAR);
    
    PROCEDURE modifier_billet(idB IN INTEGER, cat IN VARCHAR2, p IN NUMBER,idS IN INTEGER, v IN VARCHAR);
    
    PROCEDURE supprimer_billet(idBillet IN INTEGER);
END GestCommandesBillets;
/

CREATE OR REPLACE PACKAGE BODY GestCommandesBillets AS

    PROCEDURE ajouter_billet(idBillet IN INTEGER , categorie IN VARCHAR2, prix IN NUMBER, idSpec IN INTEGER, vendu IN VARCHAR) IS
    BEGIN
        INSERT INTO Billet (idBillet, categorie, prix, idSpec, Vendu)
        VALUES (idBillet, categorie, prix, idSpec, vendu);
    END ajouter_billet;

    PROCEDURE modifier_billet(idB IN INTEGER, cat IN VARCHAR2, p IN NUMBER,idS IN INTEGER, v IN VARCHAR) IS
    BEGIN
        UPDATE Billet
        SET categorie = cat, prix = p, Vendu = v
        WHERE idBillet = idB
        AND   idSpec=idS;
    END modifier_billet;

    PROCEDURE supprimer_billet(idBillet IN INTEGER) IS
    BEGIN
        DELETE FROM Billet WHERE idBillet = idBillet;
    END supprimer_billet;

END GestCommandesBillets;
/
/*BEGIN
    PlanificateurEsp.ajouter_lieu(1, 'Théâtre Municipal', '123 Rue Principale', 500);
    PlanificateurEsp.ajouter_lieu(2, 'Salle Polyvalente', '456 Avenue Centrale', 300);
    PlanificateurEsp.ajouter_lieu(3, 'Amphithéâtre du Parc', '789 Boulevard Sud', 1000);
END;
/
SELECT * FROM Lieu;
BEGIN
    PlanificateurEsp.modifier_lieu(2, 'Salle des Fêtes', 400);
END;
/
SELECT * FROM Lieu;
BEGIN
    PlanificateurEsp.supprimer_lieu(3);
END;
/
SELECT * FROM Lieu ;
SET SERVEROUTPUT ON;

SET SERVEROUTPUT ON;

DECLARE
    cur SYS_REFCURSOR;
    idLieu INTEGER;
    NomLieu VARCHAR2(30);
    Adresse VARCHAR2(100);
    capacite NUMBER;
    result_count INTEGER := 0; -- Compteur pour suivre les résultats
BEGIN
    -- Appel de la fonction chercher_lieu
    cur := PlanificateurEsp.chercher_lieu('Théâtre Municipal', NULL, NULL);

    -- Parcourir le curseur
    LOOP
        FETCH cur INTO idLieu, NomLieu, Adresse, capacite;
        EXIT WHEN cur%NOTFOUND;

        -- Affichage des résultats
        DBMS_OUTPUT.PUT_LINE('idLieu: ' || idLieu || ', NomLieu: ' || NomLieu || 
                             ', Adresse: ' || Adresse || ', capacite: ' || capacite);
        result_count := result_count + 1;
    END LOOP;

    -- Vérification si aucun résultat n'a été trouvé
    IF result_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Aucun résultat trouvé.');
    END IF;

    -- Fermer le curseur
    CLOSE cur;
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test affichage.');
END;
/
*/

/*BEGIN 
    GestCommandesBillets.ajouter_billet(1, 'Normale', 50, 1, 'Non'); 
END;
/
SELECT * FROM Billet;
BEGIN 
    GestCommandesBillets.modifier_billet(1, 'Silver', 75,1, 'Oui'); 
END;
/
SELECT * FROM Billet;
BEGIN 
    GestCommandesBillets.supprimer_billet(1); 
END;
/*/
/*SELECT * FROM Rubrique;
SELECT * FROM Spectacle;
SELECT * FROM Billet;*/


//select * from Lieu;
//SELECT status FROM v$instance;
