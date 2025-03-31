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


-- Questions for Chapter 1: Understanding Business Financing

INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation)
VALUES 
(@ch1, 'What is the primary goal of business financing?', 
    'To increase company expenses', 
    'To secure funds for starting, operating, or expanding a business', 
    'To reduce competition in the market', 
    'B', 
    'Business financing is used to secure funds to start, operate, or grow a business.'),
(@ch1, 'Which of the following is NOT a common source of business financing?', 
    'Loans', 
    'Personal savings', 
    'Business competitors', 
    'C', 
    'Competitors typically do not provide financing. Common sources include loans, grants, investors, and savings.');

-- Questions for Chapter 2: How to Apply for Business Loans

INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation)
VALUES 
(@ch2, 'What is the key factor lenders assess before approving a business loan?', 
    'The business logo design', 
    'Credit history and financial stability', 
    'The number of employees', 
    'B', 
    'Lenders evaluate credit history, financial statements, and cash flow before approving a loan.'),
(@ch2, 'Which document is crucial when applying for a business loan?', 
    'A well-structured business plan', 
    'A list of favorite books', 
    'A personal diary', 
    'A', 
    'A well-structured business plan outlining financial projections, market strategy, and repayment plans is essential.');

-- Questions for Chapter 3: Government Grants & Support

    INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation)
VALUES 
(@ch3, 'What is the main advantage of government grants over business loans?', 
    'Grants do not require repayment', 
    'Grants are given to all applicants', 
    'Grants come with fewer eligibility requirements', 
    'A', 
    'Unlike loans, grants do not require repayment, making them an attractive financing option.'),
(@ch3, 'What is a key requirement when applying for most government grants?', 
    'Having a registered business', 
    'Having a high personal income', 
    'Selling a certain number of products', 
    'A', 
    'Many grants require businesses to be officially registered and meet specific criteria.');


-- Questions for Chapter 4: Pitching to Investors
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation)
VALUES 
(@ch4, 'What is a crucial element of a strong business pitch to investors?', 
    'A clear value proposition', 
    'A long and complicated financial report', 
    'A large team of employees', 
    'A', 
    'Investors look for a clear value proposition that shows how a business stands out in the market.'),
(@ch4, 'Which factor is most important for investors when considering funding a startup?', 
    'The founder’s fashion style', 
    'Market potential and financial viability', 
    'The company’s office location', 
    'B', 
    'Investors prioritize businesses with strong market potential and solid financial viability.');

-- Questions for Chapter 5: Managing Business Debt
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation)
VALUES 
(@ch5, 'What is a good strategy for managing business debt?', 
    'Prioritizing high-interest loans', 
    'Ignoring debt until it becomes urgent', 
    'Taking on more loans to pay off existing ones', 
    'A', 
    'Businesses should prioritize paying off high-interest loans first to reduce financial burden.'),
(@ch5, 'How can a business reduce its debt repayment burden?', 
    'By consolidating debt into a single lower-interest loan', 
    'By avoiding all business expenses', 
    'By firing all employees', 
    'A', 
    'Consolidating debt helps businesses lower their overall interest payments and improve cash flow management.');


-- Insert Business Planning Module
INSERT INTO modules (name, description) 
VALUES ('Business Planning & Management', 'Learn essential business planning skills and management strategies for your enterprise.');

SET @module_id = (SELECT id FROM modules WHERE name = 'Business Planning & Management' LIMIT 1);

-- Insert Chapters
INSERT INTO chapters (module_id, chapter_number, title, description) VALUES
(@module_id, 1, 'Business Model Canvas', 'Understanding and creating your business model using the canvas framework'),
(@module_id, 2, 'Market Analysis', 'Learn how to analyze your target market and competition'),
(@module_id, 3, 'Financial Planning', 'Essential financial planning and management for your business'),
(@module_id, 4, 'Operations Management', 'Setting up and managing business operations effectively'),
(@module_id, 5, 'Risk Assessment', 'Identifying and managing business risks');

-- Reset chapter variables specifically for Business Planning module
SET @ch1 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 1 LIMIT 1);
SET @ch2 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 2 LIMIT 1);
SET @ch3 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 3 LIMIT 1);
SET @ch4 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 4 LIMIT 1);
SET @ch5 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 5 LIMIT 1);

-- Questions for Business Planning & Management chapters

-- Chapter 1: Business Model Canvas
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) 
VALUES 
(@ch1, 'What is the primary purpose of the Business Model Canvas?', 
    'To design a company logo', 
    'To visualize and develop a business model', 
    'To hire employees', 
    'B', 
    'The Business Model Canvas helps visualize and structure all key elements of a business model.');

-- Chapter 2: Market Analysis
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) 
VALUES 
(@ch2, 'Why is market analysis important?', 
    'To identify market opportunities and challenges', 
    'To design business cards', 
    'To hire employees', 
    'A', 
    'Market analysis helps businesses understand opportunities and potential challenges in their target market.');

