-- Drop previous versions of the tables if they exist, in reverse order of foreign keys.
DROP TABLE IF EXISTS Trade;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS PlayerProperty;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS House;
DROP TABLE IF EXISTS Hotel;
DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Player;

-- Create the schema.
CREATE TABLE Game (
    ID integer PRIMARY KEY,
    time timestamp,
    isComplete boolean DEFAULT false  -- Track whether the game is completed or in progress
);

CREATE TABLE Player (
    ID integer PRIMARY KEY, 
    emailAddress varchar(50) NOT NULL,
    name varchar(50)
);

CREATE TABLE PlayerGame (
    gameID integer REFERENCES Game(ID), 
    playerID integer REFERENCES Player(ID),
    score integer,
    cash integer,  -- New column to track player's cash
    currentLocation integer  -- New column to track player's position on the board
);

CREATE TABLE Property (
    ID integer PRIMARY KEY,
    name varchar(50),
    cost integer,
    rent integer,
    houseCost integer,
    hotelCost integer
);

CREATE TABLE PlayerProperty (
    playerID integer REFERENCES Player(ID),
    propertyID integer REFERENCES Property(ID),
    houses integer DEFAULT 0,  -- Track how many houses the player has on a property (0-4)
    hotels integer DEFAULT 0   -- Track if the player has a hotel on the property (0 or 1)
);

CREATE TABLE House (
    gameID integer REFERENCES Game(ID),
    playerID integer REFERENCES Player(ID),
    propertyID integer REFERENCES Property(ID),
    count integer  -- Number of houses on the property
);

CREATE TABLE Hotel (
    gameID integer REFERENCES Game(ID),
    playerID integer REFERENCES Player(ID),
    propertyID integer REFERENCES Property(ID)
);

-- New Loan table to track loans taken by players
CREATE TABLE Loan (
    loanID integer PRIMARY KEY,
    playerID integer REFERENCES Player(ID),
    amount integer,  -- Loan amount
    interestRate decimal(4, 2),  -- Interest rate on the loan
    isPaidOff boolean DEFAULT false  -- Whether the loan is paid off
);

-- New Trade table to track trades between players
CREATE TABLE Trade (
    tradeID integer PRIMARY KEY,
    fromPlayerID integer REFERENCES Player(ID),
    toPlayerID integer REFERENCES Player(ID),
    propertyID integer REFERENCES Property(ID),  -- Property being traded
    cash integer DEFAULT 0  -- Cash included in the trade (optional)
);

-- Allow users to select data from the tables.
GRANT SELECT ON Game TO PUBLIC;
GRANT SELECT ON Player TO PUBLIC;
GRANT SELECT ON PlayerGame TO PUBLIC;
GRANT SELECT ON Property TO PUBLIC;
GRANT SELECT ON PlayerProperty TO PUBLIC;
GRANT SELECT ON House TO PUBLIC;
GRANT SELECT ON Hotel TO PUBLIC;
GRANT SELECT ON Loan TO PUBLIC;
GRANT SELECT ON Trade TO PUBLIC;

-- Add sample records.
INSERT INTO Game (ID, time, isComplete) VALUES (1, '2023-06-27 08:00:00', false);
INSERT INTO Game (ID, time, isComplete) VALUES (2, '2023-06-28 13:20:00', true);

INSERT INTO Player (ID, emailAddress, name) VALUES (1, 'me@calvin.edu', 'Alice');
INSERT INTO Player (ID, emailAddress, name) VALUES (2, 'king@gmail.edu', 'The King');
INSERT INTO Player (ID, emailAddress, name) VALUES (3, 'dog@gmail.edu', 'Dogbreath');

INSERT INTO PlayerGame (gameID, playerID, score, cash, currentLocation) VALUES (1, 1, 500, 1500, 5);
INSERT INTO PlayerGame (gameID, playerID, score, cash, currentLocation) VALUES (1, 2, 0, 1000, 15);
INSERT INTO PlayerGame (gameID, playerID, score, cash, currentLocation) VALUES (2, 3, 2350, 1200, 10);

INSERT INTO Property (ID, name, cost, rent, houseCost, hotelCost) VALUES (1, 'Boardwalk', 400, 50, 100, 200);
INSERT INTO Property (ID, name, cost, rent, houseCost, hotelCost) VALUES (2, 'Park Place', 350, 35, 100, 200);

INSERT INTO PlayerProperty (playerID, propertyID, houses, hotels) VALUES (1, 1, 2, 0);
INSERT INTO PlayerProperty (playerID, propertyID, houses, hotels) VALUES (2, 2, 0, 1);

INSERT INTO House (gameID, playerID, propertyID, count) VALUES (1, 1, 1, 2);
INSERT INTO Hotel (gameID, playerID, propertyID) VALUES (1, 2, 2);

-- Add sample records for Loan table
INSERT INTO Loan (loanID, playerID, amount, interestRate, isPaidOff) VALUES (1, 1, 500, 5.00, false);
INSERT INTO Loan (loanID, playerID, amount, interestRate, isPaidOff) VALUES (2, 3, 1000, 3.50, false);

-- Add sample records for Trade table
INSERT INTO Trade (tradeID, fromPlayerID, toPlayerID, propertyID, cash) VALUES (1, 1, 2, 1, 200);
INSERT INTO Trade (tradeID, fromPlayerID, toPlayerID, propertyID, cash) VALUES (2, 2, 3, 2, 0);
