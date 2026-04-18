-- Seed: Known Mestre/Belén/Echevarría/López/Manning family members
-- Updated: April 17, 2026 (v3 — paternal line added; Pedro Mestre corrected to Ponce)
-- Sources: FamilySearch L812-RM7, primary birth/death/marriage certificates,
--   1872 Slave Registry, Ancestry.com, user oral history,
--   UCL Legacies of British Slavery (Manning & Anderdon / Trinidad)
-- All Spanish records translated and confirmed against originals.

-- ============================================================
-- PLACES
-- ============================================================
insert into places (id, name, municipality, region, country, barrio) values
  ('a1000000-0000-0000-0000-000000000001', 'Yauco',          'Yauco',   'Southwestern', 'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000002', 'Guánica',        'Guánica', 'Southwestern', 'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000003', 'Barrio Carenero','Guánica', 'Southwestern', 'Puerto Rico', 'Carenero'),
  ('a1000000-0000-0000-0000-000000000004', 'Peñuelas',       'Peñuelas','Southwestern', 'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000005', 'Ponce',          'Ponce',   'South',        'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000006', 'Calle Victoria, Guánica', 'Guánica', 'Southwestern', 'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000007', 'Calle Dr. Veve, Guánica', 'Guánica', 'Southwestern', 'Puerto Rico', null),
  ('a1000000-0000-0000-0000-000000000008', 'Tunapuna',       'Tunapuna-Piarco', 'Central Trinidad', 'Trinidad and Tobago', null),
  ('a1000000-0000-0000-0000-000000000009', 'New York City',  'New York', 'New York', 'United States', null),
  ('a1000000-0000-0000-0000-000000000010', 'Mississippi',    null,       'Deep South', 'United States', null),
  ('a1000000-0000-0000-0000-000000000011', 'Calle Santa Rosa, Guánica', 'Guánica', 'Southwestern', 'Puerto Rico', null);

-- ============================================================
-- PEOPLE — GENERATION 0: Primary Researcher
-- ============================================================
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000001',
   'Keith', 'Manning', null,
   'male', '12 Jun 1991', 'exact', 'confirmed', true,
   'Primary researcher — Keith David Manning Jr.');

-- ============================================================
-- GENERATION 1: Parents
-- ============================================================
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000002',
   'Virginia', 'Mestre', null,
   'female', '21 Jul 1967', 'exact', 'confirmed', true,
   'Mother of Keith Manning Jr. Maiden name: Virginia Mestre.');

-- ============================================================
-- GENERATION 2: Grandparents
-- ============================================================
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000003',
   'Silvia', 'Belén', null,
   'female', '~1 Jul 1940', 'estimated', 'confirmed', true,
   'Maternal grandmother. BELÉN IS HER PATERNAL SURNAME — her father''s last name was Belén. Married Pedro Mestre. Lived in Guánica / Barrio Carenero, Puerto Rico. Born approximately July 1–2, 1940. Father''s first name unknown.'),

  ('b1000000-0000-0000-0000-000000000004',
   'Pedro', 'Mestre', null,
   'male', null, 'unknown', 'confirmed', true,
   'Maternal grandfather. Full name unknown — likely Pedro Mestre [maternal surname TBD]. Son of Pedro Mestre Vázquez (1889–1962). Died when Keith was approximately 12 years old. Born est. 1915–1945. USER CONFIRMED: He is from Ponce, Puerto Rico. Search Ponce civil records and 1920/1930/1940 census under Pedro Mestre Vázquez household.');

-- ============================================================
-- GENERATION 3: Great-grandparents
-- ============================================================

-- Mestre line
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, death_date, death_date_confidence, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000010',
   'Pedro', 'Mestre', 'Vázquez',
   'male', '1889', 'approximate', '1962', 'approximate',
   'confirmed', true,
   'Great-grandfather. CONFIRMED FamilySearch record: profile L812-RM7. Born 1889, died 1962. Maternal surname Vázquez (his mother was a Vázquez woman). Father of Keith''s grandfather (Pedro Mestre). His own father (great-great-grandfather) was reportedly still alive during Keith''s grandfather''s lifetime.');

-- Echevarría/López line — María Inés confirmed from birth certificate
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, death_date, death_date_confidence, birth_place_id, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000005',
   'María Inés', 'López', 'Echevarría',
   'female', '28 Apr 1912', 'exact', null, 'unknown',
   'a1000000-0000-0000-0000-000000000002',
   'confirmed', true,
   'Great-grandmother line. CONFIRMED from ACTA DE NACIMIENTO (birth certificate): born April 28, 1912, declared May 1, 1912 in Guánica, P.R. (Folio 14, Number 14). Father: Eustaquio López y Ortiz (~22, bracero, Yauco, son of Elías López + Juana Ortiz). Mother: Benigna Echevarría (declarant). Maternal grandparents listed: Pedro Villa (natural de Yauco, Calle Victoria) and Dolores Echevarría (natural de Yauco, Calle Victoria). Died 2013 per oral history, aged 101.');

-- ============================================================
-- GENERATION 4: Great-great-grandparents
-- ============================================================

