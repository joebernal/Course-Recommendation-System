CREATE DATABASE IF NOT EXISTS owlplan DEFAULT CHARSET = utf8mb4;
USE owlplan;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS student_placements;
DROP TABLE IF EXISTS university_recommended_courses;
DROP TABLE IF EXISTS instructor_recommendations;
DROP TABLE IF EXISTS honors_eligibility;
DROP TABLE IF EXISTS honors_courses;
DROP TABLE IF EXISTS prerequisites;
DROP TABLE IF EXISTS completed_courses;
DROP TABLE IF EXISTS plan_courses;
DROP TABLE IF EXISTS course_plans;
DROP TABLE IF EXISTS ge_course_mappings;
DROP TABLE IF EXISTS major_courses;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS ge_categories;
DROP TABLE IF EXISTS majors;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NULL,  -- Nullable for Google accounts
    google_uid VARCHAR(255) NULL UNIQUE,  -- Store Google UID for authentication
    full_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    enrollment_status VARCHAR(20) DEFAULT 'fulltime',
    available_winter BOOLEAN DEFAULT FALSE,
    available_summer BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Majors Table
CREATE TABLE majors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- General Education Categories Table
CREATE TABLE ge_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_code VARCHAR(5) NOT NULL UNIQUE,  -- Codes: A1, A2, A3, B1, B2, B4, C1, C2, D, E, F, US, AM
    category_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Courses Table (using course_code)
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(15) NOT NULL UNIQUE,
    course_name TEXT,
    course_description TEXT,
    course_units INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Major-Courses Relationship (Many-to-Many)
