--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: appelli; Type: TABLE DATA; Schema: universal; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE universal.appelli DISABLE TRIGGER ALL;

INSERT INTO universal.appelli VALUES (1, '2024-04-23', 'celoria', 1);
INSERT INTO universal.appelli VALUES (2, '2024-05-02', 'celoria', 6);
INSERT INTO universal.appelli VALUES (3, '2024-04-16', 'venezian', 1);
INSERT INTO universal.appelli VALUES (4, '2024-09-26', 'settore didattico', 1);
INSERT INTO universal.appelli VALUES (5, '2024-10-23', 'celoria', 2);
INSERT INTO universal.appelli VALUES (6, '2024-09-30', 'venezian', 2);
INSERT INTO universal.appelli VALUES (7, '2024-10-25', 'settore didattico', 2);
INSERT INTO universal.appelli VALUES (8, '2024-07-31', 'celoria', 3);
INSERT INTO universal.appelli VALUES (9, '2024-08-08', 'venezian', 3);
INSERT INTO universal.appelli VALUES (10, '2024-12-18', 'settore didattico', 3);
INSERT INTO universal.appelli VALUES (11, '2024-06-07', 'celoria', 5);
INSERT INTO universal.appelli VALUES (12, '2024-08-02', 'venezian', 5);
INSERT INTO universal.appelli VALUES (13, '2024-04-02', 'settore didattico', 5);
INSERT INTO universal.appelli VALUES (14, '2024-08-23', 'venezian', 6);
INSERT INTO universal.appelli VALUES (15, '2024-07-12', 'settore didattico', 6);
INSERT INTO universal.appelli VALUES (16, '2024-10-10', 'celoria', 7);
INSERT INTO universal.appelli VALUES (17, '2024-10-23', 'venezian', 7);
INSERT INTO universal.appelli VALUES (18, '2024-09-13', 'golgi', 7);
INSERT INTO universal.appelli VALUES (19, '2024-08-14', 'celoria', 8);
INSERT INTO universal.appelli VALUES (20, '2024-08-01', 'venezian', 8);
INSERT INTO universal.appelli VALUES (21, '2024-09-23', 'settore didattico', 8);
INSERT INTO universal.appelli VALUES (22, '2024-07-18', 'celoria', 14);
INSERT INTO universal.appelli VALUES (23, '2024-09-04', 'venezian', 14);
INSERT INTO universal.appelli VALUES (24, '2024-09-27', 'settore didattico', 14);
INSERT INTO universal.appelli VALUES (25, '2024-09-13', 'celoria', 9);
INSERT INTO universal.appelli VALUES (26, '2024-08-27', 'venezian', 9);
INSERT INTO universal.appelli VALUES (27, '2024-09-02', 'settore didattico', 9);
INSERT INTO universal.appelli VALUES (28, '2024-07-03', 'celoria', 10);
INSERT INTO universal.appelli VALUES (29, '2024-06-06', 'venezian', 10);
INSERT INTO universal.appelli VALUES (30, '2024-08-02', 'settore didattico', 10);
INSERT INTO universal.appelli VALUES (31, '2024-10-16', 'celoriaa', 12);
INSERT INTO universal.appelli VALUES (32, '2024-07-19', 'venezian', 12);
INSERT INTO universal.appelli VALUES (33, '2024-09-30', 'settore didattico', 12);
INSERT INTO universal.appelli VALUES (34, '2024-05-15', 'settore didattico', 6);
INSERT INTO universal.appelli VALUES (35, '2024-05-29', 'celoria', 1);
INSERT INTO universal.appelli VALUES (36, '2024-06-27', 'celoria', 8);
INSERT INTO universal.appelli VALUES (37, '2024-07-12', 'celoria', 7);
INSERT INTO universal.appelli VALUES (38, '2024-05-31', 'celoria', 7);
INSERT INTO universal.appelli VALUES (39, '2024-05-06', 'golgi', 7);
INSERT INTO universal.appelli VALUES (40, '2024-05-30', 'golgi', 1);


ALTER TABLE universal.appelli ENABLE TRIGGER ALL;

--
-- Data for Name: corsi_di_laurea; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.corsi_di_laurea DISABLE TRIGGER ALL;

INSERT INTO universal.corsi_di_laurea VALUES (1, 'Informatica', 3, 'CdL in informatica');
INSERT INTO universal.corsi_di_laurea VALUES (2, 'Medicina', 5, 'CdL in medicina');
INSERT INTO universal.corsi_di_laurea VALUES (3, 'architettura', 2, 'CdL in architettura');