-- Mestre line
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000011',
   'Unknown', 'Mestre', null,
   'male', 'possible', false,
   'Great-great-grandfather. Father of Pedro Mestre Vázquez (1889–1962). First name unknown. Reportedly still alive during Keith''s grandfather''s lifetime. Search: Yauco civil/church records for a Mestre patriarch born est. 1850–1870.'),

  ('b1000000-0000-0000-0000-000000000012',
   'Unknown', 'Vázquez', null,
   'female', 'possible', false,
   'Great-great-grandmother. Mother of Pedro Mestre Vázquez (1889–1962). Maternal surname Vázquez is confirmed by his full name. First name unknown. Search: Yauco civil records ~1860–1890 for a Vázquez woman who married a Mestre man.');

-- Echevarría/López line
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, death_date, death_date_confidence, birth_place_id, confidence, is_anchor, racial_status_historical, notes) values
  ('b1000000-0000-0000-0000-000000000006',
   'Benigna', 'Echevarría', null,
   'female', '13 Mar 1888', 'exact', '19 Jul 1981', 'exact',
   'a1000000-0000-0000-0000-000000000002',
   'confirmed', true, 'Mulata',
   'CONFIRMED from death certificate (No. 152, 1981, Register 0232, Cert 659). Born March 13, 1888 (Guánica or Yauco area). Died July 19, 1981, age 93, at Ponce hospital. Race (1907 marriage record): mulata. Usual residence: Casón Ochoa #47, Guánica. Mother: Dolores Echevarría (natural de Guánica). Father: Pedro Villa (natural de Yauco, Calle Victoria) — confirmed from María Inés''s 1912 birth certificate listing Pedro Villa + Dolores Echevarría as maternal grandparents. Married: Eustaquio López y Ortiz, June 16, 1907, Yauco. Informant at death: Margarita Toro López (nieta/granddaughter). Buried July 20, 1981, Municipal Cemetery Guánica. Cause: Cerebral Thrombosis / Aspiration Pneumonia.'),

  ('b1000000-0000-0000-0000-000000000015',
   'Eustaquio', 'López', 'Ortiz',
   'male', '~1885', 'estimated', null, 'unknown',
   'a1000000-0000-0000-0000-000000000001',
   'confirmed', true, 'Trigueño',
   'CONFIRMED from 1907 marriage record and 1912 birth certificate. Full name: Eustaquio López y Ortiz. Age 22 at marriage (June 16, 1907) = born approximately 1884–1885. Race: trigueño. Occupation: bracero (sugar cane field worker). Natural de Yauco; resident Calle Victoria de Guánica at time of daughter''s birth (1912). Signed marriage record as "Eustaquio Looper." Father: Elías López (natural de Peñuelas). Mother: Juana Ortiz (natural de Yauco, recorded as "Juana Orta" in marriage record). Married Benigna Echevarría June 16, 1907 in Yauco. Father of María Inés López Echevarría (b. 1912) and Pedro Juan López Echevarria (b. 1919).');

-- ============================================================
-- GENERATION 5: 3× great-grandparents
-- ============================================================
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, death_date, death_date_confidence, birth_place_id, confidence, is_anchor, racial_status_historical, notes) values
  ('b1000000-0000-0000-0000-000000000007',
   'Dolores', 'Echevarría', null,
   'female', '1864', 'approximate', '10 Dec 1950', 'exact',
   'a1000000-0000-0000-0000-000000000002',
   'confirmed', true, 'Mulata',
   'CONFIRMED from death certificate No. 143, District 27, Guánica. Born 1864, Guánica. Died December 10, 1950, 8 PM, Barrio Carenero, Guánica, P.R. Age 86. Race: Mulata. Widow. Mother: María Echevarría (natural de Guánica, P.R.). Father: unknown. Informant: Francisco López (nieto/grandson). Cause: Cardiovascular disease. She is Benigna Echevarría''s mother — confirmed by 1907 marriage record AND Benigna''s 1981 death certificate. Born only ~9 years after abolition (1873), she was almost certainly enslaved as a child. Age 8 in 1872 slave registry (held by Juan Irizarry, per Gemini analysis).'),

  ('b1000000-0000-0000-0000-000000000018',
   'Pedro', 'Villa', null,
   'male', null, 'unknown', null, 'unknown',
   'a1000000-0000-0000-0000-000000000001',
   'confirmed', false, null,
   'CONFIRMED from María Inés López birth certificate (1912): listed as maternal grandfather alongside Dolores Echevarría. Natural de Yauco; address Calle Victoria, Guánica at time of 1912 birth. Father of Benigna Echevarría (with Dolores Echevarría). First name Pedro, paternal surname Villa. No further records found yet — search Yauco and Guánica civil records for Pedro Villa.');

-- López/Ortiz parents of Eustaquio
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, confidence, is_anchor, birth_place_id, notes) values
  ('b1000000-0000-0000-0000-000000000016',
   'Elías', 'López', null,
   'male', 'confirmed', false,
   'a1000000-0000-0000-0000-000000000004',
   'CONFIRMED from 1907 marriage record and María Inés 1912 birth certificate. Natural de Peñuelas. Father of Eustaquio López y Ortiz. Paternal grandfather of María Inés López Echevarría. No further records found yet.'),

  ('b1000000-0000-0000-0000-000000000017',
   'Juana', 'Ortiz', null,
   'female', 'confirmed', false,
   'a1000000-0000-0000-0000-000000000001',
   'CONFIRMED from 1907 marriage record (recorded as "Juana Orta") and María Inés 1912 birth certificate (Juana Ortiz). Natural de Yauco. Mother of Eustaquio López y Ortiz. Paternal grandmother of María Inés López Echevarría.');