CREATE TABLE major_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_id INT NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY (major_id) REFERENCES majors(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE (major_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- GE-Course Mapping (Many-to-Many)
CREATE TABLE ge_course_mappings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ge_category_code VARCHAR(5) NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY (ge_category_code) REFERENCES ge_categories(category_code) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Course Plans Table (User-Specific)
CREATE TABLE course_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Plan-Course Mapping (Many-to-Many)
CREATE TABLE plan_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    course_id INT NOT NULL,
    semester ENUM('Fall', 'Winter', 'Spring', 'Summer') NOT NULL,
    year INT NOT NULL CHECK (year BETWEEN 2001 AND 2100),
    FOREIGN KEY (plan_id) REFERENCES course_plans(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE (plan_id, course_id, semester, year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Completed Courses Table
CREATE TABLE completed_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    semester ENUM('Fall', 'Winter', 'Spring', 'Summer') NOT NULL,
    year INT NOT NULL CHECK (year BETWEEN 2001 AND 2100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE (user_id, course_id, semester, year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Prerequisites Table (Self-referential Many-to-Many)
CREATE TABLE prerequisites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    prereq_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Honors Courses Table
CREATE TABLE honors_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL UNIQUE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Honors Eligibility Table
CREATE TABLE honors_eligibility (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    is_eligible BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Instructor Recommendations Table
CREATE TABLE instructor_recommendations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    recommended BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- University Recommended Courses Table
CREATE TABLE university_recommended_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    recommended_course_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (recommended_course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Student Placement Table
CREATE TABLE student_placements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    placement_passed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

START TRANSACTION;

-- (1) Insert GE Categories
INSERT INTO ge_categories (category_code, category_name) VALUES
  ('A1','Oral Communication'),
  ('A2','Written Communication'),
  ('A3','Critical Thinking'),
  ('B1','Physical Sciences'),
  ('B2','Biological Sciences'),
  ('B4','Mathematics/Quantitative Reasoning'),
  ('C1','Arts'),
  ('C2','Humanities'),
  ('D','Social/Political and Cultural Studies'),
  ('E','Lifelong Understanding'),
  ('F','Ethnic Studies'),
  ('US','US History'),
  ('AM','American Institutions');

-- (2) Insert Computer Science Major
INSERT INTO majors (major_name) VALUES ('Computer Science');

-- (3) Insert Courses
-- A1: a1_oral_communication courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('SPCH 100', 'Interpersonal Communication',
   'This course provides students with an understanding of how to enhance communication through exploring the dynamics of interpersonal communication that influence everyday interactions such as nonverbal cues, language, perception, culture, listening, self-concept, emotions, and personal well-being. Students will learn about common problems in relational communication and strategies for effective conflict management. This course also emphasizes understanding the rhetoric involved in interpersonal communication and includes faculty-supervised oral presentations.', 3),
  ('SPCH 100H', 'Interpersonal Communication - Honors',
   'This honors course builds on SPCH 100 with additional expectations for critical analysis, research, and advanced presentation skills.', 3),
  ('SPCH 101', 'Public Address',
   'An introductory course in communication and public speaking, focusing on the selection, preparation, and delivery of speeches for various audiences.', 3),
  ('SPCH 101H', 'Public Address - Honors',
   'An honors version of Public Address with additional requirements for in-depth analysis, research, and leadership in speech delivery.', 3),
  ('SPCH 103', 'Argumentation and Debate',
   'Introduces basic theories and methods for argumentation and debate, including preparation and presentation of practice debates on current issues.', 3),
  ('SPCH 106', 'Small Group Communication',
   'Focuses on principles and techniques for effective group discussion and collaborative decision-making.', 3);

-- A2: a2_written_communication courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('ENGL 101', 'Reading and Composition',
   'A college-level composition course emphasizing exposition, analysis, argument, and research techniques with extensive writing practice.', 4),
  ('ENGL 101E', 'Reading and Composition, Enhanced',
   'A composition course with enhanced requirements emphasizing exposition, analysis, and research techniques.', 5),
  ('ENGL 101H', 'Reading and Composition - Honors',
   'An honors version of the composition course that demands advanced critical analysis and research in writing.', 4),
  ('ENGL 102', 'Introduction to Literature',
   'Introduces representative literary works from major genres, develops close reading and analytical writing skills, and promotes cultural and aesthetic appreciation.', 3);

-- A3: a3_critical_thinking courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('ENGL 103', 'Composition and Critical Thinking',
   'Uses literature to teach critical thinking and composition, emphasizing analysis of issues and the development of effective written arguments. Meets IGETC requirements.', 3),
  ('ENGL 103H', 'Composition and Critical Thinking - Honors',
   'An honors course requiring in-depth analysis, research papers, and advanced presentation skills. Meets IGETC requirements.', 3),
  ('ENGL 104', 'Argumentative Writing and Critical Thinking',
   'Develops advanced writing and research skills by examining classical composition methods and synthesizing opposing arguments. Meets IGETC requirements.', 3),
  ('ENGL 104H', 'Argumentative Writing and Critical Thinking - Honors',
   'An honors course demanding strong critical analysis and synthesis of argumentative texts. Meets IGETC requirements.', 3),
  ('PHIL 110', 'Philosophy/Logic',
   'Introduces fundamental problems and principles of formal and informal logic including deductive and inductive reasoning.', 3),
  ('PHIL 210', 'Symbolic Logic',
   'Focuses on formal logic including sentential and predicate logic, symbolization, and proof techniques.', 3);

-- B1: b1_physical_sciences courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('ASTR 115', 'Planetary Astronomy',
   'Studies the solar system with emphasis on its history, physics, energy, and the formation/evolution of planetary bodies.', 3),
  ('ASTR 115H', 'Planetary Astronomy - Honors',
   'An honors version of ASTR 115 with additional analytical and presentation requirements.', 3),
  ('ASTR 116', 'Stellar Astronomy (Lab)',
   'Introduces stellar astronomy topics including the structure, classification, and evolution of stars; includes laboratory exercises.', 4),
  ('ASTR 117', 'Life In The Universe',
   'Examines the origin and evolution of life on Earth and explores conditions for life elsewhere in the universe.', 3),
  ('CHEM 103', 'College Chemistry I (Lab)',
   'Covers inorganic chemistry topics such as stoichiometry, bonding, chemical equations, gas laws, and laboratory techniques.', 5),
  ('CHEM 104', 'College Chemistry II (Lab)',
   'Focuses on organic compounds and biochemistry topics; prerequisites: CHEM 103 or CHEM 110.', 5),
  ('CHEM 110', 'Beginning General Chemistry (Lab)',
   'Introduces fundamental chemistry concepts, chemical structure, reactivity, and emphasizes laboratory work.', 5),
  ('CHEM 111', 'General Chemistry I (Lab)',
   'Covers periodicity, atomic structure, bonding, chemical calculations, and thermodynamics.', 5),
  ('CHEM 112', 'General Chemistry II (Lab)',
   'A continuation of CHEM 111 with topics including equilibrium, kinetics, and advanced chemistry principles.', 5),
  ('CHEM 210', 'Organic Chemistry A',
   'Introduces organic chemistry including properties, reactions, mechanisms, and stereochemistry; prerequisite: CHEM 112.', 3),
  ('CHEM 220', 'Organic Chemistry B',
   'Focuses on aromatic compounds and advanced organic reactions; prerequisite: CHEM 210.', 3),
  ('ESCI 110', 'Earth Science (Lab)',
   'Provides an introductory survey of Earth and space science with comparative studies of Earth and other planets.', 4),
  ('ESCI 119', 'Physical Geology without Laboratory',
   'Investigates earth processes such as plate tectonics, earthquakes, and crustal deformation; note: do not take with ESCI 120.', 3),
  ('ESCI 120', 'Physical Geology (Lab)',
   'Laboratory complement to ESCI 119 offering hands-on investigation of earth processes.', 4),
  ('ESCI 121', 'Historical Geology',
   'Examines Earth’s geological history through fossil analysis and stratigraphy; prerequisites: ESCI 119, ESCI 120, ESCI 124, or ESCI 130.', 4),
  ('ESCI 122', 'Earth History',
   'Focuses on the geologic history of Earth using stratigraphy and fossil interpretation.', 3),
  ('ESCI 124', 'Natural Disasters',
   'Applies geological principles to study natural disasters such as earthquakes, volcanism, floods, and climate change.', 3),
  ('ESCI 130', 'Physical Oceanography',
   'Studies marine geology and physical processes in the ocean including currents, tides, and sea-floor spreading.', 3),
  ('GEOG 118', 'Physical Geography',
   'Surveys the basic elements of physical geography including climate, soils, vegetation, and landforms.', 3),
  ('GEOG 130', 'Introduction to Weather and Climate',
   'Examines weather patterns, atmospheric circulation, and climate trends at local and global scales.', 3),
  ('PHYS 109', 'Physics and the Arts',
   'A one-semester course exploring basic physics principles and their applications to the arts; recommendation: MATH 160 and ENGL 101.', 3),
  ('PHYS 110', 'Physics in Everyday Life (Lab)',
   'Explores applied physics concepts including kinematics, laws of motion, and electromagnetism; recommendation: ENGL 101.', 4),
  ('PHYS 110H', 'Physics in Everyday Life - Honors',
   'An honors version of PHYS 110 with additional discussion and analytical requirements; prerequisite: Intermediate algebra or higher.', 4),
  ('PHYS 111', 'College Physics A (Lab)',
   'A trigonometry-based physics course covering mechanics, energy, material properties, and thermodynamics; prerequisite: MATH 151.', 4),
  ('PHYS 112', 'College Physics B (Lab)',
   'Continuation of PHYS 111 focusing on optics, electromagnetism, and modern physics; prerequisite: PHYS 111.', 4),
  ('PHYS 201', 'Physics A: Mechanics',
   'Covers fundamentals of mechanics including vectors, motion, work, energy, and momentum; prerequisite: MATH 190.', 5),
  ('PHYS 201H', 'Physics A: Mechanics - Honors',
   'An honors version of PHYS 201 with extra expectations for critical analysis; prerequisite: MATH 190.', 5),
  ('PHYS 202', 'Physics B: Thermodynamics and Electromagnetism (Lab)',
   'Covers electrostatics, magnetism, circuits, and thermodynamics; prerequisites: PHYS 201 (or 201H) and MATH 191; recommendation: MATH 210.', 5),
  ('PHYS 203', 'Physics C: Waves, Optics & Modern Physics (Lab)',
   'Focuses on waves, optics, and modern physics as part of a three‐semester sequence; prerequisites: PHYS 201 (or 201H) and MATH 191.', 5);

-- B2: b2_biological_sciences courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('ANTH 212', 'Introduction to Physical Anthropology',
   'An introductory study of human origins with emphasis on evolution, primate evolution, taxonomy, and fossil identification. Lab credit requires concurrent enrollment with ANTH 212L.', 3),
  ('ANTH 212L', 'Introduction to Physical Anthropology Lab',
   'The lab component for ANTH 212, offering hands-on work in anatomy and fossil identification.', 1),
  ('BIOL 102', 'Human Genetics',
   'Covers general principles of human genetics including Mendelian inheritance, DNA structure, replication, and related topics.', 3),
  ('BIOL 105', 'General Biology (Lab)',
   'A lecture and laboratory course for non-majors emphasizing cell structure, function, energy relationships, reproduction, and evolution.', 4),
  ('BIOL 105H', 'General Biology - Honors (Lab)',
   'An honors version of BIOL 105 requiring advanced critical analysis and enhanced laboratory work.', 4),
  ('BIOL 108', 'Biology of Cancer',
   'Provides a broad overview of cancer biology including genetic basis, hallmark characteristics, prevention, and treatment.', 3),
  ('BIOL 110', 'Field Biology (Lab)',
   'A hybrid lecture/lab course emphasizing cell biology, evolution, and ecological field methods; includes field trips.', 4),
  ('BIOL 117', 'Biology of Infectious Diseases',
   'Focuses on the biology of infectious diseases, including bacteria, viruses, and emerging pathogens.', 3),
  ('BIOL 124', 'Molecular and Cellular Biology',
   'A principles course for biology majors and pre-med students focusing on cell and molecular biology and genetic mechanisms.', 5),
  ('BIOL 125', 'Evolution, Ecology & Biodiversity',
   'Examines the diversity, evolution, form, function, and ecological relationships of living organisms.', 5),
  ('BIOL 145', 'Environmental Science',
   'Explores global environmental concerns including life support systems, pollution, and natural resource utilization.', 3),
  ('BIOL 200', 'Human Anatomy (Lab)',
   'A lecture/laboratory course in human anatomy focusing on structures from the molecular to gross level; required for pre-nursing.', 4),
  ('BIOL 201', 'Human Physiology (Lab)',
   'An advanced course in human physiology emphasizing major body systems; prerequisites include BIOL 200 and selected CHEM courses.', 4),
  ('BIOL 220', 'Microbiology (Lab)',
   'Introduces microbiology with emphasis on culture techniques, genetics, immunology, and host defense; required for pre-nursing.', 5),
  ('BIOT 107', 'Biotechnology: Transforming Society Through Biology',
   'Introduces biotechnology concepts including molecular biology, genetic engineering, and their societal implications.', 3),
  ('BIOT 108', 'Intro to Biotechnology: Real World Biology Applications',
   'A general introduction to biotechnology focusing on practical laboratory applications and real-world challenges.', 4),
  ('FOR 102', 'Introduction to Forest Ecology',
   'Examines forests as biological communities, addressing sustainability, biodiversity, and ecosystem health.', 3),
  ('PSY 102', 'Psychobiology',
   'Introduces the biological bases of behavior including neurochemical mechanisms and brain–behavior relationships; prerequisite: PSY 101 or PSY 101H.', 3);

-- B4: b4_mathematics_quantitative_reasoning courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('MATH 144', 'Technical Mathematics',
   'Reviews and extends elementary algebra and geometry and introduces trigonometry, statistics, and technical problem-solving skills.', 5),
  ('MATH 151', 'Plane Trigonometry',
   'Studies trigonometric functions, identities, equations, and triangle-solving techniques using the Law of Sines and Cosines.', 4),
  ('MATH 160', 'Mathematics for Everyday Living - A Liberal Arts Course',
   'Introduces real-world mathematical concepts including financial management and basic probability.', 5),
  ('MATH 165', 'Introductory Statistics',
   'Covers descriptive statistics, probability, hypothesis testing, and statistical inference with applications across disciplines.', 4),
  ('MATH 165H', 'Introductory Statistics - Honors',
   'An honors version of MATH 165 with additional analytical and presentation requirements.', 4),
  ('MATH 168', 'Mathematics for Elementary Teachers l',
   'Designed for prospective elementary teachers; covers problem solving, logic, number systems, and introductory algebraic reasoning.', 5),
  ('MATH 170', 'College Algebra',
   'Covers polynomial, rational, radical, exponential, and logarithmic functions and systems of equations.', 4),
  ('MATH 175', 'Pre-Calculus',
   'Prepares students for calculus by studying various functions, analytic geometry, sequences, series, and mathematical induction.', 6),
  ('MATH 180', 'Calculus for Business and Social Sciences',
   'An applied calculus course emphasizing differentiation and integration techniques with business and social science applications.', 4),
  ('MATH 190', 'Calculus with Analytic Geometry l',
   'A first course in differential and integral calculus of a single variable covering limits, continuity, differentiation, integration, and the Fundamental Theorem of Calculus.', 5),
  ('MATH 191', 'Calculus with Analytic Geometry ll',
   'A continuation of MATH 190 focusing on integration techniques, infinite series, and polar/parametric equations.', 5),
  ('MATH 210', 'Calculus with Analytic Geometry lll',
   'Covers multivariable calculus including partial derivatives, multiple integrals, and vector calculus theorems (Green, Stokes, Divergence).', 5),
  ('MATH 211', 'Differential Equations',
   'Focuses on solving differential equations and systems using linear algebra techniques and Laplace Transforms.', 5),
  ('MATH 212', 'Introduction to Linear Algebra',
   'Introduces matrix theory, vector spaces, eigenvalues, and linear transformations with practical applications.', 4),
  ('PSY 103', 'Statistics for the Social and Behavioral Sciences',
   'An introductory statistics course tailored for social science students with emphasis on both descriptive and inferential methods.', 3);

-- C1: c1_arts courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('ARCH 250', 'History of Architecture: Prehistory to Mannerism',
   'Examines the development of architecture from prehistory through the Mannerism period with emphasis on cultural and socioeconomic influences.', 3),
  ('ARCH 251', 'History of Architecture: Baroque to the Present Day',
   'Explores the evolution of architecture from the Baroque period to the present with a focus on cultural and political influences.', 3),
  ('ART 100', 'Art History - Fundamentals of Global Art History',
   'Surveys global art history from ancient times to the present with emphasis on basic art principles and media.', 3),
  ('ART 100A', 'Survey of Western Art from Prehistory through the Middle Ages',
   'Provides an overview of Western art and architecture from prehistory through the medieval period.', 3),
  ('ART 100AH', 'Survey of Western Art from Prehistory through the Middle Ages - Honors',
   'An honors-level survey of early Western art with in-depth cultural analysis.', 3),
  ('ART 100B', 'Survey of Western Art from Renaissance to Contemporary',
   'Covers art and architecture from the Renaissance to the contemporary period.', 3),
  ('ART 100BH', 'Survey of Western Art from Renaissance to Contemporary - Honors',
   'An honors version with added critical analysis and contextual discussion.', 3),
  ('ART 101', 'Art History - Ancient Art',
   'Covers Western art history from its prehistoric beginnings to the fall of Rome.', 3),
  ('ART 102', 'Art History - Western Medieval Art',
   'Surveys Western art from the fall of Rome to the early Renaissance.', 3),
  ('ART 103', 'Art History - Renaissance and Baroque Art in Western Europe',
   'Examines the art of the Renaissance and Baroque periods in Western Europe.', 3),
  ('ART 104', 'Art History - Modern and Contemporary Art',
   'Covers Western art history from the French Revolution to today.', 3),
  ('ART 105', 'Art History - Topics in Contemporary Art',
   'Investigates selected topics in contemporary art from a global perspective.', 3),
  ('ART 106H', 'Art History - Ancient Latin American Art - Honors',
   'An honors course focusing on pre-Columbian cultures and art in Latin America with critical discussion.', 3),
  ('ART 108', 'History of Photography',
   'Surveys the history of photography from its origins to the present with critical analysis of theoretical approaches.', 3),
  ('ART 109', 'Survey of Arts of Africa, Oceania, and Indigenous North America',
   'Provides an overview of art and architecture from Africa, Oceania, and Indigenous North America.', 3),
  ('ART 110', 'Introduction to the Visual Arts',
   'Introduces the visual arts through aesthetics, critique, history, and creative practice.', 3),
  ('ART 111', 'Beginning Drawing',
   'Develops drawing and composition skills to help students perceive shape, mass, and space.', 3),
  ('ART 112', 'Intermediate Drawing',
   'Builds upon ART 111 with advanced and conceptual approaches to drawing.', 3),
  ('ART 130', 'Beginning Painting',
   'Introduces painting techniques using oil or acrylic with emphasis on form, space, and color.', 3),
  ('ART 140', 'Beginning Ceramics',
   'Explores basic pottery techniques including handbuilding and wheel throwing with emphasis on material properties and creative expression.', 3),
  ('ART 199', 'Motion Picture Appreciation',
   'Introduces film analysis by examining technical, aesthetic, and thematic aspects of significant films.', 3),
  ('ART 199H', 'Motion Picture Appreciation - Honors',
   'An honors version of film appreciation requiring advanced critical thinking and analysis.', 3),
  ('ART 200', 'History of Motion Pictures: 1895-1945',
   'Surveys world cinema history from 1895 to 1945 with emphasis on technical and thematic developments.', 3),
  ('ART 201', 'History of Motion Pictures 1945-Present',
   'Provides an overview of motion picture history from 1945 to the present with focus on cultural context and production systems.', 3),
  ('ART 206', 'History of Latin American Art - Colonial through Contemporary',
   'Surveys the art of Mexico and Central/South America from the Colonial period to the present.', 3),
  ('ART 207', 'History of Asian Art',
   'Examines the visual arts and architecture of Asia from prehistory to the present with cultural context.', 3),
  ('ART 207H', 'History of Asian Art - Honors',
   'An honors-level survey of Asian art with in-depth analysis of cultural and historical influences.', 3),
  ('COMM 136', 'Cultural History of American Films',
   'Studies American film history including film language, audience composition, and cultural impact. Meets IGETC fine arts requirement.', 3),
  ('DANC 102', 'History of Dance',
   'Surveys dance from tribal and folk forms to modern styles including classical and contemporary genres.', 3),
  ('ENGL 290', 'Ethnic Voices in Film',
   'Introduces films reflecting ethnic, racial, and gender perspectives and explores their cultural significance.', 3),
  ('MUSE 109', 'Music Appreciation',
   'Introduces music history from the Middle Ages to the 20th century including theory and major composers; recommended for non-music majors as well.', 3),
  ('MUSE 110', 'History of Music I',
   'Examines music history from Antiquity through the Baroque period; recommended for music majors.', 3),
  ('MUSE 111', 'History of Music II',
   'Continues the study of music history focusing on the Classical, Romantic, and 20th-century periods; recommended for music majors.', 3),
  ('MUSE 112', 'History of Jazz',
   'Surveys the development of jazz music, its major styles, and influential artists.', 3),
  ('MUSE 113', 'History of Rock and Roll',
   'Examines the evolution of rock music and the sociocultural factors influencing its development.', 3),
  ('MUSE 114', 'Introduction to American Music',
   'Surveys American music from the 17th century to the present across multiple genres.', 3),
  ('PHTO 108', 'History of Photography',
   'A duplicate of ART 108; refer to ART 108 for the full description.', 3),
  ('THEA 101', 'Introduction to Theatre Arts',
   'Provides a foundation in theatre arts including dramatic structure, theatre history, plays, and production practices.', 3),
  ('THEA 101H', 'Introduction to Theatre Arts - Honors',
   'An honors version of THEA 101 with additional requirements for critical analysis and leadership in theatre practice.', 3),
  ('THEA 200', 'Script Analysis: The Art of the Theatre',
   'Focuses on analyzing plays with emphasis on dramatic structure and cultural significance.', 3),
  ('THEA 201', 'Stage Acting I - Beginning',
   'Introduces basic acting skills using the Stanislavski Method including memorization, stage movement, and text interpretation.', 3),
  ('THEA 202', 'Stage Acting II - Intermediate',
   'A continuation of Stage Acting I with deeper exploration of acting techniques and scene analysis; prerequisite: THEA 201 or an audition.', 3);

-- C2: c2_humanities courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('ASL 101', 'American Sign Language I',
   'Introduces ASL with focus on basic structures, vocabulary, and an introduction to Deaf culture.', 5),
  ('ASL 102', 'American Sign Language II',
   'Continues ASL I with an emphasis on conversational skills and expanded vocabulary.', 5),
  ('CHIN 101', 'Chinese I',
   'An elementary Mandarin course covering basic grammar, vocabulary, pronunciation, reading, and writing.', 5),
  ('CHIN 102', 'Chinese II',
   'Builds on Chinese I with further practice in vocabulary and character writing.', 5),
  ('CHIN 201', 'Chinese III',
   'An intermediate Mandarin course focusing on communication skills and advanced grammar.', 5),
  ('COMM 111', 'Introduction to Popular Culture',
   'Examines popular culture as a window into American society through historical and critical analysis.', 3),
  ('COMM 200', 'Visual Communications',
   'Introduces the history and usage of visual media and its impact on society.', 3),
  ('ENGL 213', 'Horror Literature',
   'Introduces horror literature and its critical analysis.', 3),
  ('ENGL 213H', 'Horror Literature - Honors',
   'An honors version of ENGL 213 requiring advanced research and presentation.', 3),
  ('ENGL 216', 'American Latino Literature',
   'Explores Latino literature with emphasis on cultural expression and historical context.', 3),
  ('ENGL 224', 'Queer Literature',
   'Surveys queer literature from various cultures and examines sociohistorical influences on LGBTQ+ texts.', 3),
  ('ENGL 224H', 'Queer Literature - Honors',
   'An honors-level survey of queer literature with added requirements for critical analysis.', 3),
  ('ENGL 233', 'Asian American Literature',
   'Introduces Asian American literature with a focus on themes of identity and cultural influence.', 3),
  ('ENGL 243', 'African American Literature',
   'Surveys African American literature emphasizing cultural impact and historical context.', 3),
  ('ENGL 251', 'Introduction to English Literature I',
   'Surveys major British literary works from the Anglo-Saxon period through the 18th century.', 3),
  ('ENGL 252', 'Introduction to English Literature II',
   'Surveys British literature from the late 18th century to contemporary and postcolonial texts.', 3),
  ('ENGL 261', 'Introduction to U.S. American Literature I',
   'Explores American literature from the Colonial period to the Civil War.', 3),
  ('ENGL 262', 'Introduction to U.S. American Literature II: 1865-The Present',
   'Examines American literature from the Civil War to the present, focusing on emerging themes.', 3),
  ('ENGL 271', 'Introduction to World Literature: Ancient - Early Modern',
   'Studies world literature in translation from ancient times through the early modern period.', 3),
  ('ENGL 272', 'Introduction to World Literature: 1600''s through Twentieth Century',
   'Surveys world literature in translation from the early modern period to the twentieth century.', 3),
  ('ENGL 280', 'Introduction to Women''s Literature',
   'Emphasizes culturally diverse texts written by and about women with critical analysis of roles and challenges.', 3),
  ('ENGL 291', 'Film as Literature',
   'Introduces film as a literary medium through critical analysis and discussion.', 3),
  ('ENGL 291H', 'Film as Literature - Honors',
   'An honors course in film analysis requiring advanced research and presentation skills.', 3),
  ('ENGL 293', 'Children''s Literature',
   'Examines children’s literature with emphasis on writing quality and illustrative excellence.', 3),
  ('ENGL 293H', 'Children''s Literature - Honors',
   'An honors-level study of children’s literature with additional critical discussion requirements.', 3),
  ('ENGL 294', 'Introduction to Shakespeare',
   'Introduces the works of William Shakespeare including tragedies, comedies, and histories.', 3),
  ('ENGL 295', 'Ethnic Voices in U.S. Literature from 1900 to Present',
   'Surveys writings from diverse ethnic groups in the U.S. to explore immigrant experiences and cultural diversity.', 3),
  ('ENGL 298', 'Literature of the Bible',
   'Provides reading and discussion of selected Biblical texts with literary analysis.', 3),
  ('ENGL 290', 'Ethnic Voices in Film',
   'Examines films that reflect ethnic, racial, and gender perspectives through critical analysis.', 3),
  ('FREN 101', 'French I',
   'An elementary course in French focusing on grammar, vocabulary, pronunciation, and cultural introduction.', 5),
  ('FREN 102', 'French II',
   'Continues French I with further language development and cultural exposure.', 5),
  ('GER 101', 'German I',
   'An elementary course in German covering basic grammar, vocabulary, and pronunciation.', 5),
  ('GER 102', 'German II',
   'A continuation of German I aimed at improving language proficiency.', 5),
  ('GER 201', 'German III',
   'An intermediate German course emphasizing oral, reading, and writing skills with exposure to literature.', 5),
  ('GER 202', 'German IV',
   'An advanced German course focused on interpreting advanced texts and refining language skills.', 5),
  ('HIST 102', 'Western Civilization 1715 to the Present',
   'Surveys European history from 1715 through major events such as revolutions, world wars, and the Cold War.', 3),
  ('HIST 103', 'History of World Civilization up to 1500 C.E.',
   'A survey of early world civilizations and their contributions with emphasis on cultural diffusion and trade.', 3),
  ('HIST 103H', 'History of World Civilization up to 1500 C.E./Honors',
   'An honors-level survey of early world civilizations with in-depth comparative analysis.', 3),
  ('HIST 104', 'History of World Civilization since 1500',
   'Surveys world civilizations from 1500 to the present with focus on political, economic, and cultural forces.', 3),
  ('HIST 104H', 'History of World Civilization since 1500 - Honors',
   'An honors version of HIST 104 with additional research and critical analysis requirements.', 3),
  ('HIST 107', 'History of the United States before 1877',
   'Surveys U.S. history up to 1876; meets state history requirements.', 3),
  ('HIST 107H', 'History of the United States before 1877 - Honors',
   'An honors course on early U.S. history with deeper analysis and research requirements.', 3),
  ('HIST 108', 'History of the United States since 1877',
   'Surveys U.S. history from 1876 to the present covering political, economic, and social development.', 3),
  ('HIST 108H', 'History of the United States since 1877 - Honors',
   'An honors version of HIST 108 with additional historiographical analysis.', 3),
  ('HIST 111', 'History of the African-Americans to 1876',
   'Explores African-American history from its origins to the end of Reconstruction.', 3),
  ('HIST 112', 'History of the African-Americans since 1876',
   'Examines African-American history from Reconstruction to the present.', 3),
  ('HIST 130', 'Latin American Culture and Civilization',
   'Provides an interdisciplinary overview of Latin American history and culture.', 3),
  ('HIST 131', 'History of Latin America to 1825',
   'Surveys Latin American history from pre-Columbian times to independence with emphasis on historical institutions.', 3),
  ('HIST 132', 'History of Modern Latin America',
   'Surveys Latin American history from independence to the present with focus on cultural, political, and economic developments.', 3),
  ('HIST 160', 'History of Women in the United States',
   'Surveys major themes in U.S. women’s history from pre-contact through modern times.', 3),
  ('HUM 101', 'Humanities - Prehistory through the Medieval Period',
   'Provides an overview of the humanities from ancient civilizations through the medieval period.', 3),
  ('HUM 101H', 'Humanities - Prehistory through the Medieval Period - Honors',
   'An honors-level survey of early humanities with emphasis on critical primary source analysis.', 3),
  ('HUM 102', 'Humanities from the Renaissance through the 19th Century',
   'Examines art, history, music, literature, and philosophy from the Renaissance to the 19th century.', 3),
  ('HUM 110', 'Humanities in the Modern Period',
   'Focuses on critical analysis of modern art and philosophy from the late 19th century onward.', 3),
  ('HUM 115', 'Multi-Cultural Mythologies',
   'Introduces comparative mythology across different cultures, including creation myths and heroic narratives.', 3),
  ('HUM 120', 'British Civilization',
   'Provides an overview of British culture, history, politics, and society.', 3),
  ('HUM 123', 'Introduction to Peace Studies - Saving Civilization',
   'Introduces peace and conflict studies with an emphasis on war’s impact on art, literature, and philosophy.', 3),
  ('HUM 125', 'Italian Civilization',
   'Surveys Italian culture and civilization by examining historical, political, economic, and social changes.', 3),
  ('HUM 127', 'Spanish Civilization',
   'An interdisciplinary study of Spanish culture and history.', 3),
  ('HUM 129', 'French Culture and Civilization',
   'Provides an overview of French culture and contributions, including practical field experiences.', 3),
  ('HUM 162', 'Japanese Culture through Anime and Manga',
   'Explores Japanese culture through themes in anime and manga, discussing modern cultural issues.', 3),
  ('ITAL 101', 'Italian I',
   'An elementary Italian language course covering grammar, vocabulary, pronunciation, reading, and writing.', 5),
  ('ITAL 102', 'Italian II',
   'A continuation of Italian I with further language development and taught primarily in Italian.', 5),
  ('JPN 101', 'Japanese I',
   'An elementary Japanese language course covering basic grammar, vocabulary, and pronunciation.', 5),
  ('JPN 102', 'Japanese II',
   'A continuation of Japanese I with further development of language skills and cultural understanding.', 5),
  ('KIN 166', 'American Food And Culture: Global Origins, History, and Current Impacts',
   'Examines the evolution of American food culture from historical, economic, political, and scientific perspectives.', 3),
  ('PHIL 101', 'Great Religions of the World',
   'Covers the historical development and principal ideas of the world''s major religions.', 3),
  ('PHIL 106', 'Introduction to Philosophy',
   'Introduces fundamental philosophical concepts and problems with a representative sampling of primary texts.', 3),
  ('PHIL 106H', 'Introduction to Philosophy - Honors',
   'An honors version of PHIL 106 requiring advanced critical analysis and seminar discussion.', 3),
  ('PHIL 108', 'Philosophy - Ethics',
   'Critically analyzes ethical theories such as Kantianism, Utilitarianism, and Virtue Ethics with practical applications.', 3),
  ('PHIL 130', 'History of Ancient Philosophy',
   'Studies selected works in ancient philosophy including those by the Presocratics, Socrates, Plato, and Aristotle.', 3),
  ('PHIL 131', 'History of Modern Philosophy',
   'Surveys modern philosophical thought from Descartes through Kant.', 3),
  ('PHIL 140', 'Philosophy of Religion',
   'Examines philosophical issues related to classical theism, including the concept of God and the problem of evil.', 3),
  ('SOC 130', 'Introduction to LGBTQ Studies',
   'Introduces contemporary issues affecting LGBTQ communities from a sociocultural perspective.', 3),
  ('SPAN 101', 'Spanish I',
   'An elementary Spanish course covering grammar, vocabulary, and basic conversation.', 5),
  ('SPAN 102', 'Spanish II',
   'A continuation of Spanish I with further language development.', 5),
  ('SPAN 127', 'Spanish Civilization',
   'Provides an interdisciplinary overview of Spanish culture and history.', 3),
  ('SPAN 130', 'Latin American Culture and Civilization',
   'Surveys Latin American history and culture using an interdisciplinary approach.', 3),
  ('SPAN 201', 'Spanish III',
   'An intermediate Spanish course for both native speakers and second-language learners focusing on grammar and authentic texts.', 5),
  ('SPAN 201H', 'Spanish III - Honors',
   'An honors version of Spanish III with additional requirements for critical analysis and presentation.', 5),
  ('SPAN 202', 'Spanish IV',
   'An advanced Spanish course focused on higher-level grammar and interpretation of cultural texts.', 5),
  ('SPAN 210', 'Intermediate Spanish for Spanish Speakers I',
   'Designed for fluent speakers who need to improve formal writing and reading skills; emphasizes literature and culture.', 5),
  ('SPAN 211', 'Intermediate Spanish for Spanish Speakers II',
   'A continuation of SPAN 210 for further refinement of formal language skills.', 5),
  ('SPCH 150', 'Intercultural Communication',
   'Introduces theories and practices in intercultural communication and examines how language and culture shape group interactions.', 3);

-- D: d_social_political_and courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('AJ 101', 'Introduction to the Administration of Justice',
   'Introduces the U.S. criminal justice system with emphasis on crime measurement, legal processes, and contemporary challenges.', 3),
  ('AJ 102', 'Concepts of Criminal Law',
   'Covers the philosophy and historical development of law, including key constitutional principles.', 3),
  ('ANTH 210', 'Introduction to Cultural Anthropology',
   'Critically examines diverse societies using core anthropological concepts such as kinship, language, and religion.', 3),
  ('ANTH 210H', 'Introduction to Cultural Anthropology - Honors',
   'An honors version of ANTH 210 with added requirements for research, analysis, and presentation.', 3),
  ('ANTH 212', 'Introduction to Physical Anthropology',
   'An introductory study of human origins focusing on evolution, taxonomy, and fossil identification.', 3),
  ('ANTH 216', 'Sex and Gender in Cross Cultural Perspectives',
   'Explores cultural attitudes and expressions of sex and gender using interdisciplinary approaches.', 3),
  ('ANTH 216H', 'Sex and Gender in a Cross Cultural Perspective - Honors',
   'An honors course on cross-cultural gender studies requiring advanced critical analysis and discussion.', 3),
  ('ANTH 220', 'Introduction to Archaeology',
   'Introduces archaeological methods and the evolution of human material culture.', 3),
  ('ANTH 222', 'Introduction to Linguistic Anthropology',
   'Foundational course on language and its role in culture from an anthropological perspective.', 3),
  ('ANTH 224', 'Anthropology of Religion, Magic, and Witchcraft',
   'Examines religious beliefs and practices cross-culturally with an emphasis on mythology, ritual, and cultural change.', 3),
  ('BUS 132', 'Business, Ethics and Society',
   'Analyzes ethical issues in business through an interdisciplinary approach drawing on philosophy and management.', 3),
  ('BUS 171', 'Human Relations in the Workplace',
   'Provides an overview of organizational behavior and interpersonal relations.', 3),
  ('CHLD 110', 'Early Childhood Development',
   'Examines developmental milestones in early childhood with emphasis on physical, cognitive, and psychosocial factors.', 3),
  ('CHLD 111', 'Child Development Youth - Adolescence',
   'Focuses on developmental milestones from middle childhood through adolescence.', 3),
  ('CHLD 114', 'Home-Child-Community Relations',
   'Explores the socialization process and the interplay between family, school, and community.', 3),
  ('COMM 100', 'Mass Media and Society',
   'Surveys mass media’s economic, political, and cultural impact on society.', 3),
  ('ECON 100', 'Survey of Economics',
   'Introduces economic concepts as applied to the U.S. economy, including systems, unemployment, and fiscal policy.', 3),
  ('ECON 101', 'Principles of Macroeconomics',
   'Covers aggregate economic analysis including national income, business cycles, and policy issues.', 3),
  ('ECON 101H', 'Principles of Macroeconomics - Honors',
   'An honors version of ECON 101 with additional research and analytical components.', 3),
  ('ECON 102', 'Principles of Microeconomics',
   'Focuses on individual decision-making and resource allocation from the perspectives of consumers and firms.', 3),
  ('GEOG 102', 'Cultural Geography',
   'Studies human occupation patterns and the cultural factors influencing land use.', 3),
  ('GEOG 103', 'Introduction to Global Studies',
   'Introduces globalization and examines cultural, political, and social issues on an international scale.', 3),
  ('GEOG 104', 'World Regional Geography',
   'Explores world regions with emphasis on climate, topography, and population patterns.', 3),
  ('GEOG 105', 'Global Issues',
   'Examines contemporary global challenges such as poverty, climate change, and international trade.', 3),
  ('HIST 109', 'The World in Conflict - The 20th Century, a History',
   'A critical study of major global conflicts of the 20th century.', 3),
  ('HIST 111', 'History of the African-Americans to 1876',
   'Explores African-American history from its origins to the end of Reconstruction.', 3),
  ('HIST 112', 'History of the African-Americans since 1876',
   'Examines African-American history from the end of Reconstruction to the present.', 3),
  ('HIST 139', 'History of California',
   'Surveys California’s political, social, and economic development from native communities and Spanish settlements to the present.', 3),
  ('HIST 145', 'History of Mexico',
   'Surveys Mexican history from pre-Columbian times through independence and beyond.', 3),
  ('HIST 155', 'History of the Vietnam War',
   'Examines the background, U.S. involvement, and long-term effects of the Vietnam War.', 3),
  ('HIST 222', 'History of World War II',
   'Analyzes the circumstances and impact of World War II with emphasis on U.S. involvement.', 3),
  ('KIN 167', 'Women in Sport',
   'Examines the impact of Title IX and the role of women in sports from social and economic perspectives.', 3),
  ('KIN 178', 'Race, Gender and Sports',
   'Analyzes the influence of race and gender on participation in U.S. sports.', 3),
  ('KIN 179', 'Health and Social Justice',
   'Introduces health inequities in the U.S. and examines how socioeconomic factors shape public health policies.', 3),
  ('POLI 105', 'Comparative Politics',
   'Introduces governmental systems and analyzes political ideologies, electoral procedures, and governing institutions on a global scale.', 3),
  ('POLI 108', 'Political Theory',
   'Traces the evolution of political concepts such as justice, democracy, and power through key thinkers.', 3),
  ('POLI 116', 'International Relations',
   'Examines theories of international relations and their relevance to contemporary global politics.', 3),
  ('PSY 101', 'Introduction to Psychology',
   'Introduces psychology as an empirical science covering behavior, cognition, and affect.', 3),
  ('PSY 101H', 'Introduction to Psychology - Honors',
   'An honors introduction to psychology with additional requirements for critical analysis.', 3),
  ('PSY 203', 'Research Methods in Psychology',
   'Introduces research methodologies including descriptive and inferential statistics for behavioral and social sciences.', 4),
  ('PSY 205', 'Developmental Psychology',
   'Studies the progressive changes in behavior, cognition, and abilities across the lifespan.', 3),
  ('PSY 206', 'Child Growth and Development',
   'Examines developmental milestones for children from conception through adolescence with emphasis on environmental interactions.', 3),
  ('PSY 212', 'Psychological Disorders',
   'Introduces the study of psychopathology from multiple perspectives and discusses intervention strategies.', 3),
  ('PSY 220', 'Introduction to Social Psychology',
   'Explores the nature of socially determined behavior including conformity, prejudice, and social roles.', 3),
  ('PSY 225', 'Psychology of Human Sexuality',
   'Surveys the psychological bases and sociocultural dimensions of human sexuality.', 3),
  ('PSY 226', 'Psychology of Women',
   'Examines female development and gender issues from psychological, sociological, and biological perspectives.', 3),
  ('SOC 114', 'Marriage, Family, and Intimate Relations',
   'Considers sociological and psychological factors influencing modern marriages and relationships.', 3),
  ('SOC 118', 'Race and Ethnicity',
   'Provides an overview of the social, economic, and political aspects of minority groups in America.', 3),
  ('SOC 201', 'Introduction to Sociology',
   'Examines the basic structure of human society and the forces that shape group behavior.', 3),
  ('SOC 201H', 'Introduction to Sociology - Honors',
   'An honors course in sociology with additional requirements for in-depth analysis and presentation.', 3),
  ('SOC 202', 'Contemporary Social Problems',
   'Focuses on the causes and effects of modern social problems in America through research and discussion.', 3),
  ('SOC 220', 'Introduction to Gender',
   'Analyzes how institutions shape gender and how individuals learn and perform gender roles.', 3);

-- E: e_lifelong_understanding courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('BUS 146', 'Principles of Money Management',
   'Introduces personal finance including budgeting, financial planning, and the interrelationships among financial, social, and mental health.', 3),
  ('BUS 171', 'Human Relations in the Workplace',
   'Provides an overview of behavioral science principles applied to organizational and interpersonal relations.', 3),
  ('COUN 120', 'Managing Stress and Anxiety for Emotional Well-Being',
   'Designed to increase awareness of stress and teach practical coping strategies for improved emotional well-being.', 3),
  ('COUN 130', 'Understanding Addiction',
   'Explores the psychological, sociological, and physical causes and effects of addiction and substance abuse.', 3),
  ('COUN 145', 'Career/Life Planning',
   'Helps students develop individual career plans through personal exploration and analysis of contemporary work issues.', 3),
  ('COUN 160', 'Strategies for College Success',
   'Provides study skills and strategies to adopt positive habits and critical thinking techniques for academic success.', 3),
  ('COUN 161', 'Higher Education Transitional Skills for Student Veterans/Families',
   'Assists veterans in transitioning to college life by developing self-awareness, leadership, and study skills.', 3),
  ('COUN 212', 'Diversity & Inclusion in Society',
   'Examines how cultural diversity affects interpersonal relationships and workplace dynamics.', 3),
  ('COUN 214', 'Managing Relationships',
   'Explores techniques for cultivating healthy relationships through practical and theoretical approaches.', 3),
  ('KIN 100', 'Introduction to Kinesiology',
   'Introduces the interdisciplinary study of human movement and its significance in daily life and related careers.', 3),
  ('KIN 116', 'Yoga',
   'Focuses on developing body/mind awareness through yoga postures, breathing techniques, and relaxation exercises.', 1),
  ('KIN 117', 'Vinyasa, Aerial, and Acroyoga',
   'Builds upon basic yoga skills using more rigorous practices in vinyasa, aerial, and acroyoga to enhance wellness.', 1),
  ('KIN 118', 'Meditation and Mindfulness',
   'Explores theoretical and practical strategies for stress management through meditation and mindfulness techniques.', 3),
  ('KIN 168', 'Introduction to Public Health',
   'Introduces core public health concepts including disease prevention, community health, and public policy.', 3),
  ('KIN 170', 'Fitness for Life',
   'Explains effective exercise and diet program mechanics and provides practical activities to develop a personal fitness plan.', 3),
  ('KIN 171', 'Health and Wellness in Society',
   'Covers the knowledge required to make informed lifestyle and health decisions in contemporary society.', 3),
  ('KIN 171H', 'Health and Wellness in Society - Honors',
   'An honors version of KIN 171 with additional requirements for critical analysis and discussion.', 3),
  ('KIN 173', 'Introduction to Nutrition',
   'Provides essential knowledge on nutrients, metabolism, and dietary adjustments for health maintenance.', 3);

-- F: f_ethnic_studies courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('ETHN 101', 'Introduction to Ethnic Studies',
   'A historical and cultural survey of major ethnic groups and ethnic relations in the U.S. from pre-Columbian times to the present.', 3),
  ('ETHN 116', 'Introduction to Chicano/Latino Studies',
   'An introductory survey of the history, identity, and culture of Chicana/o/x and Latina/o/x populations in the U.S.', 3);

-- US: group_a_us_history courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('HIST 107', 'History of the United States before 1877',
   'Surveys U.S. history up to 1876; meets state history requirements.', 3),
  ('HIST 107H', 'History of the United States before 1877 - Honors',
   'An honors version of HIST 107 with deeper analysis and research requirements.', 3),
  ('HIST 108', 'History of the United States since 1877',
   'Surveys U.S. history from 1876 to the present covering political, economic, and social development.', 3),
  ('HIST 108H', 'History of the United States since 1877 - Honors',
   'An honors version of HIST 108 with additional historiographical analysis.', 3),
  ('HIST 111', 'History of the African-Americans to 1876',
   'Explores African-American history from its origins to the end of Reconstruction.', 3),
  ('HIST 112', 'History of the African-Americans since 1876',
   'Examines African-American history from Reconstruction to the present.', 3),
  ('HIST 160', 'History of Women in the United States',
   'Surveys major themes in U.S. women’s history from pre-contact through modern times.', 3);

-- AM: group_b_american_institutions courses
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('POLI 103', 'American Government and Politics',
   'Examines the origins and functions of the U.S. government with emphasis on contemporary issues and constitutional principles.', 3),
  ('POLI 103H', 'American Government and Politics - Honors',
   'An honors version of POLI 103 with additional requirements for critical analysis and research.', 3);

-- Major Courses (from major_courses)
INSERT IGNORE INTO courses (course_code, course_name, course_description, course_units) VALUES
  ('CS 225', 'Object Oriented Programming',
   'Introduces computer science using C++ with emphasis on functions, control structures, arrays, debugging, and software development methods. Prerequisite: CS 111.', 3),
  ('CS 232', 'Programming Concepts and Methodology II',
   'Applies software engineering techniques to design and develop large programs; requires CS 225.', 3),
  ('CS 242', 'Computer Architecture and Organization',
   'Examines computer organization at the assembly-language level and the mapping of high-level constructs to machine instructions; prerequisite: CS 225 (or concurrent enrollment).', 3),
  ('CS 252', 'Discrete Structures',
   'Introduces discrete structures used in Computer Science including functions, relations, sets, logic, and graph theory; prerequisite: CS 225.', 3);

-- (4) GE-Course Mappings (using course_code)
-- GE Category A1 (Oral Communication)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'A1', id FROM courses WHERE course_code IN ('SPCH 100','SPCH 100H','SPCH 101','SPCH 101H','SPCH 103','SPCH 106');

-- GE Category A2 (Written Communication)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'A2', id FROM courses WHERE course_code IN ('ENGL 101','ENGL 101E','ENGL 101H','ENGL 102');

-- GE Category A3 (Critical Thinking)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'A3', id FROM courses WHERE course_code IN ('ENGL 103','ENGL 103H','ENGL 104','ENGL 104H','PHIL 110','PHIL 210','SPCH 103');

-- GE Category B1 (Physical Sciences)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'B1', id FROM courses WHERE course_code IN (
    'ASTR 115','ASTR 115H','ASTR 116','ASTR 117','CHEM 103','CHEM 104','CHEM 110','CHEM 111','CHEM 112',
    'CHEM 210','CHEM 220','ESCI 110','ESCI 119','ESCI 120','ESCI 121','ESCI 122','ESCI 124','ESCI 130',
    'GEOG 118','GEOG 130','PHYS 109','PHYS 110','PHYS 110H','PHYS 111','PHYS 112','PHYS 201','PHYS 201H','PHYS 202','PHYS 203'
  );

-- GE Category B2 (Biological Sciences)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'B2', id FROM courses WHERE course_code IN (
    'ANTH 212','ANTH 212L','BIOL 102','BIOL 105','BIOL 105H','BIOL 108','BIOL 110','BIOL 117',
    'BIOL 124','BIOL 125','BIOL 145','BIOL 200','BIOL 201','BIOL 220','BIOT 107','BIOT 108','FOR 102','PSY 102'
  );

-- GE Category B4 (Mathematics/Quantitative Reasoning)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'B4', id FROM courses WHERE course_code IN (
    'MATH 144','MATH 151','MATH 160','MATH 165','MATH 165H','MATH 168','MATH 170','MATH 175','MATH 180',
    'MATH 190','MATH 191','MATH 210','MATH 211','MATH 212','PSY 103'
  );

-- GE Category C1 (Arts)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'C1', id FROM courses WHERE course_code IN (
    'ARCH 250','ARCH 251','ART 100','ART 100A','ART 100AH','ART 100B','ART 100BH','ART 101','ART 102','ART 103','ART 104',
    'ART 105','ART 106H','ART 108','ART 109','ART 110','ART 111','ART 112','ART 130','ART 140','ART 199','ART 199H',
    'ART 200','ART 201','ART 206','ART 207','ART 207H','COMM 136','DANC 102','ENGL 290','MUSE 109','MUSE 110','MUSE 111',
    'MUSE 112','MUSE 113','MUSE 114','PHTO 108','THEA 101','THEA 101H','THEA 200','THEA 201','THEA 202'
  );

-- GE Category C2 (Humanities)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'C2', id FROM courses WHERE course_code IN (
    'ASL 101','ASL 102','CHIN 101','CHIN 102','CHIN 201','COMM 111','COMM 200','ENGL 102',
    'ENGL 213','ENGL 213H','ENGL 216','ENGL 224','ENGL 224H','ENGL 233','ENGL 243','ENGL 251','ENGL 252',
    'ENGL 261','ENGL 262','ENGL 271','ENGL 272','ENGL 280','ENGL 291','ENGL 291H','ENGL 293','ENGL 293H','ENGL 294',
    'ENGL 295','ENGL 298','ENGL 290','FREN 101','FREN 102','GER 101','GER 102','GER 201','GER 202',
    'HIST 102','HIST 103','HIST 103H','HIST 104','HIST 104H',
    'HIST 107','HIST 107H','HIST 108','HIST 108H','HIST 111','HIST 112','HIST 130','HIST 131','HIST 132','HIST 160',
    'HUM 101','HUM 101H','HUM 102','HUM 110','HUM 115','HUM 120','HUM 123','HUM 125','HUM 127','HUM 129','HUM 162',
    'ITAL 101','ITAL 102','JPN 101','JPN 102','KIN 166','PHIL 101','PHIL 106','PHIL 106H','PHIL 108','PHIL 130',
    'PHIL 131','PHIL 140','SOC 130','SPAN 101','SPAN 102','SPAN 127','SPAN 130','SPAN 201','SPAN 201H','SPAN 202',
    'SPAN 210','SPAN 211','SPCH 150'
  );

-- GE Category D (Social/Political and Cultural Studies)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
SELECT 'D', id
FROM courses
WHERE course_code IN (
  'AJ 101', 'AJ 102',
  'ANTH 210', 'ANTH 210H', 'ANTH 212', 'ANTH 216', 'ANTH 216H', 'ANTH 220', 'ANTH 222', 'ANTH 224',
  'BUS 132', 'BUS 171',
  'CHLD 110', 'CHLD 111', 'CHLD 114',
  'COMM 100', 'COMM 111', 'COMM 150',
  'COUN 212',
  'ECON 100', 'ECON 101', 'ECON 101H', 'ECON 102',
  'ETHN 101', 'ETHN 116',
  'GEOG 102', 'GEOG 103', 'GEOG 104', 'GEOG 105',
  'HIST 102', 'HIST 103', 'HIST 103H', 'HIST 104', 'HIST 104H', 'HIST 107', 'HIST 107H', 'HIST 108', 'HIST 108H',
  'HIST 109', 'HIST 111', 'HIST 112',
  'HUM 125',
  'HIST 130', 'HIST 131', 'HIST 132', 'HIST 139', 'HIST 140', 'HIST 145', 'HIST 155', 'HIST 160', 'HIST 222',
  'HUM 120', 'HUM 123', 'HUM 127',
  'KIN 166', 'KIN 167', 'KIN 178', 'KIN 179',
  'POLI 103', 'POLI 103H', 'POLI 105', 'POLI 108', 'POLI 116',
  'PSY 101', 'PSY 101H', 'PSY 203', 'PSY 205', 'PSY 206', 'PSY 212', 'PSY 220', 'PSY 225', 'PSY 226',
  'SOC 114', 'SOC 118', 'SOC 130', 'SOC 201', 'SOC 201H', 'SOC 202', 'SOC 220',
  'SPAN 127', 'SPAN 130',
  'SPCH 150'
);

-- GE Category E (Lifelong Understanding)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
SELECT 'E', id
FROM courses
WHERE course_code IN (
  'BUS 146', 'BUS 171',
  'COUN 120', 'COUN 130', 'COUN 145', 'COUN 160', 'COUN 161', 'COUN 212', 'COUN 214',
  'KIN 100', 'KIN 116', 'KIN 117', 'KIN 118', 'KIN 166', 'KIN 167', 'KIN 168', 'KIN 170', 'KIN 171', 'KIN 171H', 'KIN 173',
  'PSY 206', 'PSY 225',
  'SOC 114'
);

-- GE Category F (Ethnic Studies)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
SELECT 'F', id
FROM courses
WHERE course_code IN ('ETHN 101', 'ETHN 116');


-- GE Category US (US History)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'US', id FROM courses WHERE course_code IN (
    'HIST 107','HIST 107H','HIST 108','HIST 108H','HIST 111','HIST 112','HIST 160'
  );

-- GE Category AM (American Institutions)
INSERT INTO ge_course_mappings (ge_category_code, course_id)
  SELECT 'AM', id FROM courses WHERE course_code IN ('POLI 103','POLI 103H');

-- (5) Map Major Courses to Computer Science Major (assume major_id = 1)
INSERT INTO major_courses (major_id, course_id)
  SELECT 1, id FROM courses WHERE course_code IN ('CS 225','CS 232','CS 242','CS 252','BIOL 124','BIOL 125','MATH 190','MATH 191','PHYS 201');

-- (6) Insert Prerequisite Mappings (using course_code)
-- a2_written_communication prerequisites: ENGL 102 requires ENGL 101, ENGL 101E, ENGL 101H
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 102' AND p.course_code = 'ENGL 101';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 102' AND p.course_code = 'ENGL 101E';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 102' AND p.course_code = 'ENGL 101H';

-- a3_critical_thinking prerequisites: ENGL 103, ENGL 103H, ENGL 104, and ENGL 104H require ENGL 101
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 103' AND p.course_code = 'ENGL 101';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 103H' AND p.course_code = 'ENGL 101';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 104' AND p.course_code = 'ENGL 101';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 104H' AND p.course_code = 'ENGL 101';

-- b1_physical_sciences prerequisites
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'CHEM 104' AND p.course_code = 'CHEM 103';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'CHEM 104' AND p.course_code = 'CHEM 110';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'CHEM 112' AND p.course_code = 'CHEM 111';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'CHEM 210' AND p.course_code = 'CHEM 112';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'CHEM 220' AND p.course_code = 'CHEM 210';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 121' AND p.course_code IN ('ESCI 119','ESCI 120','ESCI 124','ESCI 130');
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 111' AND p.course_code = 'MATH 151';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 112' AND p.course_code = 'PHYS 111';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 201' AND p.course_code = 'MATH 190';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 201H' AND p.course_code = 'MATH 190';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 202' AND p.course_code IN ('PHYS 201','PHYS 201H','MATH 191');
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 203' AND p.course_code IN ('PHYS 201','PHYS 201H','MATH 191');

-- b2_biological_sciences prerequisites
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 200' AND p.course_code IN ('BIOL 105','BIOL 105H','BIOL 124');
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 201' AND p.course_code IN ('BIOL 200','CHEM 103','CHEM 104','CHEM 110','CHEM 111','CHEM 112');
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 220' AND p.course_code IN ('BIOL 105','BIOL 105H','BIOL 124','CHEM 103','CHEM 104','CHEM 110','CHEM 111','CHEM 112');
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 102' AND p.course_code IN ('PSY 101','PSY 101H');

-- b4_mathematics_quantitative_reasoning prerequisites
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'MATH 190' AND p.course_code = 'MATH 175';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'MATH 191' AND p.course_code = 'MATH 190';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'MATH 210' AND p.course_code = 'MATH 191';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'MATH 211' AND p.course_code = 'MATH 210';
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'MATH 212' AND p.course_code = 'MATH 191';

-- C1_arts prerequisites
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 112' AND p.course_code = 'ART 111';

-- C2_humanities prerequisites
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p 
    WHERE c.course_code IN ('ENGL 213','ENGL 213H','ENGL 224H','ENGL 251','ENGL 293H','ITAL 102','JPN 102','SPAN 102')
      AND p.course_code IN ('ENGL 101','ENGL 101E','ENGL 101H','ITAL 101','JPN 101','SPAN 101');

-- D: d_social_political_and prerequisites
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ECON 102' AND p.course_code IN ('ECON 101','ECON 101H');
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 203' AND p.course_code IN ('PSY 101','PSY 101H','MATH 165','MATH 165H','PSY 103');
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 212' AND p.course_code IN ('PSY 101','PSY 101H');

-- Major Courses prerequisites (from major_courses)
INSERT INTO prerequisites (course_id, prereq_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code IN ('CS 232','CS 242','CS 252') AND p.course_code = 'CS 225';

-- (7) Mark Honors Courses
INSERT INTO honors_courses (course_id)
  SELECT id FROM courses WHERE course_code IN 
    ('SPCH 100H','SPCH 101H','ENGL 101H','ENGL 103H','ENGL 104H','THEA 101H','HIST 107H','HIST 108H','POLI 103H');

-- (8) Insert University Recommended Courses
-- Only insert if the recommendation text (from the original course_strongly_recommended field)
-- indicates a valid course code recommendation.
-- A1: a1_oral_communication recommendations
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'SPCH 100' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'SPCH 100H' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'SPCH 101' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'SPCH 101H' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'SPCH 103' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'SPCH 106' AND p.course_code = 'ENGL 101';

-- A3: a3_critical_thinking recommendations
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHIL 110' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHIL 210' AND p.course_code = 'ENGL 101';

-- B1: b1_physical_sciences recommendations (only those with valid course codes)
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ASTR 116' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ASTR 117' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'CHEM 110' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 110' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 119' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 120' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 121' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 122' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 124' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ESCI 130' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'GEOG 118' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'GEOG 130' AND p.course_code = 'ENGL 101';
-- PHYS 109 recommends both MATH 160 and ENGL 101:
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 109' AND p.course_code = 'MATH 160';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 109' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 110' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 110H' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 111' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 112' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PHYS 202' AND p.course_code = 'MATH 210';

-- B2: b2_biological_sciences recommendations
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ANTH 212' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ANTH 212L' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 102' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 105' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 105H' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 108' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 110' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 117' AND p.course_code = 'ENGL 101';
-- For BIOL 145, insert mappings for both BIOL 105 (or BIOL 105H) and ENGL 101:
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 145' AND p.course_code = 'BIOL 105';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 145' AND p.course_code = 'BIOL 105H';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOL 145' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOT 107' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'BIOT 108' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'FOR 102' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 102' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 102' AND p.course_code = 'ENGL 101H';

-- B4: b4_mathematics_quantitative_reasoning recommendation
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 103' AND p.course_code = 'ENGL 101';

-- C1: c1_arts recommendations
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 100' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 100A' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 100AH' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 100B' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 100BH' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 101' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 112' AND p.course_code = 'ART 111';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ART 130' AND p.course_code IN ('ART 111','ENGL 101');

-- C2: c2_humanities recommendations
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 213' AND p.course_code IN ('ENGL 103','ENGL 103H');
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 213H' AND p.course_code IN ('ENGL 103','ENGL 103H');
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 224H' AND p.course_code IN ('ENGL 103','ENGL 103H');
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 251' AND p.course_code = 'ENGL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ENGL 293H' AND p.course_code IN ('ENGL 103','ENGL 103H');
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ITAL 102' AND p.course_code = 'ITAL 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'JPN 102' AND p.course_code = 'JPN 101';
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'SPAN 102' AND p.course_code = 'SPAN 101';

-- D: d_social_political_and recommendations
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'ECON 102' AND p.course_code IN ('ECON 101','ECON 101H');
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 203' AND p.course_code IN ('PSY 101','PSY 101H','MATH 165','MATH 165H','PSY 103');
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code = 'PSY 212' AND p.course_code IN ('PSY 101','PSY 101H');

-- Major Courses recommendations (example from CS courses)
INSERT IGNORE INTO university_recommended_courses (course_id, recommended_course_id)
  SELECT c.id, p.id FROM courses c, courses p WHERE c.course_code IN ('CS 232','CS 242','CS 252') AND p.course_code = 'CS 225';

COMMIT;