-- Chapter 3: Financial Planning
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) 
VALUES 
(@ch3, 'What is a key component of financial planning?', 
    'Choosing office furniture', 
    'Cash flow management', 
    'Selecting a company name', 
    'B', 
    'Cash flow management is crucial for maintaining financial health and supporting growth.');

-- Chapter 4: Operations Management
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) 
VALUES 
(@ch4, 'What does operations management involve?', 
    'Managing daily business activities', 
    'Planning office parties', 
    'Designing logos', 
    'A', 
    'Operations management involves organizing and overseeing daily business activities.');

-- Chapter 5: Risk Assessment
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) 
VALUES 
(@ch5, 'What is the purpose of risk assessment?', 
    'To avoid all business activities', 
    'To identify and manage potential risks', 
    'To increase risks', 
    'B', 
    'Risk assessment helps identify and develop strategies to manage potential business risks.');

INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation)
VALUES (@ch1, 'Which element is NOT part of the Business Model Canvas?', 
    'Customer Segments', 
    'Employee Salaries', 
    'Value Propositions', 
    'B', 
    'Employee Salaries is not one of the nine elements of the Business Model Canvas.');

-- Continue with other questions in the same pattern...
INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch1, 'text', 'The Business Model Canvas is a strategic tool that helps visualize and develop your business model. It consists of nine key elements: Customer Segments, Value Propositions, Channels, Customer Relationships, Revenue Streams, Key Resources, Key Activities, Key Partnerships, and Cost Structure.', 1),
(@ch1, 'example', 'A local bakery uses the Business Model Canvas to identify their key customers (working professionals), value proposition (fresh, organic bread), and distribution channels (local delivery service).', 2),
(@ch1, 'tip', 'Start with your customer segments and value proposition, as these form the foundation of your business model.', 3);

-- Chapter 2: Market Analysis
INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch2, 'text', 'Market analysis involves researching your target market, understanding customer needs, and analyzing competitors. This helps identify market opportunities and potential challenges.', 1),
(@ch2, 'example', 'A clothing boutique conducts market research and discovers an underserved niche for sustainable fashion in their area.', 2),
(@ch2, 'tip', 'Regularly update your market analysis to stay current with changing customer needs and market trends.', 3);

-- Chapter 3: Financial Planning
INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch3, 'text', 'Financial planning involves budgeting, forecasting, and managing cash flow. It helps ensure your business remains financially healthy and can support growth.', 1),
(@ch3, 'example', 'A restaurant owner creates detailed monthly budgets and cash flow projections to manage seasonal fluctuations in business.', 2),
(@ch3, 'tip', 'Keep detailed financial records and regularly review your financial performance against projections.', 3);

-- Chapter 4: Operations Management
INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch4, 'text', 'Operations management involves organizing and overseeing daily business activities. This includes managing resources, processes, and quality control.', 1),
(@ch4, 'example', 'A small manufacturing business implements a quality control system to reduce waste and improve product consistency.', 2),
(@ch4, 'tip', 'Document your operational procedures to maintain consistency and train new employees effectively.', 3);

-- Chapter 5: Risk Assessment
INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch5, 'text', 'Risk assessment involves identifying potential risks to your business and developing strategies to manage them. This includes financial, operational, and market risks.', 1),
(@ch5, 'example', 'A retail store develops a contingency plan for supply chain disruptions after analyzing potential risks.', 2),
(@ch5, 'tip', 'Regularly review and update your risk management strategies as your business grows and changes.', 3);

-- Insert content for Financial Literacy module

-- Chapter 1: Understanding Basic Financial Concepts
SET @module_id = (SELECT id FROM modules WHERE name = 'Financial Literacy' LIMIT 1);
SET @ch1 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 1 LIMIT 1);

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch1, 'text', 'Financial literacy is the ability to understand and effectively use various financial skills, including personal financial management, budgeting, and investing. It is crucial for making informed decisions about money.', 1),
(@ch1, 'example', 'Understanding the difference between saving and investing can help you grow your wealth over time.', 2),
(@ch1, 'tip', 'Start tracking your expenses and income to get a clear picture of your financial situation.', 3);

-- Chapter 2: Budgeting and Expense Tracking
SET @ch2 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 2 LIMIT 1);

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch2, 'text', 'Budgeting involves creating a plan for how you will spend your money. Expense tracking helps you monitor where your money goes and identify areas where you can cut back.', 1),
(@ch2, 'example', 'Using a budgeting app or spreadsheet can simplify the process of tracking your expenses and sticking to your budget.', 2),
(@ch2, 'tip', 'Review your budget regularly and make adjustments as needed to stay on track.', 3);

-- Chapter 3: Savings and Investment Basics
SET @ch3 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 3 LIMIT 1);

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch3, 'text', 'Saving involves setting aside money for future use, while investing involves using money to potentially grow your wealth over time. Understanding the different types of savings and investment accounts is essential.', 1),
(@ch3, 'example', 'Investing in a diversified portfolio of stocks and bonds can help you achieve long-term financial goals.', 2),
(@ch3, 'tip', 'Start saving and investing early to take advantage of compound interest.', 3);