-- ============================================================
-- GENERATION 6: 4× great-grandparents
-- ============================================================
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, death_date, death_date_confidence, birth_place_id, confidence, is_anchor, racial_status_historical, notes) values
  ('b1000000-0000-0000-0000-000000000008',
   'María', 'Almodovar', 'Echevarría',
   'female', '~1818', 'estimated', '17 Jan 1928', 'exact',
   'a1000000-0000-0000-0000-000000000002',
   'confirmed', true, 'Negra',
   'CONFIRMED from death certificate No. 409, January 17, 1928, 10:30 PM, Calle Dr. Veve, Guánica, P.R. Age at death: 110 years (ciento diez) → born ~1818. Race: Negra. Widow. Born: Guánica, P.R. Occupation: Labores domésticas (domestic labor). Declarant: Ventura Echevarría (en su carácter de hijo — in his role as son). Witnesses: Pedro Vázquez (Agricultor, Sabana Grande) and José Vázquez (Bracero, Sabana Grande) — NOTE: Vázquez witnesses from Sabana Grande may connect to the Vázquez maternal line of Pedro Mestre Vázquez. Parents: unknown to declarant. Certified by Dr. J. García Quevedo. Mother of Dolores Echevarría (b. 1864). Born approximately 45 years before abolition (1873). Almost certainly enslaved for most of her life. Survived to 110.'),

  ('b1000000-0000-0000-0000-000000000019',
   'María', 'Echevarría', null,
   'female', null, 'unknown', null, 'unknown',
   'a1000000-0000-0000-0000-000000000002',
   'confirmed', false, null,
   'CONFIRMED from Dolores Echevarría death certificate (1950, No. 143): listed as Dolores''s mother. Natural de Guánica, P.R. Mother of Dolores Echevarría (b. 1864). Grandmother of Benigna Echevarría. This makes her a daughter or daughter-in-law of María Almodovar Echevarría, OR she may be the same person recorded with a different first name. Research note: "María Echevarría natural de Guánica" and "María Almodovar Echevarría born ~1818 Guánica" — these could be the same person if the Almodovar surname was dropped in later records, OR María Echevarría could be a daughter of María Almodovar. Needs resolution.');

-- ============================================================
-- PEOPLE — CONFIRMED OTHER INDIVIDUALS
-- ============================================================

-- Ventura Echevarría (son of María Almodovar, death declarant)
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000020',
   'Ventura', 'Echevarría', null,
   'male', 'confirmed', false,
   'CONFIRMED from María Almodovar death certificate (Jan 17, 1928): declared her death as her son ("en su carácter de hijo"). Son of María Almodovar Echevarría (~1818–1928). Surname Echevarría inherited from his mother. Sibling of or generationally related to Dolores Echevarría — both carry Echevarría and are connected to María Almodovar. No birth date or further records found yet.');

-- Pedro Juan López Echevarria (Benigna's confirmed son, 1919)
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, death_date, death_date_confidence, birth_place_id, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000013',
   'Pedro Juan', 'López', 'Echevarría',
   'male', '22 Oct 1919', 'exact', '2008', 'approximate',
   'a1000000-0000-0000-0000-000000000002',
   'confirmed', false,
   'CONFIRMED RECORD: born October 22, 1919, Guánica, Puerto Rico. Died 2008. Source: ancestry.com/genealogy/records/pedro-juan-lópez-echevarria-24-139kgqd. Mother: Benigna Echevarría (confirmed). Father: Eustaquio López y Ortiz (same father as María Inés). His double surname (López + Echevarría) mirrors María Inés López Echevarría — they are siblings, sharing both parents.');

-- Don Juan Irizarry (slave owner)
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000009',
   'Juan', 'Irizarry', null,
   'male', 'confirmed', false,
   'CONFIRMED from 1872 Slave Registry: listed as enslaver in Yauco District 5. Enslaved persons under his estate included Felipe (#1185, age 52, pardo, natural de Pto Rico) and Dolores (age 8 in 1872 = born ~1864 = likely Dolores Echevarría). The Echevarría surname in this family may derive from a prior enslaver named Echevarría; Irizarry is the documented 1872 enslaver. Family had documented land presence in Yauco ("Sector Primitivo Irizarry" is a named location there). Record: FamilySearch Catalog #177782 or Ancestry collection 2774, Yauco District 5.');

-- Felipe (enslaved person, 1872 slave registry)
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, confidence, is_anchor, racial_status_historical, notes) values
  ('b1000000-0000-0000-0000-000000000021',
   'Felipe', null, null,
   'male', '~1820', 'estimated',
   'confirmed', false, 'Pardo',
   'CONFIRMED from 1872 Slave Registry page 297, entry #1185. Age listed as 52 in 1872 → born approximately 1820. Enslaved by Dª Juana / Dn Juan Irizarry, Yauco, Puerto Rico. Race: Pardo. Natural de Pto Rico. Possibly Dolores Echevarría''s father (both enslaved by Irizarry; Dolores born 1864, matching an enslaved woman under Irizarry household). No surname — enslaved persons recorded by first name only until emancipation 1873, when surnames were adopted. May be the Felipe Echevarría referenced in Gemini analysis timeline as María Almodovar''s partner.');

