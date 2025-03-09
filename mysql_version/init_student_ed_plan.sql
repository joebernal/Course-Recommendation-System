PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE major_courses(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO major_courses VALUES(1,'CS 225','Object Oriented Programming','3','Prerequisite(s):  CS 111.',1);
INSERT INTO major_courses VALUES(2,'CS 232','Programming Concepts and Methodology II','3','Prerequisite(s):  CS 225.',1);
INSERT INTO major_courses VALUES(3,'CS 242','Computer Architecture and Organization','3','Prerequisite(s):  CS 225 (or concurrent enrollment).',1);
INSERT INTO major_courses VALUES(4,'CS 252','Discrete Structures','3','Prerequisite(s):  CS 225.',1);
INSERT INTO major_courses VALUES(5,'BIOL 124','Molecular and Cellular Biology','5','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures.',1);
INSERT INTO major_courses VALUES(6,'BIOL 125',' Evolution, Ecology & Biodiversity','5','Prerequisite(s):  Intermediate algebra or higher or direct placement based on multiple measures.',1);
INSERT INTO major_courses VALUES(7,'MATH 190','Calculus with Analytic Geometry l','5','Prerequisite(s): MATH 175 or direct placement based on multiple measures.',1);
INSERT INTO major_courses VALUES(8,'MATH 191','Calculus with Analytic Geometry ll','5','Prerequisite(s): MATH 190.',1);
INSERT INTO major_courses VALUES(9,'PHYS 201','Physics A: Mechanics','5','Prerequisite(s):  MATH 190.',1);
CREATE TABLE a1_oral_communication(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO a1_oral_communication VALUES(1,'SPCH 100','Interpersonal Communication','3','Strongly recommended: ENGL 101.',0);
INSERT INTO a1_oral_communication VALUES(2,'SPCH 100H',' Interpersonal Communication - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO a1_oral_communication VALUES(3,'SPCH 101','Public Address','3','Strongly recommended: ENGL 101.',1);
INSERT INTO a1_oral_communication VALUES(4,'SPCH 101H','Public Address - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO a1_oral_communication VALUES(5,'SPCH 103','Argumentation and Debate','3','Strongly recommended: ENGL 101.',0);
INSERT INTO a1_oral_communication VALUES(6,'SPCH 106','Small Group Communication','3','Strongly recommended: ENGL 101.',0);
CREATE TABLE a2_written_communication(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO a2_written_communication VALUES(1,'ENGL 101','Reading and Composition','4','Prerequisite(s): Direct placement based on multiple measures or completion of both ESL 005A AND ESL 005B with min. grade of C.',1);
INSERT INTO a2_written_communication VALUES(2,'ENGL 101E','Reading and Composition, Enhanced','5','Prerequisite(s): Direct placement based on multiple measures or completion of both ESL 005A AND ESL 005B with min. grade of C.',0);
INSERT INTO a2_written_communication VALUES(3,'ENGL 101H','Reading and Composition - Honors','4','Prerequisite(s): Direct placement based on multiple measures or completion of both ESL 005A AND ESL 005B with min. grade of C; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO a2_written_communication VALUES(4,'ENGL 102','Introduction to Literature','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H.',0);
CREATE TABLE a3_critical_thinking(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO a3_critical_thinking VALUES(1,'ENGL 103','Composition and Critical Thinking','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H.',0);
INSERT INTO a3_critical_thinking VALUES(2,'ENGL 103H','Composition and Critical Thinking - Honors','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO a3_critical_thinking VALUES(3,'ENGL 104','Argumentative Writing and Critical Thinking','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H.',0);
INSERT INTO a3_critical_thinking VALUES(4,'ENGL 104H','Argumentative Writing and Critical Thinking - Honors','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H.',0);
INSERT INTO a3_critical_thinking VALUES(5,'PHIL 110','Philosophy/Logic','3','Strongly recommended: ENGL 101.',0);
INSERT INTO a3_critical_thinking VALUES(6,'PHIL 210','Symbolic Logic','3','Strongly recommended:  ENGL 101.',1);
INSERT INTO a3_critical_thinking VALUES(7,'SPCH 103','Argumentation and Debate','3','Strongly recommended: ENGL 101.',0);
CREATE TABLE b1_physical_sciences(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO b1_physical_sciences VALUES(1,'ASTR 115','Planetary Astronomy','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H or eligible for ENGL 101 without support.',0);
INSERT INTO b1_physical_sciences VALUES(2,'ASTR 115H','Planetary Astronomy - Honors','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H or eligible for ENGL 101 without support; student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO b1_physical_sciences VALUES(3,'ASTR 116','Stellar Astronomy (Lab)','4','Strongly recommended:  ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(4,'ASTR 117','Life In The Universe','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(5,'CHEM 103','College Chemistry I (Lab)','5','Prerequisite(s):  Elementary algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b1_physical_sciences VALUES(6,'CHEM 104','College Chemistry II (Lab)','5','Prerequisite(s):  CHEM 103 or CHEM 110.',0);
INSERT INTO b1_physical_sciences VALUES(7,'CHEM 110','Beginning General Chemistry (Lab)','5','Prerequisite(s):  Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b1_physical_sciences VALUES(8,'CHEM 111','General Chemistry I (Lab)','5','Prerequisite(s):  Intermediate algebra or higher or direct placement based on multiple measures; CHEM 110 or passing score on Chemistry Placement Test.',0);
INSERT INTO b1_physical_sciences VALUES(9,'CHEM 112','General Chemistry II (Lab)','5','Prerequisite(s):  CHEM 111.',0);
INSERT INTO b1_physical_sciences VALUES(10,'CHEM 210','Organic Chemistry A','3','Prerequisite(s):  CHEM 112.',0);
INSERT INTO b1_physical_sciences VALUES(11,'CHEM 220','Organic Chemistry B','3','Prerequisite(s):  CHEM 210.',0);
INSERT INTO b1_physical_sciences VALUES(12,'ESCI 110','Earth Science (Lab)','4','Strongly recommended: ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(13,'ESCI 119','Physical Geology without Laboratory','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(14,'ESCI 120','Physical Geology (Lab)','4','Strongly recommended: ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(15,'ESCI 121','Historical Geology','4','Prerequisite(s): ESCI 119 or ESCI 120 or ESCI 124 or ESCI 130.',0);
INSERT INTO b1_physical_sciences VALUES(16,'ESCI 122','Earth History','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(17,'ESCI 124','Natural Disasters','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(18,'ESCI 130','Physical Oceanography','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(19,'GEOG 118','Physical Geography','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(20,'GEOG 130','Introduction to Weather and Climate','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(21,'PHYS 109','Physics and the Arts','3','Strongly recommended: MATH 160; ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(22,'PHYS 110','Physics in Everyday Life (Lab)','4','Strongly recommended: Elementary algebra or higher or direct placement based on multiple measures; ENGL 101.',0);
INSERT INTO b1_physical_sciences VALUES(23,'PHYS 110H','Physics in Everyday Life - Honors','4','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b1_physical_sciences VALUES(24,'PHYS 111','College Physics A (Lab)','4','Prerequisite(s): MATH 151 or higher.',0);
INSERT INTO b1_physical_sciences VALUES(25,'PHYS 112','College Physics B (Lab)','4','Prerequisite(s): PHYS 111.',0);
INSERT INTO b1_physical_sciences VALUES(26,'PHYS 201','Physics A: Mechanics (Lab)','5','Prerequisite(s):  MATH 190.',0);
INSERT INTO b1_physical_sciences VALUES(27,'PHYS 201H','Physics A: Mechanics - Honors','5','Prerequisite(s): MATH 190; student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO b1_physical_sciences VALUES(28,'PHYS 202','Physics B: Thermodynamics and Electromagnetism (Lab)','5','Prerequisite(s):  PHYS 201 or PHYS 201H; MATH 191.',0);
INSERT INTO b1_physical_sciences VALUES(29,'PHYS 203','Physics C:  Waves, Optics & Modern Physics (Lab)','5','Prerequisite(s):  PHYS 201 or PHYS 201H; MATH 191, which may be taken concurrently.',0);
CREATE TABLE b2_biological_sciences(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO b2_biological_sciences VALUES(1,'ANTH 212','Introduction to Physical Anthropology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(2,'ANTH 212L','Introduction to Physical Anthropology Lab (Lab, must be taken with ANTH 212))','1','Strongly recommended: ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(3,'BIOL 102','Human Genetics','3','Strongly recommended:  ENGL 101; Elementary algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b2_biological_sciences VALUES(4,'BIOL 105','General Biology (Lab)','4','Strongly recommended:  High school biology or chemistry; high school algebra 1 or Integrated Math 1 or equivalent; ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(5,'BIOL 105H','General Biology - Honors (Lab)','4','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO b2_biological_sciences VALUES(6,'BIOL 108','Biology of Cancer','3','Prerequisite(s): Elementary algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b2_biological_sciences VALUES(7,'BIOL 110','Field Biology (Lab)','4','Strongly recommended: High school biology or chemistry; high school algebra 1 or Integrated Math 1 or equivalent; ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(8,'BIOL 117','Biology of Infectious Diseases ','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(9,'BIOL 124','Molecular and Cellular Biology (Lab)','5','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b2_biological_sciences VALUES(10,'BIOL 125','Evolution, Ecology & Biodiversity (Lab)','5','Prerequisite(s):  Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b2_biological_sciences VALUES(11,'BIOL 145','Environmental Science','3','Strongly recommended:  BIOL 105 or BIOL 105H;  ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(12,'BIOL 200','Human Anatomy  (Lab)','4','Prerequisite(s):  BIOL 105 or BIOL 105H or BIOL 124.',0);
INSERT INTO b2_biological_sciences VALUES(13,'BIOL 201','Human Physiology (Lab)','4','Prerequisite(s):  BIOL 200;  CHEM 103 or CHEM 104 or CHEM 110 or CHEM 111 or CHEM 112.',0);
INSERT INTO b2_biological_sciences VALUES(14,'BIOL 220','Microbiology (Lab)','5','Prerequisite(s):  BIOL 105 or BIOL 105H or BIOL 124;  CHEM 103 or CHEM 104 or CHEM 110 or CHEM 111 or CHEM 112.',0);
INSERT INTO b2_biological_sciences VALUES(15,'BIOT 107','Biotechnology: Transforming Society Through Biology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(16,'BIOT 108','Intro to Biotechnology: Real World Biology Applications','4','Strongly recommended:  Intermediate algebra or higher;  ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(17,'FOR 102','Introduction to Forest Ecology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO b2_biological_sciences VALUES(18,'PSY 102','Psychobiology','3','Prerequisite(s):  PSY 101 or PSY 101H.',0);
CREATE TABLE b4_mathematics_quantitative_reasoning(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(1,'MATH 144','Technical Mathematics','5','Prerequisite(s): Elementary algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(2,'MATH 151','Plane Trigonometry','4','Prerequisite(s): Direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(3,'MATH 160','Mathematics for Everyday Living - A Liberal Arts Course','5','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(4,'MATH 165','Introductory Statistics','4','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(5,'MATH 165H','Introductory Statistics - Honors','4','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures; ENGL 101 or ENGL 101E or ENGL 101H or higher or direct placement based on multiple measures; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(6,'MATH 168','Mathematics for Elementary Teachers l','5','Prerequisite(s): Intermediate algebra or higher, or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(7,'MATH 170','College Algebra','4','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(8,'MATH 175','Pre-Calculus','6','Prerequisite(s): Intermediate algebra or plane trigonometry or higher or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(9,'MATH 180','Calculus for Business and Social Sciences','4','Prerequisite(s): Intermediate algebra or higher or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(10,'MATH 190','Calculus with Analytic Geometry l','5','Prerequisite(s): MATH 175 or direct placement based on multiple measures.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(11,'MATH 191','Calculus with Analytic Geometry ll','5','Prerequisite(s): MATH 190.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(12,'MATH 210','Calculus with Analytic Geometry lll','5','Prerequisite(s): MATH 191.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(13,'MATH 211','Differential Equations','5','Prerequisite(s): MATH 210.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(14,'MATH 212','Introduction to Linear Algebra','4','Prerequisite(s):  MATH 191.',0);
INSERT INTO b4_mathematics_quantitative_reasoning VALUES(15,'PSY 103','Statistics for the Social and Behavioral Sciences','3','Prerequisite(s):  Intermediate algebra or higher or direct placement based on multiple measures.',0);
CREATE TABLE c1_arts(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO c1_arts VALUES(1,'ARCH 250','History of Architecture:  Prehistory to Mannerism','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(2,'ARCH 251','History of Architecture:  Baroque to the Present Day','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(3,'ART 100','Art History - Fundamentals of Global Art History','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(4,'ART 100A','Survey of Western Art from Prehistory through the Middle Ages','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(5,'ART 100AH','Survey of Western Art from Prehistory through the Middle Ages - Honors','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(6,'ART 100B','Survey of Western Art from Renaissance to Contemporary','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(7,'ART 100BH','Survey of Western Art from Renaissance to Contemporary - Honors','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(8,'ART 101','Art History - Ancient Art','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(9,'ART 102','Art History - Western Medieval Art','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(10,'ART 103','Art History  - Renaissance and Baroque Art in Western Europe','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(11,'ART 104','Art History - Modern and Contemporary Art','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(12,'ART 105','Art History - Topics in Contemporary Art','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(13,'ART 106H','Art History - Ancient Latin American Art - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c1_arts VALUES(14,'ART 108','History of Photography','3','None',0);
INSERT INTO c1_arts VALUES(15,'ART 109','Survey of Arts of Africa, Oceania, and Indigenous North America','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(16,'ART 110','Introduction to the Visual Arts','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(17,'ART 111','Beginning Drawing','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(18,'ART 112','Intermediate Drawing','3','Prerequisite(s):  ART 111.',0);
INSERT INTO c1_arts VALUES(19,'ART 130','Beginning Painting','3','Strongly recommended: ART 111, ENGL 101.',0);
INSERT INTO c1_arts VALUES(20,'ART 140','Beginning Ceramics','3','None',0);
INSERT INTO c1_arts VALUES(21,'ART 199','Motion Picture Appreciation','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(22,'ART 199H','Motion Picture Appreciation - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c1_arts VALUES(23,'ART 200','History of Motion Pictures: 1895-1945','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(24,'ART 201','History of Motion Pictures 1945-Present','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(25,'ART 206','History of Latin American Art - Colonial through Contemporary','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(26,'ART 207','History of Asian Art','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(27,'ART 207H','History of Asian Art - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c1_arts VALUES(28,'COMM 136','Cultural History of American Films','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(29,'DANC 102','History of Dance','3','None',0);
INSERT INTO c1_arts VALUES(30,'ENGL 290','Ethnic Voices in Film','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(31,'MUSE 109','Music Appreciation','3','None',0);
INSERT INTO c1_arts VALUES(32,'MUSE 110','History of Music I','3','None',0);
INSERT INTO c1_arts VALUES(33,'MUSE 111','History of Music II','3','None',0);
INSERT INTO c1_arts VALUES(34,'MUSE 112','History of Jazz','3','None',0);
INSERT INTO c1_arts VALUES(35,'MUSE 113','History of Rock and Roll','3','None',0);
INSERT INTO c1_arts VALUES(36,'MUSE 114','Introduction to American Music','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO c1_arts VALUES(37,'PHTO 108','History of Photography','3','None',0);
INSERT INTO c1_arts VALUES(38,'THEA 101','Introduction to Theatre Arts','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(39,'THEA 101H','Introduction to Theatre Arts - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c1_arts VALUES(40,'THEA 200','Script Analysis: The Art of the Theatre','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c1_arts VALUES(41,'THEA 201','Stage Acting I - Beginning','3','Strongly recommended: ENGL 101.',1);
INSERT INTO c1_arts VALUES(42,'THEA 202','Stage Acting II - Intermediate','3','Prerequisite(s):  THEA 201 or Audition.',0);
CREATE TABLE c2_humanities(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO c2_humanities VALUES(1,'ARCH 250','History of Architecture:  Prehistory to Mannerism','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(2,'ARCH 251','History of Architecture:  Baroque to the Present Day','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(3,'ASL 101','American Sign Language I','5','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(4,'ASL 102','American Sign Language II','5','Prerequisite(s): ASL 101 or ASL 101H.',0);
INSERT INTO c2_humanities VALUES(5,'CHIN 101','Chinese I','5','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(6,'CHIN 102','Chinese II','5','Prerequisite(s):  CHIN 101 or two years of high school Chinese.',0);
INSERT INTO c2_humanities VALUES(7,'CHIN 201','Chinese III','5','Prerequisite(s): CHIN 102 or two years of high school Chinese.',0);
INSERT INTO c2_humanities VALUES(8,'COMM 111','Introduction to Popular Culture','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(9,'COMM 200','Visual Communications','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(10,'ENGL 102','Introduction to Literature','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H.',0);
INSERT INTO c2_humanities VALUES(11,'ENGL 213','Horror Literature','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H.',0);
INSERT INTO c2_humanities VALUES(12,'ENGL 213H','Horror Literature - Honors','3','Prerequisite(s):  ENGL 101 or ENGL 101E or ENGL 101H; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(13,'ENGL 216','American Latino Literature','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(14,'ENGL 224','Queer Literature','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(15,'ENGL 224H','Queer Literature - Honors','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(16,'ENGL 233','Asian American Literature','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(17,'ENGL 243','African American Literature','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(18,'ENGL 251','Introduction to English Literature I','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(19,'ENGL 252','Introduction to English Literature II','3','Prerequisite(s): ENGL 101, ENGL 101E or ENGL 101H.',0);
INSERT INTO c2_humanities VALUES(20,'ENGL 261','Introduction to U.S. American Literature I','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(21,'ENGL 262','Introduction to U. S. American Literature II: 1865-The Present','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(22,'ENGL 271','Introduction to World Literature:  Ancient - Early Modern','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(23,'ENGL 272','Introduction to World Literature:  1600''s through Twentieth Century','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(24,'ENGL 280','Introduction to Women''s Literature','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(25,'ENGL 291','Film as Literature','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(26,'ENGL 291H','Film as Literature - Honors','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(27,'ENGL 293','Children''s Literature','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(28,'ENGL 293H','Children''s Literature - Honors','3','Prerequisite(s): ENGL 101 or ENGL 101E or ENGL 101H; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(29,'ENGL 294','Introduction to Shakespeare','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(30,'ENGL 295','Ethnic Voices in U.S. Literature from 1900 to Present','3','None',0);
INSERT INTO c2_humanities VALUES(31,'ENGL 298','Literature of the Bible','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(32,'ENGL 290','Ethnic Voices in Film','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(33,'FREN 101','French I','5','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(34,'FREN 102','French II','5','Prerequisite(s): FREN 101 or two years of high school French.',0);
INSERT INTO c2_humanities VALUES(35,'GER 101','German I','5','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(36,'GER 102','German II','5','Prerequisite(s): GER 101 or two years high school German.',0);
INSERT INTO c2_humanities VALUES(37,'GER 201','German III','5','Prerequisite(s): GER 102 or three years of high school German.',0);
INSERT INTO c2_humanities VALUES(38,'GER 202','German IV','5','Prerequisite(s): GER 201 or four years of high school German.',0);
INSERT INTO c2_humanities VALUES(39,'HIST 102','Western Civilization 1715 to the Present','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(40,'HIST 103','History of World Civilization up to 1500 C.E.','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(41,'HIST 103H','History of World Civilization up to 1500 C.E./Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(42,'HIST 104','History of World Civilization since 1500','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(43,'HIST 104H','History of World Civilization since 1500 - Honors','3','Prerequisite(s): Students must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(44,'HIST 107','History of the United States before 1877','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(45,'HIST 107H','History of the United States before 1877 - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(46,'HIST 108','History of the United States since 1877','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(47,'HIST 108H','History of the United States since 1877 - Honors','3','Prerequisite(s):  ENGL 101 or ENGL 101H or eligible for ENGL 101 without support; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(48,'HIST 130','Latin American Culture and Civilization','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO c2_humanities VALUES(49,'HIST 131','History of Latin America to 1825','3','Strongly recommended: ENGL 101.',1);
INSERT INTO c2_humanities VALUES(50,'HIST 132','History of Modern Latin America','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(51,'HIST 140','History of the American West','3','Strongly recommended: ENGL 101 or ENGL 101H.',0);
INSERT INTO c2_humanities VALUES(52,'HIST 160','History of Women in the United States','3','Strongly recommended: ENGL 101.',1);
INSERT INTO c2_humanities VALUES(53,'HUM 101','Humanities - Prehistory through the Medieval Period','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(54,'HUM 101H','Humanities - Prehistory through the Medieval Period - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(55,'HUM 102','Humanities from the Renaissance through the 19th Century','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(56,'HUM 110','Humanities in the Modern Period','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(57,'HUM 115','Multi-Cultural Mythologies','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(58,'HUM 120','British Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(59,'HUM 123','Introduction to Peace Studies - Saving Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(60,'HUM 125','Italian Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(61,'HUM 127','Spanish Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(62,'HUM 129','French Culture and Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(63,'HUM 162','Japanese Culture through Anime and Manga','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(64,'ITAL 101','Italian I','5','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(65,'ITAL 102','Italian II','5','Prerequisite(s): ITAL 101 OR two years of high school Italian or equivalent OR basic knowledge of first semester elementary Italian as determined by the Professor of Record.',0);
INSERT INTO c2_humanities VALUES(66,'JPN 101','Japanese I','5','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(67,'JPN 102','Japanese II','5','Prerequisite(s): JPN 101 or two years of high school Japanese.',0);
INSERT INTO c2_humanities VALUES(68,'KIN 166','American Food And Culture: Global Origins, History, and Current Impacts','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(69,'PHIL 101','Great Religions of the World','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(70,'PHIL 106','Introduction to Philosophy','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(71,'PHIL 106H','Introduction to Philosophy - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO c2_humanities VALUES(72,'PHIL 108','Philosophy - Ethics','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(73,'PHIL 130','History of Ancient Philosophy','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO c2_humanities VALUES(74,'PHIL 131','History of Modern Philosophy','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(75,'PHIL 140','Philosophy of Religion','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(76,'SOC 130','Introduction to LGBTQ Studies ','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(77,'SPAN 101','Spanish I','5','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(78,'SPAN 102','Spanish II','5','Prerequisite(s):  SPAN 101 OR two years of high school Spanish or equivalent OR basic knowledge of first semester elementary Spanish as determined by the Professor of Record.',0);
INSERT INTO c2_humanities VALUES(79,'SPAN 127','Spanish Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO c2_humanities VALUES(80,'SPAN 130','Latin American Culture and Civilization','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO c2_humanities VALUES(81,'SPAN 201','Spanish III','5','Prerequisite(s): SPAN 102 or fluency in Spanish.',0);
INSERT INTO c2_humanities VALUES(82,'SPAN 201H','Spanish III - Honors','5','Prerequisite(s): SPAN 102 or fluency in Spanish.',0);
INSERT INTO c2_humanities VALUES(83,'SPAN 202','Spanish IV','5','Prerequisite(s): SPAN 201 or fluency in Spanish.',0);
INSERT INTO c2_humanities VALUES(84,'SPAN 210','Intermediate Spanish for Spanish Speakers I','5','Prerequisite(s): Oral fluency in Spanish.',0);
INSERT INTO c2_humanities VALUES(85,'SPAN 211','Intermediate Spanish for Spanish Speakers II','5','Prerequisite(s):  Oral fluency in Spanish.',0);
INSERT INTO c2_humanities VALUES(86,'SPCH 150','Intercultural Communication','3','Strongly recommended: ENGL 101.',0);
CREATE TABLE d_social_political_and(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO d_social_political_and VALUES(1,'AJ 101','Introduction to the Administration of Justice','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(2,'AJ 102','Concepts of Criminal Law','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(3,'ANTH 210','Introduction to Cultural Anthropology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(4,'ANTH 210H','Introduction to Cultural Anthropology - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(5,'ANTH 212','Introduction to Physical Anthropology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(6,'ANTH 216','Sex and Gender in Cross Cultural Perspectives','3','Strongly recommended: ANTH 210 or ANTH 210H or SOC 201 or SOC 201H and ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(7,'ANTH 216H','Sex and Gender in a Cross Cultural Perspective - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(8,'ANTH 220','Introduction to Archaeology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(9,'ANTH 222','Introduction to Linguistic Anthropology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(10,'ANTH 224','Anthropology of Religion, Magic, and Witchcraft','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(11,'BUS 132','Business, Ethics and Society','3','None',0);
INSERT INTO d_social_political_and VALUES(12,'BUS 171','Human Relations in the Workplace','3','None',0);
INSERT INTO d_social_political_and VALUES(13,'CHLD 110','Early Childhood Development','3','None',1);
INSERT INTO d_social_political_and VALUES(14,'CHLD 111','Child Development Youth - Adolescence','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(15,'CHLD 114','Home-Child-Community Relations','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(16,'COMM 100','Mass Media and Society','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(17,'COMM 111','Introduction to Popular Culture','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(18,'COMM 150','Communication Theory','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(19,'COUN 212','Diversity & Inclusion in Society ','3','None',1);
INSERT INTO d_social_political_and VALUES(20,'ECON 100','Survey of Economics','3','Strongly recommended:  Completion of, or direct placement into, an algebra based transfer-level math course;  ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(21,'ECON 101','Principles of Macroeconomics','3','Prerequisite(s): Concurrent enrollment in an algebra based math course OR completion of, or direct placement into, an algebra based transfer-level math course.',0);
INSERT INTO d_social_political_and VALUES(22,'ECON 101H','Principles of Macroeconomics - Honors','3','Prerequisite(s): Concurrent enrollment in an algebra based math course OR completion of, or direct placement into, an algebra based transfer-level math course; and, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(23,'ECON 102','Principles of Microeconomics','3','Prerequisite(s):  ECON 101 or ECON 101H.',0);
INSERT INTO d_social_political_and VALUES(24,'ETHN 101','Introduction to Ethnic Studies','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(25,'ETHN 116','Introduction to Chicano/Latino Studies','3','None',0);
INSERT INTO d_social_political_and VALUES(26,'GEOG 102','Cultural Geography','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(27,'GEOG 103','Introduction to Global Studies','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(28,'GEOG 104','World Regional Geography','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(29,'GEOG 105','Global Issues','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(30,'HIST 102','Western Civilization 1715 to the Present','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(31,'HIST 103','History of World Civilization up to 1500 C.E.','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(32,'HIST 103H','History of World Civilization up to 1500 C.E./Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(33,'HIST 104','History of World Civilization since 1500','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(34,'HIST 104H','History of World Civilization since 1500 - Honors','3','Prerequisite(s): Students must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(35,'HIST 107','History of the United States before 1877','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(36,'HIST 107H','History of the United States before 1877 - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(37,'HIST 108','History of the United States since 1877','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(38,'HIST 108H','History of the United States since 1877 - Honors','3','Prerequisite(s):  ENGL 101 or ENGL 101H or eligible for ENGL 101 without support; also, student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(39,'HIST 109','The World in Conflict - The 20th Century, a History','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(40,'HIST 111','History of the African-Americans to 1876','3','None',0);
INSERT INTO d_social_political_and VALUES(41,'HIST 112','History of the African-Americans since 1876','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(42,'HUM 125','Italian Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(43,'HIST 130','Latin American Culture and Civilization','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(44,'HIST 131','History of Latin America to 1825','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(45,'HIST 132','History of Modern Latin America','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(46,'HIST 139','History of California','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(47,'HIST 140','History of the American West','3','Strongly recommended: ENGL 101 or ENGL 101H.',0);
INSERT INTO d_social_political_and VALUES(48,'HIST 145','History of Mexico','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(49,'HIST 155','History of the Vietnam War','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(50,'HIST 160','History of Women in the United States','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(51,'HIST 222','History of World War II','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(52,'HUM 120','British Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(53,'HUM 123','Introduction to Peace Studies - Saving Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(54,'HUM 127','Spanish Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(55,'KIN 166','American Food And Culture: Global Origins, History, and Current Impacts','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(56,'KIN 167','Women in Sport','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(57,'KIN 178','Race, Gender and Sports','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(58,'KIN 179','Health and Social Justice','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(59,'POLI 103','American Government and Politics','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(60,'POLI 103H','American Government and Politics - Honors','3','Prerequisite(s): ENGL 101 or ENGL 101H or eligible for ENGL 101 without support;  Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(61,'POLI 105','Comparative Politics','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(62,'POLI 108','Political Theory','3','Strongly recommended:  ENGL 101 or ENGL 101E or ENGL 101H.',0);
INSERT INTO d_social_political_and VALUES(63,'POLI 116','International Relations','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(64,'PSY 101','Introduction to Psychology','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(65,'PSY 101H','Introduction to Psychology - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(66,'PSY 203','Research Methods in Psychology','4','Prerequisite(s):  PSY 101 or PSY 101H;  PSY 103 or MATH 165 or MATH 165H.',0);
INSERT INTO d_social_political_and VALUES(67,'PSY 205','Developmental Psychology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(68,'PSY 206','Child Growth and Development','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(69,'PSY 212','Psychological Disorders','3','Prerequisite(s):  PSY 101 or PSY 101H.',0);
INSERT INTO d_social_political_and VALUES(70,'PSY 220','Introduction to Social Psychology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(71,'PSY 225','Psychology of Human Sexuality','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(72,'PSY 226','Psychology of Women','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(73,'SOC 114','Marriage, Family, and Intimate Relations','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(74,'SOC 118','Race and Ethnicity ','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(75,'SOC 130','Introduction to LGBTQ Studies ','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(76,'SOC 201','Introduction to Sociology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(77,'SOC 201H','Introduction to Sociology - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO d_social_political_and VALUES(78,'SOC 202','Contemporary Social Problems','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(79,'SOC 220','Introduction to Gender','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(80,'SPAN 127','Spanish Civilization','3','Strongly recommended: ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(81,'SPAN 130','Latin American Culture and Civilization','3','Strongly recommended:  ENGL 101.',0);
INSERT INTO d_social_political_and VALUES(82,'SPCH 150','Intercultural Communication','3','Strongly recommended: ENGL 101.',0);
CREATE TABLE e_lifelong_understanding(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO e_lifelong_understanding VALUES(1,'BUS 146','Principles of Money Management','3','None',0);
INSERT INTO e_lifelong_understanding VALUES(2,'BUS 171','Human Relations in the Workplace','3','None',0);
INSERT INTO e_lifelong_understanding VALUES(3,'COUN 120','Managing Stress and Anxiety for Emotional Well-Being','3','None',0);
INSERT INTO e_lifelong_understanding VALUES(4,'COUN 130','Understanding Addiction ','3','None',0);
INSERT INTO e_lifelong_understanding VALUES(5,'COUN 145','Career/Life Planning','3','Strongly recommended: ENGL 101.',1);
INSERT INTO e_lifelong_understanding VALUES(6,'COUN 160','Strategies for College Success','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(7,'COUN 161','Higher Education Transitional Skills for Student Veterans/Families','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(8,'COUN 212','Diversity & Inclusion in Society ','3','None',0);
INSERT INTO e_lifelong_understanding VALUES(9,'COUN 214','Managing Relationships ','3','None',0);
INSERT INTO e_lifelong_understanding VALUES(10,'KIN 100','Introduction to Kinesiology','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(11,'KIN 116','Yoga','1','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(12,'KIN 117','Vinyasa, Aerial, and Acroyoga','1','Strongly recommended: KIN 116.',0);
INSERT INTO e_lifelong_understanding VALUES(13,'KIN 118','Meditation and Mindfulness','3','None',0);
INSERT INTO e_lifelong_understanding VALUES(14,'KIN 166','American Food And Culture: Global Origins, History, and Current Impacts','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(15,'KIN 167','Women in Sport','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(16,'KIN 168','Introduction to Public Health','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(17,'KIN 170','Fitness for Life','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(18,'KIN 171','Health and Wellness in Society','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(19,'KIN 171H','Health and Wellness in Society - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO e_lifelong_understanding VALUES(20,'KIN 173','Introduction to Nutrition','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(21,'PSY 206','Child Growth and Development','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(22,'PSY 225','Psychology of Human Sexuality','3','Strongly recommended: ENGL 101.',0);
INSERT INTO e_lifelong_understanding VALUES(23,'SOC 114','Marriage, Family, and Intimate Relations','3','Strongly recommended: ENGL 101.',0);
CREATE TABLE f_ethnic_studies(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO f_ethnic_studies VALUES(1,'ETHN 101','Introduction to Ethnic Studies','3','Strongly recommended: ENGL 101.',1);
INSERT INTO f_ethnic_studies VALUES(2,'ETHN 116','Introduction to Chicano/Latino Studies','3','None',0);
CREATE TABLE group_a_us_history(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO group_a_us_history VALUES(1,'HIST 107','History of the United States before 1877','3','Strongly recommended: ENGL 101.',0);
INSERT INTO group_a_us_history VALUES(2,'HIST 107H','History of the United States before 1877 - Honors','3','Prerequisite(s): Student must be eligible for the Citrus College Honors Program or obtain a recommendation from an Honors instructor.',0);
INSERT INTO group_a_us_history VALUES(3,'HIST 108','History of the United States since 1877','3','Strongly recommended: ENGL 101.',0);
INSERT INTO group_a_us_history VALUES(4,'HIST 108H','History of the United States since 1877 - Honors','3','None',0);
INSERT INTO group_a_us_history VALUES(5,'HIST 111','History of the African-Americans to 1876','3','None',0);
INSERT INTO group_a_us_history VALUES(6,'HIST 112','History of the African-Americans since 1876','3','None',0);
INSERT INTO group_a_us_history VALUES(7,'HIST 160','History of Women in the United States','3','None',0);
CREATE TABLE group_b_american_institutions(
  id INT,
  course_name TEXT,
  course_description TEXT,
  course_units TEXT,
  course_prereqs TEXT
, selected INTEGER DEFAULT 0);
INSERT INTO group_b_american_institutions VALUES(1,'POLI 103','American Government and Politics','3','None',0);
INSERT INTO group_b_american_institutions VALUES(2,'POLI 103H','American Government and Politics - Honors','3','None',0);
COMMIT;