-- Chapter 4: Understanding Credit and Debt
SET @ch4 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 4 LIMIT 1);

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch4, 'text', 'Credit is the ability to borrow money or access goods and services with the understanding that you will pay later. Debt is the amount of money you owe to a lender. Understanding how credit and debt work is crucial for financial health.', 1),
(@ch4, 'example', 'Maintaining a good credit score can help you get better interest rates on loans and credit cards.', 2),
(@ch4, 'tip', 'Pay your bills on time and avoid taking on more debt than you can handle.', 3);

-- Chapter 5: Financial Planning for Business Owners
SET @ch5 = (SELECT id FROM chapters WHERE module_id = @module_id AND chapter_number = 5 LIMIT 1);

INSERT INTO content (chapter_id, content_type, content_text, display_order) VALUES
(@ch5, 'text', 'Financial planning for business owners involves managing business finances, creating financial projections, and securing funding. It is essential for the long-term success of your business.', 1),
(@ch5, 'example', 'Creating a business plan with realistic financial projections can help you attract investors and secure funding.', 2),
(@ch5, 'tip', 'Regularly review your financial statements and make adjustments as needed to ensure your business remains profitable.', 3);

-- Questions for Financial Literacy Module

-- Chapter 1: Understanding Basic Financial Concepts
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) VALUES
(@ch1, 'What is financial literacy?', 'The ability to read financial statements', 'The ability to understand and use financial skills', 'The ability to predict stock market trends', 'B', 'Financial literacy involves understanding and using financial skills for informed decisions.'),
(@ch1, 'Which of the following is a key component of financial literacy?', 'Advanced calculus', 'Budgeting', 'Astrology', 'B', 'Budgeting is a fundamental skill in financial literacy.');

-- Chapter 2: Budgeting and Expense Tracking
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) VALUES
(@ch2, 'What is the purpose of budgeting?', 'To spend money without planning', 'To create a plan for spending money', 'To avoid saving money', 'B', 'Budgeting helps plan how to spend money effectively.'),
(@ch2, 'What does expense tracking help you identify?', 'Areas where you can increase spending', 'Areas where you can reduce spending', 'Areas where you can ignore spending', 'B', 'Expense tracking helps identify areas to cut back on spending.');

-- Chapter 3: Savings and Investment Basics
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) VALUES
(@ch3, 'What is the difference between saving and investing?', 'Saving is for short-term, investing is for long-term growth', 'Saving is risky, investing is safe', 'Saving is for businesses, investing is for individuals', 'A', 'Saving is for short-term needs, while investing is for long-term growth.'),
(@ch3, 'What is compound interest?', 'Interest paid only once', 'Interest earned on both the initial deposit and accumulated interest', 'Interest paid to financial advisors', 'B', 'Compound interest helps your money grow faster over time.');

-- Chapter 4: Understanding Credit and Debt
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) VALUES
(@ch4, 'What is credit?', 'The amount of money you have in your bank account', 'The ability to borrow money or access goods and services with the understanding that you will pay later', 'The total value of your assets', 'B', 'Credit allows you to borrow money or access goods and services on the promise of future payment.'),
(@ch4, 'Why is a good credit score important?', 'It helps you get better interest rates', 'It helps you avoid paying taxes', 'It helps you win the lottery', 'A', 'A good credit score can help you secure better loan and credit card terms.');

-- Chapter 5: Financial Planning for Business Owners
INSERT INTO questions (chapter_id, question_text, option_a, option_b, option_c, correct_option, explanation) VALUES
(@ch5, 'What is the purpose of financial planning for business owners?', 'To avoid paying taxes', 'To manage business finances and secure funding', 'To ignore financial statements', 'B', 'Financial planning helps manage business finances and secure necessary funding.'),
(@ch5, 'What can financial projections help a business owner do?', 'Predict the weather', 'Attract investors and secure funding', 'Avoid hiring employees', 'B', 'Financial projections provide a roadmap for financial success and attract investors.');

-- Insert Financial literacy module and chapters

INSERT INTO modules (name, description) VALUES ('Financial Literacy', 'Learn essential financial skills for personal and business success.');

SET @module_id = (SELECT id FROM modules WHERE name = 'Financial Literacy' LIMIT 1);

INSERT INTO chapters (module_id, chapter_number, title, description) VALUES
(@module_id, 1, 'Understanding Basic Financial Concepts', 'Learn the fundamentals of financial literacy.'),
(@module_id, 2, 'Budgeting and Expense Tracking', 'Master the art of budgeting and tracking expenses.'),
(@module_id, 3, 'Savings and Investment Basics', 'Understand the basics of saving and investing.'),
(@module_id, 4, 'Understanding Credit and Debt', 'Learn how to manage credit and debt effectively.'),
(@module_id, 5, 'Financial Planning for Business Owners', 'Essential financial planning for business success.');