-- ============================================================
-- EARLY ECHEVARRÍA IN REGION (extended record search)
-- ============================================================
insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, death_date, death_date_confidence, birth_place_id, confidence, is_anchor, notes) values
  ('b1000000-0000-0000-0000-000000000014',
   'Gregorio', 'Echevarría', 'Troche',
   'male', '~1770', 'estimated', '4 Dec 1820', 'exact',
   'a1000000-0000-0000-0000-000000000004',
   'possible', false,
   'Born ~1770 Peñuelas PR (borders Yauco to northeast), died Dec 4 1820. Mother: Gregoria Echevarría Y Troche. Spouse: Dorotea Ortiz. Source: ancestry.com/genealogy/records/gregorio-echevarría-24-1cwnls9. Establishes Echevarría surname in Yauco region going back to ~1770 — over 100 years before abolition. May be ancestor of the free or enslaving Echevarría family.');

-- ============================================================
-- RELATIONSHIPS
-- ============================================================
insert into relationships (person_a_id, person_b_id, relationship_type, confidence, notes) values

  -- ── Gen 1 → 0 ──────────────────────────────────────────────
  ('b1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
   'parent', 'confirmed', 'Virginia Mestre is mother of Keith Manning Jr.'),

  -- ── Gen 2 → 1 ──────────────────────────────────────────────
  ('b1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
   'parent', 'confirmed', 'Silvia Belén is mother of Virginia Mestre'),
  ('b1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
   'parent', 'confirmed', 'Pedro Mestre (grandfather) is father of Virginia Mestre'),

  -- ── Gen 2 couple ───────────────────────────────────────────
  ('b1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
   'spouse', 'confirmed', 'Silvia Belén and Pedro Mestre — confirmed couple'),

  -- ── Gen 3 → 2 ──────────────────────────────────────────────
  ('b1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000004',
   'parent', 'confirmed', 'Pedro Mestre Vázquez (1889–1962) is father of Keith''s grandfather Pedro Mestre. Confirmed via FamilySearch L812-RM7.'),

  -- ── Gen 4 → 3 (Mestre) ─────────────────────────────────────
  ('b1000000-0000-0000-0000-000000000011', 'b1000000-0000-0000-0000-000000000010',
   'parent', 'possible', 'Unknown Mestre patriarch is father of Pedro Mestre Vázquez. First name unknown.'),
  ('b1000000-0000-0000-0000-000000000012', 'b1000000-0000-0000-0000-000000000010',
   'parent', 'possible', 'Unknown Vázquez woman is mother of Pedro Mestre Vázquez. Confirmed by his maternal surname.'),

  -- ── Gen 4 → 3 (Echevarría/López) ──────────────────────────
  -- Benigna is mother of María Inés (CONFIRMED from birth cert)
  ('b1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000005',
   'parent', 'confirmed', 'Benigna Echevarría is mother of María Inés López Echevarría. Confirmed from 1912 ACTA DE NACIMIENTO — Benigna is listed as declarant (en su carácter de madre).'),

  -- Eustaquio is father of María Inés (CONFIRMED from birth cert)
  ('b1000000-0000-0000-0000-000000000015', 'b1000000-0000-0000-0000-000000000005',
   'parent', 'confirmed', 'Eustaquio López y Ortiz is father of María Inés López Echevarría. Confirmed from 1912 ACTA DE NACIMIENTO.'),

  -- Eustaquio married Benigna (CONFIRMED from 1907 marriage record)
  ('b1000000-0000-0000-0000-000000000015', 'b1000000-0000-0000-0000-000000000006',
   'spouse', 'confirmed', 'Married June 16, 1907, Yauco, Puerto Rico. Marriage certificate confirms both names, ages, and parents.'),

  -- Benigna + Eustaquio are parents of Pedro Juan (CONFIRMED)
  ('b1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000013',
   'parent', 'confirmed', 'Benigna Echevarría is mother of Pedro Juan López Echevarria (b. 1919, Guánica). Confirmed from Ancestry record.'),
  ('b1000000-0000-0000-0000-000000000015', 'b1000000-0000-0000-0000-000000000013',
   'parent', 'confirmed', 'Eustaquio López y Ortiz is father of Pedro Juan López Echevarria — both children carry his López paternal surname.'),

  -- ── Gen 5 → 4 ──────────────────────────────────────────────
  -- Dolores is mother of Benigna (CONFIRMED from 1907 marriage rec + 1981 death cert)
  ('b1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000006',
   'parent', 'confirmed', 'Dolores Echevarría is mother of Benigna Echevarría. Confirmed from: (1) 1907 marriage record — only Dolores Echevarría listed as Benigna''s mother, no father (natural child); (2) Benigna''s 1981 death certificate — mother''s maiden name = Dolores Echevarría, natural de Guánica.'),

  -- Pedro Villa is father of Benigna (CONFIRMED from María Inés birth cert)
  ('b1000000-0000-0000-0000-000000000018', 'b1000000-0000-0000-0000-000000000006',
   'parent', 'confirmed', 'Pedro Villa is father of Benigna Echevarría. Confirmed from María Inés López 1912 birth certificate: maternal grandparents listed as "Pedro Villa (natural de Yauco, Calle Victoria)" and "Dolores Echevarría (natural de Yauco, Calle Victoria)."'),

  -- Elías López is father of Eustaquio
  ('b1000000-0000-0000-0000-000000000016', 'b1000000-0000-0000-0000-000000000015',
   'parent', 'confirmed', 'Elías López is father of Eustaquio López y Ortiz. Confirmed from 1907 marriage record and 1912 birth certificate.'),

  -- Juana Ortiz is mother of Eustaquio
  ('b1000000-0000-0000-0000-000000000017', 'b1000000-0000-0000-0000-000000000015',
   'parent', 'confirmed', 'Juana Ortiz (Orta) is mother of Eustaquio López y Ortiz. Confirmed from 1907 marriage record (recorded as Juana Orta) and 1912 birth certificate.'),

  -- ── Gen 6 → 5 ──────────────────────────────────────────────
  -- María Echevarría is mother of Dolores (CONFIRMED from death cert)
  ('b1000000-0000-0000-0000-000000000019', 'b1000000-0000-0000-0000-000000000007',
   'parent', 'confirmed', 'María Echevarría is mother of Dolores Echevarría. Confirmed from Dolores'' 1950 death certificate (No. 143): madre = "María Echevarría, Natural de Guánica P.R."'),

  -- María Almodovar is mother of Ventura Echevarría (CONFIRMED from death cert)
  ('b1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000020',
   'parent', 'confirmed', 'María Almodovar Echevarría is mother of Ventura Echevarría. Confirmed from her 1928 death certificate: Ventura Echevarría declared her death "en su carácter de hijo."'),

  -- Research connection: María Echevarría and María Almodovar Echevarría (same person?)
  ('b1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000019',
   'other', 'possible', 'OPEN QUESTION: María Almodovar Echevarría (~1818–1928) and "María Echevarría" (listed as Dolores''s mother in 1950 death cert) may be the same person — both are María Echevarría, both natural de Guánica. Almodovar may have been dropped in later records. OR: María Echevarría is a daughter of María Almodovar (which would make Dolores a granddaughter, not daughter). Needs resolution via civil/church records.');

