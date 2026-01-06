DROP TABLE IF EXIST icc_world_cup; 

CREATE TABLE icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);

INSERT INTO icc_world_cup values
('India','SL','India'),
('SL','Aus','Aus'),
('SA','Eng','Eng'),
('Eng','NZ','NZ'),
('Aus','India','India');