ALTER TABLE universal.corsi_di_laurea ENABLE TRIGGER ALL;

--
-- Data for Name: utenti; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.utenti DISABLE TRIGGER ALL;

INSERT INTO universal.utenti VALUES ('7879b44c-b66f-499b-be4a-13f0287147ee', 'fabrizio', 'conte', 'segretario', 'fabrizio.conte@segretari.universal.it', '$2a$06$OTSIMMhU9p75nY5US1y/ru.qyaD.QOiA87U6Bboimdoacxy9Cwpeu');
INSERT INTO universal.utenti VALUES ('b9800305-79aa-42cc-a9e9-d3264a2e35b7', 'michele', 'bolis', 'docente', 'michele.bolis@docenti.universal.it', '$2a$06$DEjUcBW1VSLi3Juyh7.EruLstGVFMaq7T69GkL2VkBULA6DeZ7Sz.');
INSERT INTO universal.utenti VALUES ('d321fd61-9eb7-4b3e-b417-8ed291a52d26', 'luca', 'corradini', 'studente', 'luca.corradini@studenti.universal.it', '$2a$06$Cs1LKfqRzOrCwLTMoys4AegwtrSI7huJ1GphjoV/YUkRTMMHKj7m.');
INSERT INTO universal.utenti VALUES ('32f28203-8362-4bb3-976d-ef8940136157', 'mattia', 'delledonne', 'studente', 'mattia.delledonne@studenti.universal.it', '$2a$06$jfRafveCjH136OE7w7s/deKLezqqwcl9yJd9idTuy2rpFX4U7Zac6');
INSERT INTO universal.utenti VALUES ('0e9df6b4-af65-488e-9820-9653311438e1', 'alice', 'guizzardi', 'docente', 'alice.guizzardi@docenti.universal.it', '$2a$06$XuZwqLJn7A9eU9H2i26Z5eLofj9P8w5fLc9.x0QTF9QmaYUURVmqG');
INSERT INTO universal.utenti VALUES ('17fb4ccc-500f-4f2e-8872-1703c3ccf818', 'sara', 'quartieri', 'docente', 'sara.quartieri@docenti.universal.it', '$2a$06$61c2v0dhP41TLTB0.Bi1oOT2z7nV6lFQRvzj8myQYk2v1PEFzbkPO');
INSERT INTO universal.utenti VALUES ('0e7b3d3a-00f2-4612-bf74-737ee1113b3a', 'carlo', 'azzuri', 'segretario', 'carlo.azzuri@segretari.universal.it', '$2a$06$1C9jOO07VW8H0FbWx/TRpOL9w5fjK61pjxfI7/cpgZPV7eMevS55q');
INSERT INTO universal.utenti VALUES ('c4e34657-637d-4ad1-9651-4fa84d35d6d3', 'axel ', 'toscano', 'studente', 'axel .toscano@studenti.universal.it', '$2a$06$BLfpVnO81IjGB0xqxIvn5OEYx8gMb3eeDmrOb6pkKDw44BZZv5bBy');
INSERT INTO universal.utenti VALUES ('7a083611-db98-40c7-9be2-d805ec343906', 'riccardo', 'totaro', 'studente', 'riccardo.totaro@studenti.universal.it', '$2a$06$COqj5CW4qBXQxzY7S/3D5.WbEqo.5BTI4xn6Q1I6f9iQgaTaYysdO');
INSERT INTO universal.utenti VALUES ('72b30203-f0f7-4a10-87f9-ca9c0779d69c', 'marica', 'muolo', 'studente', 'marica.muolo@studenti.universal.it', '$2a$06$ayvGRZ3PFDaWgLYc6r8KpeXgqSfWMOp1a8K4nCpgha4vNuvQ9C8.u');
INSERT INTO universal.utenti VALUES ('5ee6969b-4ed4-4a97-b962-7d8c06082194', 'ludovica', 'porro', 'studente', 'ludovica.porro@studenti.universal.it', '$2a$06$KkRcq.Huk14xCyMqX9RWnuRfb34fd4y32eb6ibfAGC4tJ9ZeIqZ0K');
INSERT INTO universal.utenti VALUES ('f117ca3d-82b7-4512-accc-7c04d1191250', 'alessandro', 'dino', 'studente', 'alessandro.dino@studenti.universal.it', '$2a$06$VXP7mfE/VJ1g49DI672NbezksMwlih8v8FDO8lTI12KWPW60T1K8G');
INSERT INTO universal.utenti VALUES ('cdd9ef84-c4d1-4540-b792-662d0ccb97fc', 'alice', 'annoni', 'studente', 'alice.annoni@studenti.universal.it', '$2a$06$YYkZyOKBTyECY9hcSrWwAOEv5tJ8a4qX/KBhXrz1dS6w1Yzd6IAm2');
INSERT INTO universal.utenti VALUES ('7ffe9ae9-f3d9-49b2-ad61-85bf83b40986', 'simone', 'monesi', 'studente', 'simone.monesi@studenti.universal.it', '$2a$06$z3//Vb00v9iF18hyCg0.M.wqrHljkcoOdrpRBKrrcmtcjmBXoa6Wa');
INSERT INTO universal.utenti VALUES ('e546a150-2581-4265-8ce3-557c79bdd498', 'davide', 'dellefave', 'studente', 'davide.dellefave@studenti.universal.it', '$2a$06$xZ9E0Tw5XyRD4Da12ED.w.fsyVuem/hu4qCQ6wP74J9UB.hjZ04Ki');
INSERT INTO universal.utenti VALUES ('7b4bd4c8-268e-42c3-864b-862f1283604c', 'christian', 'morelli', 'studente', 'christian.morelli@studenti.universal.it', '$2a$06$l7oUj/Gn2We2igeVn4xqUOzbRRSEIh5yBP6K7YP5ObBg1yVxv7316');
INSERT INTO universal.utenti VALUES ('b60c089e-8075-4a60-9859-ec33b135b8b9', 'denise', 'caria', 'studente', 'denise.caria@studenti.universal.it', '$2a$06$11a9nxPL8r1zv4rikSLViOUmwnrUUtO3mnqXdBW3QCLGjYDxlik0m');
INSERT INTO universal.utenti VALUES ('c485f691-04b5-42a6-9c3e-e99865516df4', 'silvia', 'colombo', 'studente', 'silvia.colombo@studenti.universal.it', '$2a$06$iY7W.cFJgYpWMP.SjlkJxueUbkB4dBgFAPqQNzNYxZsdmlNfTPEE6');
INSERT INTO universal.utenti VALUES ('c4a3cc4b-b101-474c-96a2-151f486db9b5', 'sofia', 'comitani', 'studente', 'sofia.comitani@studenti.universal.it', '$2a$06$g.3njzaJZCNZHvShfXf82O.CJoVrwzGyOeICytwqDKv7Fa/52xtmy');
INSERT INTO universal.utenti VALUES ('7a4cf567-cbe0-413b-8550-bd918c5af383', 'raoul', 'torri', 'ex_studente', 'raoul.torri@exstudenti.universal.it', '$2a$06$RXRc8xvwItzbOzF3uWbOV.jmpDegx/lNZlhNJsh56mbiGBrIbwBLq');
INSERT INTO universal.utenti VALUES ('1f4d2a4e-d5dc-4da2-91e4-170ab0fb50de', 'andrea', 'galliano', 'ex_studente', 'andrea.galliano@exstudenti.universal.it', '$2a$06$SgZIBNYF9MuV6aqlct6mhuiGYO7Eb.xCuCoNj8Upu7oR16Cfenbxm');
INSERT INTO universal.utenti VALUES ('4df9bf9d-41e1-4155-894b-f8808f8167eb', 'luca', 'favini', 'studente', 'luca.favini@studenti.universal.it', '$2a$06$/Abawta3.w80b1xEszLrEum4f0Rs/Tchg2ITVCns.29zStUmlDbA2');
INSERT INTO universal.utenti VALUES ('fdb13852-7728-4929-ae3b-5803692905cb', 'daniele', 'deluca', 'docente', 'daniele.deluca@docenti.universal.it', '$2a$06$MGn3YYlNiTuclqgwK1RPOO52OecSEwcZRu1S6BIj1OinAmWY0l0l.');
INSERT INTO universal.utenti VALUES ('3dec0064-701b-463a-9685-6578b4622c32', 'giacomo', 'comitani', 'segretario', 'giacomo.comitani@segretari.universal.it', '$2a$06$wbkDHg2wTt8aILroCVbyVeDQsUkOHvcvltedFtyZA1I8agU27whxO');