-- ============================================================
-- EVENTS — Primary source confirmed events
-- ============================================================
insert into events (person_id, event_type, event_date, event_date_confidence, place_id, description, confidence) values

  -- María Almodovar Echevarría
  ('b1000000-0000-0000-0000-000000000008',
   'birth', '~1818', 'estimated', 'a1000000-0000-0000-0000-000000000002',
   'Estimated birth ~1818 based on age 110 at death (January 17, 1928). Born Guánica, Puerto Rico.',
   'confirmed'),

  ('b1000000-0000-0000-0000-000000000008',
   'death', '17 Jan 1928', 'exact', 'a1000000-0000-0000-0000-000000000007',
   'Death of María Almodovar Echevarría, January 17, 1928, 10:30 PM, Calle Dr. Veve, Guánica, P.R. Age 110. Race: Negra. Cause: Vejez (old age). Declared by son Ventura Echevarría. Witnesses: Pedro Vázquez and José Vázquez (both from Sabana Grande). Certificate No. 409. Certified by Dr. J. García Quevedo.',
   'confirmed'),

  -- Dolores Echevarría
  ('b1000000-0000-0000-0000-000000000007',
   'birth', '1864', 'approximate', 'a1000000-0000-0000-0000-000000000002',
   'Born 1864, Guánica, Puerto Rico. Born into slavery — approximately 9 years before abolition (1873). Age 8 in 1872 slave registry (per Gemini analysis of Irizarry household). Confirmed from death certificate.',
   'confirmed'),

  ('b1000000-0000-0000-0000-000000000007',
   'death', '10 Dec 1950', 'exact', 'a1000000-0000-0000-0000-000000000003',
   'Death of Dolores Echevarría, December 10, 1950, 8 PM, Barrio Carenero, Guánica, P.R. Age 86. Race: Mulata. Cause: Cardiovascular disease. Informant: Francisco López (grandson/nieto). Certificate No. 143, District 27.',
   'confirmed'),

  -- Benigna Echevarría
  ('b1000000-0000-0000-0000-000000000006',
   'birth', '13 Mar 1888', 'exact', 'a1000000-0000-0000-0000-000000000002',
   'Born March 13, 1888. Guánica (or Yauco) area. Confirmed from 1981 death certificate.',
   'confirmed'),

  ('b1000000-0000-0000-0000-000000000006',
   'marriage', '16 Jun 1907', 'exact', 'a1000000-0000-0000-0000-000000000001',
   'Marriage of Benigna Echevarría (age 18, mulata, doméstica) to Eustaquio López y Ortiz (age 22, trigueño, bracero). Married June 16, 1907 in Yauco, Puerto Rico. Officiated by G. Vugle (Sacerdote). Benigna''s mother: Dolores Echevarría. Father: not listed (natural child). Eustaquio''s parents: Elías López + Juana Ortiz (Orta). Benigna signed or marked the marriage record.',
   'confirmed'),

  ('b1000000-0000-0000-0000-000000000006',
   'death', '19 Jul 1981', 'exact', 'a1000000-0000-0000-0000-000000000005',
   'Death of Benigna Echevarría July 19, 1981, Ponce hospital, Puerto Rico. Age 93. Race: listed as Blanco on 1981 certificate (racial classifications had changed by 1981). Usual residence: Casón Ochoa #47, Guánica. Cause: Cerebral Thrombosis + Aspiration Pneumonia. Informant: Margarita Toro López (granddaughter/nieta). Buried July 20, 1981, Municipal Cemetery Guánica. Certificate No. 152.',
   'confirmed'),

  -- María Inés López Echevarría
  ('b1000000-0000-0000-0000-000000000005',
   'birth', '28 Apr 1912', 'exact', 'a1000000-0000-0000-0000-000000000002',
   'Born April 28, 1912, declared May 1, 1912, Guánica, P.R. ACTA DE NACIMIENTO Folio 14, Number 14. Father: Eustaquio López y Ortiz (~22, bracero, Yauco, Calle Victoria Guánica). Mother: Benigna Echevarría (declarant). Paternal grandparents: Elías López (natural de Peñuelas) + Juana Ortiz (natural de Yauco). Maternal grandparents: Pedro Villa (natural de Yauco, Calle Victoria) + Dolores Echevarría (natural de Yauco, Calle Victoria). Witnesses: Ramón Sánchez (Carpintero, Ponce) + Luis Antonio Palermo.',
   'confirmed'),

  -- Pedro Juan López Echevarria
  ('b1000000-0000-0000-0000-000000000013',
   'birth', '22 Oct 1919', 'exact', 'a1000000-0000-0000-0000-000000000002',
   'Born October 22, 1919, Guánica, Puerto Rico. Mother: Benigna Echevarría. Source: Ancestry genealogy record.',
   'confirmed'),

  -- Pedro Mestre Vázquez
  ('b1000000-0000-0000-0000-000000000010',
   'birth', '1889', 'approximate', 'a1000000-0000-0000-0000-000000000001',
   'Born 1889. Location estimated as Yauco area based on family geography. Confirmed year from FamilySearch profile L812-RM7.',
   'confirmed'),

  ('b1000000-0000-0000-0000-000000000010',
   'death', '1962', 'approximate', null,
   'Died 1962. Location unknown. Confirmed year from FamilySearch profile L812-RM7.',
   'confirmed'),

  -- 1872 Slave Registry event — Felipe
  ('b1000000-0000-0000-0000-000000000021',
   'census', '1872', 'exact', 'a1000000-0000-0000-0000-000000000001',
   '1872 Puerto Rico Slave Registry, page 297, entry #1185. Recorded as enslaved by Dª Juana / Dn Juan Irizarry, Yauco, Puerto Rico. Age 52, pardo, natural de Pto Rico. Source: FamilySearch Catalog #177782 (Registro Central de Esclavos).',
   'confirmed'),

  -- Eustaquio López y Ortiz — marriage
  ('b1000000-0000-0000-0000-000000000015',
   'marriage', '16 Jun 1907', 'exact', 'a1000000-0000-0000-0000-000000000001',
   'Married Benigna Echevarría, June 16, 1907, Yauco, Puerto Rico. Signed marriage record as "Eustaquio Looper." Age 22, trigueño, bracero. Parents: Elías López (Peñuelas) + Juana Ortiz (Yauco, recorded as Juana Orta).',
   'confirmed');

