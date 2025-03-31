CREATE DATABASE IF NOT EXISTS igire;
USE igire;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(64) NOT NULL,  -- SHA-256 produces 64-character hashes
    name VARCHAR(100) NOT NULL,
    age INT,
    business_interest VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE modules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chapters table (new)
CREATE TABLE chapters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    chapter_number INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (module_id) REFERENCES modules(id),
    UNIQUE KEY (module_id, chapter_number)
);

-- Content table (new)
CREATE TABLE content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chapter_id INT NOT NULL,
    content_type ENUM('text', 'example', 'tip') NOT NULL,
    content_text TEXT NOT NULL,
    display_order INT NOT NULL,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id)
);

-- Updated questions table (now links to chapters)
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chapter_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    explanation TEXT,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id)
);

-- Topic progress table
CREATE TABLE progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    module VARCHAR(50) NOT NULL,
    topic_id INT NOT NULL,
    score INT DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_progress (user_id, module, topic_id)
);

