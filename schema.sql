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

INSERT INTO modules (name, description) 
VALUES ('Accessing Funding & Loans', 'Learn how to secure funding, loans, and financial support for your business.');

SET @module_id = (SELECT id FROM modules WHERE name = 'Accessing Funding & Loans' LIMIT 1);

INSERT INTO chapters (module_id, chapter_number, title, description) VALUES
(@module_id, 1, 'Understanding Business Financing', 'Learn about different funding options available for entrepreneurs.'),
(@module_id, 2, 'How to Apply for Business Loans', 'Step-by-step guide to applying for loans from banks and financial institutions.'),
(@module_id, 3, 'Government Grants & Support', 'Explore government programs that provide funding and resources for small businesses.'),
(@module_id, 4, 'Pitching to Investors', 'Learn how to create a compelling pitch for investors and venture capitalists.'),
(@module_id, 5, 'Managing Business Debt', 'Strategies to manage and repay business loans effectively.');


SET @ch1 = (SELECT id FROM chapters WHERE title = 'Understanding Business Financing' LIMIT 1);
SET @ch2 = (SELECT id FROM chapters WHERE title = 'How to Apply for Business Loans' LIMIT 1);
SET @ch3 = (SELECT id FROM chapters WHERE title = 'Government Grants & Support' LIMIT 1);
SET @ch4 = (SELECT id FROM chapters WHERE title = 'Pitching to Investors' LIMIT 1);
SET @ch5 = (SELECT id FROM chapters WHERE title = 'Managing Business Debt' LIMIT 1);

-- Chapter 1: Understanding Business Financing

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch1, 'text', 'Business financing is the process of securing funds to start, operate, or expand a business. These funds can come from various sources, including loans, grants, investors, and personal savings. Understanding the different financing options available is crucial for making informed financial decisions that align with business goals. Entrepreneurs should evaluate the costs, repayment terms, and risks associated with each financing method before making a commitment.', 1),
(@ch1, 'example', 'A bakery owner seeks to expand their business by purchasing new equipment. After evaluating different financing options, they choose a microloan with low interest rates, allowing them to grow their operations while maintaining financial stability.', 2),
(@ch1, 'tip', 'Always compare multiple financing options, considering factors like interest rates, repayment terms, and eligibility criteria to find the best fit for your business needs.', 3);

-- Chapter 2: How to Apply for Business Loans

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch2, 'text', 'Applying for a business loan requires careful planning and documentation. Lenders assess factors such as credit history, business financial statements, cash flow, and the purpose of the loan. Entrepreneurs must prepare a well-structured business plan outlining their revenue model, market opportunity, and repayment strategy to improve their chances of approval.', 1),
(@ch2, 'example', 'A clothing brand owner applies for a loan to open a new store. They provide the bank with a solid business plan, revenue projections, and evidence of steady sales growth, demonstrating their ability to repay the loan.', 2),
(@ch2, 'tip', 'Maintain a good credit score and organize all necessary financial documents before applying to increase your chances of approval.', 3);

-- Chapter 3: Government Grants & Support

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch3, 'text', 'Governments offer grants and funding programs to support small businesses and startups. Unlike loans, grants do not require repayment, making them an attractive financing option. However, grant applications often require businesses to meet specific criteria, such as innovation, job creation, or social impact. Researching available grants and preparing strong applications can increase the likelihood of securing funding.', 1),
(@ch3, 'example', 'A tech startup focused on renewable energy receives funding through a government innovation grant, allowing them to develop new sustainable solutions without taking on debt.', 2),
(@ch3, 'tip', 'Check eligibility requirements, application deadlines, and required documentation before applying for government grants.', 3);

-- Chapter 4: Pitching to Investors

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch4, 'text', 'Securing funding from investors requires a compelling pitch that highlights the uniqueness of your business, its market potential, and financial viability. Investors look for businesses with a clear value proposition, scalable business model, and strong leadership. A well-prepared pitch should include market research, competitive analysis, and realistic financial projections.', 1),
(@ch4, 'example', 'A coffee startup with a sustainable sourcing model successfully secures funding by demonstrating its impact on both consumers and coffee farmers, emphasizing its competitive edge and projected revenue growth.', 2),
(@ch4, 'tip', 'Keep your pitch concise, focus on the problem your business solves, and anticipate investor questions to improve your chances of securing funding.', 3);

-- Chapter 5: Managing Business Debt

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch5, 'text', 'Effective debt management is essential for maintaining financial health and ensuring business sustainability. Businesses should track their outstanding debts, prioritize high-interest loans, and explore refinancing options when necessary. Having a clear repayment plan helps prevent financial strain and ensures that debt does not hinder business growth.', 1),
(@ch5, 'example', 'A restaurant owner with multiple loans consolidates their debt under a single lower-interest loan, reducing monthly payments and improving cash flow management.', 2),
(@ch5, 'tip', 'Prioritize paying off high-interest debt first and negotiate with lenders for better repayment terms if needed.', 3);