-- ============================================================
-- RESEARCH TASKS — Updated priorities based on document analysis
-- ============================================================
insert into research_tasks (title, description, priority, status) values

  ('Pull full FamilySearch profile for Pedro Mestre Vázquez (L812-RM7)',
   'Access ancestors.familysearch.org/en/L812-RM7/pedro-mestre-vázquez-1889-1962. Extract: exact birth location, death location, parents'' names (especially his mother''s first name — she was a Vázquez). This unlocks the generation above the confirmed great-grandfather and may explain the Vázquez witnesses at María Almodovar''s 1928 death (Pedro Vázquez + José Vázquez from Sabana Grande).',
   'high', 'todo'),

  ('Search 1920 and 1930 US Census for Pedro Mestre Vázquez household',
   'Pedro Mestre Vázquez born 1889 — age ~31 in 1920, ~41 in 1930. His son (Keith''s grandfather) should appear as a child. Search FamilySearch census collection for "Pedro Mestre" in Yauco or Guánica, Puerto Rico. The son''s full name and birth year are the target.',
   'high', 'todo'),

  ('Find birth record for Keith''s grandfather (son of Pedro Mestre Vázquez)',
   'Keith''s grandfather Pedro Mestre born est. 1915–1945. Search Guánica and Yauco civil birth records (FamilySearch collection 1682798) for a child named Pedro Mestre born to Pedro Mestre Vázquez. Also check Guánica church records (San Antonio Abad, HijosdeCoamoPR index 1885–1944).',
   'high', 'todo'),

  ('Find Silvia Belén marriage record to confirm her parents',
   'Silvia Belén''s marriage to Pedro Mestre (grandfather) should be in Guánica civil records post-1914, or Yauco records if married before 1914. The marriage record will give: her full double surname, and her parents'' names. Her father''s first name is currently unknown — his surname was Belén.',
   'high', 'todo'),

  ('Resolve: Is María Echevarría (Dolores''s mother) the same person as María Almodovar Echevarría?',
   'CRITICAL DISAMBIGUATION: Dolores''s 1950 death cert lists mother as "María Echevarría, natural de Guánica." María Almodovar Echevarría (~1818–1928) is also natural de Guánica. Two possibilities: (A) same person — Almodovar surname dropped in later records; (B) different people — María Echevarría is a daughter of María Almodovar, making Dolores her granddaughter. If (B), add a generation. Search Guánica civil/church records for births to María Almodovar Echevarría and any child named María.',
   'high', 'todo'),

  ('Search Guánica church records (San Antonio Abad) 1888–1941 via HijosdeCoamoPR',
   'Guánica had its own church from ~1888 — BEFORE the 1914 municipal separation. Index at hijosdecoamopr.com/guanica-puerto-rico-church-indexes-1885-1944/. Search for: Echevarría, Mestre, Belén, López, Almodovar, Villa. Family in Barrio Carenero after 1888 may appear here rather than Yauco''s records.',
   'high', 'todo'),

  ('Search 1872 Registro de Esclavos for Yauco District 5, master = Irizarry',
   'Access FamilySearch Catalog #177782 or Ancestry collection 2774. Filter Yauco (District 5). Master name = Irizarry. Confirm Felipe (#1185, age 52, pardo) and identify any Dolores (age ~8, born ~1864) in the same household. Any enslaved person under Irizarry is a potential direct ancestor. Also note full name of enslaver (Dª Juana / Dn Juan Irizarry).',
   'high', 'todo'),

  ('Search for Eustaquio López y Ortiz''s father Elías López in Peñuelas records',
   'Elías López confirmed as natural de Peñuelas (from 1907 marriage + 1912 birth cert). Search Peñuelas civil records and church records for Elías López. His wife Juana Ortiz (natural de Yauco) should also appear in Yauco records. This extends the paternal López line beyond the confirmed generation.',
   'medium', 'todo'),

  ('Search for Pedro Villa in Yauco/Guánica civil records',
   'Pedro Villa confirmed as father of Benigna Echevarría (from 1912 birth cert of María Inés). Natural de Yauco, address Calle Victoria, Guánica circa 1912. Search Yauco and Guánica civil records 1880–1912 for Pedro Villa. Marriage record with Dolores Echevarría would be particularly valuable. Note: his surname Villa may indicate free status before abolition.',
   'medium', 'todo'),

  ('Investigate Vázquez witnesses at María Almodovar death (1928)',
   'Death certificate witnesses: Pedro Vázquez (Agricultor, Sabana Grande) and José Vázquez (Bracero, Sabana Grande). Pedro Mestre Vázquez (1889–1962, great-grandfather) has Vázquez maternal surname. Sabana Grande borders Yauco. These could be relatives of the same Vázquez family. Search Sabana Grande civil records for Pedro Vázquez and José Vázquez circa 1928.',
   'medium', 'todo'),

  ('Search Yauco church records (FamilySearch #277991) for Echevarría baptisms 1840–1885',
   'Pre-civil-registration records. Access FamilySearch Catalog #277991 (Santísimo Rosario, Yauco, 1751–1962). Use HijosdeCoamoPR Yauco index. Search for: María Almodovar Echevarría children (Ventura, Dolores, etc.), any Echevarría baptisms 1840–1880. Godparent names extend the research network.',
   'medium', 'todo'),

  ('Research Almodovar + Irizarry connection — María Soledad Almodovar e Irizarry',
   'A "María Soledad Almodovar e Irizarry" was found — maternal surname = Irizarry. This could be a sibling or variant of "María Almodovar Echevarría." Both carried Almodovar as paternal surname. Different mothers (Irizarry vs Echevarría) would mean same Almodovar father by different women. Search Yauco civil/church records for Almodovar family and Almodovar + Irizarry or + Echevarría marriages.',
   'medium', 'todo'),

  ('Search for Vázquez branch — mother of Pedro Mestre Vázquez',
   'Pedro Mestre Vázquez (1889) maternal surname = Vázquez. His mother was a Vázquez woman, born ~1860–1870, Yauco area. Search Yauco civil records 1885–1895 for a Vázquez woman married to a Mestre man, or a birth record for Pedro Mestre born to a Vázquez mother.',
   'medium', 'todo'),

  ('Confirm Margarita Toro López identity (Benigna''s granddaughter, 1981 informant)',
   'Benigna''s 1981 death was declared by Margarita Toro López (nieta), Casón Ochoa #47, Guánica. Toro = her paternal surname, López = maternal (from the López line). She is a grandchild of Benigna and Eustaquio. Find which of their children was Margarita''s parent. This may connect to Virginia Mestre''s line.',
   'low', 'todo'),

  -- ── PATERNAL LINE RESEARCH TASKS ────────────────────────────

  ('Search Social Security Death Index for Gracie Manning/Dudley — NYC early 2000s',
   'Gracie Manning (also known as Gracie Dudley) died in New York City in the early 2000s. She was possibly from Mississippi. Search the Social Security Death Index on FamilySearch or Ancestry for "Gracie Manning" or "Gracie Dudley" with state of death = New York, death year 2000–2006. The SSN will unlock her birth state (Mississippi?) and birth year, which opens the census trail.',
   'high', 'todo'),

  ('Search Trinidad Royal Navy records for Willard Manning (Tunapuna)',
   'Willard Manning served in the Trinidad Royal Navy. Search National Archives of Trinidad (natt.gov.tt) for service records under "Willard Manning." Also check: Caribbean Obituary Index 2003–2019 on Ancestry. He died in or around Tijuana, Mexico, 2011 or 2012. Search Mexican civil registry for Baja California death records for Willard Manning 2011–2012.',
   'high', 'todo'),

  ('Search 1940 Census for Gracie Dudley in Mississippi',
   'Gracie Dudley was likely born ~1920–1935 based on her early 2000s death. In 1940 she would be approximately 5–20 years old. Search 1940 US Census for Mississippi for a "Gracie Dudley" or "Grace Dudley" in a Black/African American household. This will give her parents'' names and county, which determines which county records to search. Also search 1930 census.',
   'high', 'todo'),

  ('Search Trinidad Slave Registers 1813–1834 for Manning enslaver — Tunapuna area',
   'The Manning surname in Trinidad almost certainly comes from a Manning enslaver or the Manning & Anderdon merchant firm (documented in UCL Legacies of British Slavery for Trinidad). Search Ancestry Collection 1129 (Former British Colonial Dependencies Slave Registers, 1813–1834) for Trinidad, Tunapuna or surrounding area. Look for a Manning plantation owner. Also search ucl.ac.uk/lbs for "Manning" + Trinidad to identify the enslaving family.',
   'high', 'todo'),

  ('Search Ponce civil records for Pedro Mestre family',
   'Pedro Mestre (maternal grandfather) is confirmed from Ponce, Puerto Rico. His father Pedro Mestre Vázquez (1889–1962, FamilySearch L812-RM7) may also be from Ponce. Search FamilySearch Collection 1682798, municipality = Ponce, for Mestre family births, marriages, deaths. Also check Ponce church records: Nuestra Señora de Guadalupe (1753–1948) on FamilySearch. Also search 1920/1930 census for Pedro Mestre Vázquez household in Ponce.',
   'high', 'todo'),

  ('Search Freedmen''s Bank Records for Dudley and Manning in Mississippi',
   'If Gracie''s grandparents were enslaved in Mississippi, Freedmen''s Bank records (1865–1874) are the earliest free-person records. Search FamilySearch and Ancestry Freedmen''s Savings Bank records for "Dudley" and "Manning" in Mississippi branches (Vicksburg, Natchez). Records include: name, age, birthplace, former enslaver name, family members.',
   'medium', 'todo'),

  ('Search Ponce Records of Foreigners 1815–1845 for Catalan Mestre ancestors',
   'The Mestre surname is Catalan — the same Catalan migration wave that brought Sebastián Serrallés from Girona to Ponce in the 1830s. Search Ancestry Collection 3027 (Puerto Rico, Records of Foreigners, 1815–1845) for any Mestre entry in Ponce. Also search 1870 and 1880 Spanish colonial censuses (padrones) for Ponce — these recorded residents'' place of birth and would confirm Catalan origin of the Mestre patriarch.',
   'medium', 'todo');