ALTER TABLE universal.utenti ENABLE TRIGGER ALL;

--
-- Data for Name: docenti; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.docenti DISABLE TRIGGER ALL;

INSERT INTO universal.docenti VALUES ('b9800305-79aa-42cc-a9e9-d3264a2e35b7', 'edificio 74');
INSERT INTO universal.docenti VALUES ('fdb13852-7728-4929-ae3b-5803692905cb', 'edificio 74');
INSERT INTO universal.docenti VALUES ('0e9df6b4-af65-488e-9820-9653311438e1', 'edificio 74');
INSERT INTO universal.docenti VALUES ('17fb4ccc-500f-4f2e-8872-1703c3ccf818', 'edificio 74');


ALTER TABLE universal.docenti ENABLE TRIGGER ALL;

--
-- Data for Name: ex_studenti; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.ex_studenti DISABLE TRIGGER ALL;

INSERT INTO universal.ex_studenti VALUES ('7a4cf567-cbe0-413b-8550-bd918c5af383', 100038, 'rinuncia', 1);
INSERT INTO universal.ex_studenti VALUES ('1f4d2a4e-d5dc-4da2-91e4-170ab0fb50de', 100027, 'rinuncia', 3);


ALTER TABLE universal.ex_studenti ENABLE TRIGGER ALL;

