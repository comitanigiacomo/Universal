CREATE TABLE universal.user (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    cognome VARCHAR(255),
    password VARCHAR(255),
    tipo VARCHAR(50)
);