-- ============================================================
-- PATERNAL LINE PEOPLE
-- ============================================================

insert into people (id, first_name, last_name_paternal, last_name_maternal, gender, birth_date, birth_date_confidence, confidence, is_anchor, notes) values
  ('b2000000-0000-0000-0000-000000000001',
   'Keith', 'Manning', null,
   'male', '12 Sep 1960', 'exact', 'confirmed', true,
   'Father of Keith David Manning Jr. Full name: Keith David Manning Sr. Born September 12, 1960. Son of Willard Manning (Trinidad) and Gracie Manning/Dudley (Mississippi/NYC).'),

  ('b2000000-0000-0000-0000-000000000002',
   'Willard', 'Manning', null,
   'male', null, 'unknown', 'confirmed', false,
   'Paternal grandfather of Keith Jr. Trinidadian national. From Tunapuna area, Trinidad. Served in the Trinidad Royal Navy. Died in or around Tijuana, Mexico, 2011 or 2012. Manning surname in Trinidad almost certainly adopted from British enslaver at 1838 emancipation (Manning & Anderdon is documented in UCL Legacies of British Slavery for Trinidad). No birth date confirmed. Search: Trinidad Caribbean Births Collection 1804229, Trinidad Royal Navy records, National Archives of Trinidad (natt.gov.tt).'),

  ('b2000000-0000-0000-0000-000000000003',
   'Gracie', 'Manning', null,
   'female', null, 'unknown', 'possible', false,
   'Paternal grandmother of Keith Jr. Also known as Gracie Dudley (maiden name or remarried surname — unclear). Possibly from Mississippi. Died in New York City, early 2000s (est. 2000–2006). African American family — Mississippi origins suggest Deep South lineage; migration to NYC consistent with Great Migration pattern. Dudley surname likely adopted from white enslaver named Dudley at 1865 emancipation. Search: Social Security Death Index (NYC death), 1940 census Mississippi, Freedmen''s Bank records Mississippi branches.');

-- Paternal line relationships
insert into relationships (person_a_id, person_b_id, relationship_type, confidence, notes) values
  ('b2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001',
   'parent', 'confirmed', 'Keith David Manning Sr. is father of Keith David Manning Jr.'),

  ('b2000000-0000-0000-0000-000000000002', 'b2000000-0000-0000-0000-000000000001',
   'parent', 'confirmed', 'Willard Manning (Trinidad) is father of Keith David Manning Sr.'),

  ('b2000000-0000-0000-0000-000000000003', 'b2000000-0000-0000-0000-000000000001',
   'parent', 'confirmed', 'Gracie Manning/Dudley (Mississippi/NYC) is mother of Keith David Manning Sr.'),

  ('b2000000-0000-0000-0000-000000000002', 'b2000000-0000-0000-0000-000000000003',
   'spouse', 'possible', 'Willard Manning and Gracie Manning — relationship produced Keith David Manning Sr. May or may not have been formally married.');