--
-- Data for Name: insegnamenti; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.insegnamenti DISABLE TRIGGER ALL;

INSERT INTO universal.insegnamenti VALUES (1, 'progettazione', 'corso di progettazione', 2024, 'b9800305-79aa-42cc-a9e9-d3264a2e35b7', 3);
INSERT INTO universal.insegnamenti VALUES (2, 'fisica', 'corso di fisica', 2024, 'b9800305-79aa-42cc-a9e9-d3264a2e35b7', 3);
INSERT INTO universal.insegnamenti VALUES (3, 'analisi', 'corso di analisi', 2024, 'b9800305-79aa-42cc-a9e9-d3264a2e35b7', 3);
INSERT INTO universal.insegnamenti VALUES (6, 'programmazione', 'corso di programmazione', 2024, 'fdb13852-7728-4929-ae3b-5803692905cb', 1);
INSERT INTO universal.insegnamenti VALUES (7, 'algoritmi', 'corso di algoritmi', 2024, 'fdb13852-7728-4929-ae3b-5803692905cb', 1);
INSERT INTO universal.insegnamenti VALUES (8, 'basi di dati', 'corso di basi di dati', 2024, 'fdb13852-7728-4929-ae3b-5803692905cb', 1);
INSERT INTO universal.insegnamenti VALUES (9, 'anatomia', 'corso di anatomia', 2024, '17fb4ccc-500f-4f2e-8872-1703c3ccf818', 2);
INSERT INTO universal.insegnamenti VALUES (10, 'biologia', 'corso di biologia', 2024, '17fb4ccc-500f-4f2e-8872-1703c3ccf818', 2);
INSERT INTO universal.insegnamenti VALUES (12, 'chirurgia', 'corso di chirurgia', 2024, '17fb4ccc-500f-4f2e-8872-1703c3ccf818', 2);
INSERT INTO universal.insegnamenti VALUES (14, 'sistemi operativi', 'corso di sistemi operativi', 2024, '0e9df6b4-af65-488e-9820-9653311438e1', 1);
INSERT INTO universal.insegnamenti VALUES (5, 'strutture', 'corso di strutture', 2024, '17fb4ccc-500f-4f2e-8872-1703c3ccf818', 3);
INSERT INTO universal.insegnamenti VALUES (15, 'teoria dei grafi', 'corso di teoria dei grafi', 2024, '0e9df6b4-af65-488e-9820-9653311438e1', 3);


ALTER TABLE universal.insegnamenti ENABLE TRIGGER ALL;

--
-- Data for Name: iscritti; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.iscritti DISABLE TRIGGER ALL;

INSERT INTO universal.iscritti VALUES (2, '4df9bf9d-41e1-4155-894b-f8808f8167eb', 6, 26);
INSERT INTO universal.iscritti VALUES (2, '4df9bf9d-41e1-4155-894b-f8808f8167eb', 6, 30);
INSERT INTO universal.iscritti VALUES (6, 'b60c089e-8075-4a60-9859-ec33b135b8b9', 2, 0);
INSERT INTO universal.iscritti VALUES (2, '4df9bf9d-41e1-4155-894b-f8808f8167eb', 6, 0);
INSERT INTO universal.iscritti VALUES (34, '4df9bf9d-41e1-4155-894b-f8808f8167eb', 6, 0);
INSERT INTO universal.iscritti VALUES (3, '5ee6969b-4ed4-4a97-b962-7d8c06082194', 1, 22);
INSERT INTO universal.iscritti VALUES (3, 'c4e34657-637d-4ad1-9651-4fa84d35d6d3', 1, 0);
INSERT INTO universal.iscritti VALUES (3, '5ee6969b-4ed4-4a97-b962-7d8c06082194', 1, 0);
INSERT INTO universal.iscritti VALUES (3, '7ffe9ae9-f3d9-49b2-ad61-85bf83b40986', 1, 0);


ALTER TABLE universal.iscritti ENABLE TRIGGER ALL;

--
-- Data for Name: propedeutico; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.propedeutico DISABLE TRIGGER ALL;

INSERT INTO universal.propedeutico VALUES (2, 15);
INSERT INTO universal.propedeutico VALUES (15, 1);
INSERT INTO universal.propedeutico VALUES (15, 5);


ALTER TABLE universal.propedeutico ENABLE TRIGGER ALL;

--
-- Data for Name: segretari; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.segretari DISABLE TRIGGER ALL;

INSERT INTO universal.segretari VALUES ('3dec0064-701b-463a-9685-6578b4622c32', 'sede centrale');
INSERT INTO universal.segretari VALUES ('7879b44c-b66f-499b-be4a-13f0287147ee', 'sede centrale');
INSERT INTO universal.segretari VALUES ('0e7b3d3a-00f2-4612-bf74-737ee1113b3a', 'sede centrale');


ALTER TABLE universal.segretari ENABLE TRIGGER ALL;

--
-- Data for Name: studenti; Type: TABLE DATA; Schema: universal; Owner: -
--

ALTER TABLE universal.studenti DISABLE TRIGGER ALL;

INSERT INTO universal.studenti VALUES ('4df9bf9d-41e1-4155-894b-f8808f8167eb', 100025, 1);
INSERT INTO universal.studenti VALUES ('d321fd61-9eb7-4b3e-b417-8ed291a52d26', 100026, 2);
INSERT INTO universal.studenti VALUES ('32f28203-8362-4bb3-976d-ef8940136157', 100028, 1);
INSERT INTO universal.studenti VALUES ('f117ca3d-82b7-4512-accc-7c04d1191250', 100033, 2);
INSERT INTO universal.studenti VALUES ('cdd9ef84-c4d1-4540-b792-662d0ccb97fc', 100034, 1);
INSERT INTO universal.studenti VALUES ('c4e34657-637d-4ad1-9651-4fa84d35d6d3', 100029, 3);
INSERT INTO universal.studenti VALUES ('7b4bd4c8-268e-42c3-864b-862f1283604c', 100037, 2);
INSERT INTO universal.studenti VALUES ('e546a150-2581-4265-8ce3-557c79bdd498', 100036, 3);
INSERT INTO universal.studenti VALUES ('5ee6969b-4ed4-4a97-b962-7d8c06082194', 100032, 3);
INSERT INTO universal.studenti VALUES ('72b30203-f0f7-4a10-87f9-ca9c0779d69c', 100031, 2);
INSERT INTO universal.studenti VALUES ('7a083611-db98-40c7-9be2-d805ec343906', 100030, 3);
INSERT INTO universal.studenti VALUES ('7ffe9ae9-f3d9-49b2-ad61-85bf83b40986', 100035, 3);
INSERT INTO universal.studenti VALUES ('c485f691-04b5-42a6-9c3e-e99865516df4', 100040, 2);
INSERT INTO universal.studenti VALUES ('c4a3cc4b-b101-474c-96a2-151f486db9b5', 100041, 1);
INSERT INTO universal.studenti VALUES ('b60c089e-8075-4a60-9859-ec33b135b8b9', 100039, 3);


ALTER TABLE universal.studenti ENABLE TRIGGER ALL;

--
-- Name: appelli_codice_seq; Type: SEQUENCE SET; Schema: universal; Owner: -
--

SELECT pg_catalog.setval('universal.appelli_codice_seq', 40, true);


--
-- Name: corsi_di_laurea_codice_seq; Type: SEQUENCE SET; Schema: universal; Owner: -
--

SELECT pg_catalog.setval('universal.corsi_di_laurea_codice_seq', 16, true);


--
-- Name: insegnamenti_codice_seq; Type: SEQUENCE SET; Schema: universal; Owner: -
--

SELECT pg_catalog.setval('universal.insegnamenti_codice_seq', 15, true);


--
-- PostgreSQL database dump complete
--

