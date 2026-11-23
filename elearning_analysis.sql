-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS elearning_db;
USE elearning_db;

-- 2. Create tables with Primary and Foreign Keys
CREATE TABLE learners (
    learner_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    Country VARCHAR(60) NOT NULL
);
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(120) NOT NULL,
    category VARCHAR(60) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);
CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    learner_id INT NOT NULL,
    course_id INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    purchase_date DATE NOT NULL,
    CONSTRAINT fk_purchases_learner
        FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    CONSTRAINT fk_purchases_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 3. Insert sample data (5 learners, 5 courses, 7 purchases)
INSERT INTO learners (full_name, Country) VALUES
('Amina Al Mansoori', 'UAE'),
('Liam OConnor', 'Ireland'),
('Priya Nair', 'India'),
('Mateo Silva', 'Brazil'),
('Hannah Kim', 'South Korea');

INSERT INTO courses (course_name, category, unit_price) VALUES
('MySQL for Data Analysts', 'Data & Databases', 49.99),
('Python Data Science Bootcamp', 'Programming', 79.50),
('Tableau Visual Analytics', 'Data & Databases', 59.00),
('Web Development Foundations', 'Programming', 69.00),
('Cloud Architecture Basics', 'Cloud Computing', 89.99); -- Intentionally unpurchased for Q5

INSERT INTO purchases (learner_id, course_id, Quantity, purchase_date) VALUES
(1, 1, 1, '2026-01-10'),
(1, 2, 1, '2026-01-18'), -- Amina buys from 2 categories (Data & Databases, Programming)
(2, 1, 2, '2026-02-02'),
(2, 3, 1, '2026-02-14'),
(3, 2, 2, '2026-02-20'),
(4, 4, 1, '2026-03-05'),
(5, 1, 1, '2026-03-12');

-- INNER JOIN - Purchase Details (Sorted by Highest Total Amount First)
SELECT
    l.full_name AS learner_name,
    l.Country AS country,
    c.course_name,
    c.category,
    p.Quantity AS quantity,
    CAST((p.Quantity * c.unit_price) AS DECIMAL(10, 2)) AS total_amount,
    p.purchase_date
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
ORDER BY total_amount DESC, p.purchase_date DESC;

-- LEFT JOIN — All Learners & Their Purchase Details
SELECT
    l.learner_id,
    l.full_name AS learner_name,
    l.Country AS country,
    c.course_name,
    c.category,
    COALESCE(p.Quantity, 0) AS quantity,
    CAST(COALESCE(p.Quantity * c.unit_price, 0) AS DECIMAL(10, 2)) AS total_amount,
    p.purchase_date
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON p.course_id = c.course_id
ORDER BY total_amount DESC, l.full_name ASC;

-- RIGHT JOIN — All Courses & Associated Purchases
SELECT
    c.course_id,
    c.course_name,
    c.category,
    CAST(c.unit_price AS DECIMAL(10, 2)) AS unit_price,
    l.full_name AS learner_name,
    COALESCE(p.Quantity, 0) AS quantity,
    CAST(COALESCE(p.Quantity * c.unit_price, 0) AS DECIMAL(10, 2)) AS total_amount,
    p.purchase_date
FROM purchases p
RIGHT JOIN courses c ON p.course_id = c.course_id
LEFT JOIN learners l ON p.learner_id = l.learner_id
ORDER BY c.course_id ASC, p.purchase_date DESC;

-- Q1. Total Spending per Learner Along with Their Country
SELECT
    l.learner_id,
    l.full_name AS learner_name,
    l.Country AS country,
    CAST(COALESCE(SUM(p.Quantity * c.unit_price), 0) AS DECIMAL(10, 2)) AS total_spending
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.Country
ORDER BY total_spending DESC;

-- Q2. Top 3 Most Purchased Courses by Total Quantity Sold
SELECT
    c.course_id,
    c.course_name,
    c.category,
    SUM(p.Quantity) AS total_quantity_sold,
    CAST(SUM(p.Quantity * c.unit_price) AS DECIMAL(10, 2)) AS total_revenue
FROM courses c
INNER JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name, c.category
ORDER BY total_quantity_sold DESC, total_revenue DESC
LIMIT 3;

-- Q3. Total Revenue & Unique Learners per Course Category
SELECT
    c.category,
    CAST(COALESCE(SUM(p.Quantity * c.unit_price), 0) AS DECIMAL(10, 2)) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY total_revenue DESC;

-- Q4. Learners Who Purchased Courses from More Than One Category
SELECT
    l.learner_id,
    l.full_name AS learner_name,
    l.Country AS country,
    COUNT(DISTINCT c.category) AS categories_purchased,
    CAST(SUM(p.Quantity * c.unit_price) AS DECIMAL(10, 2)) AS total_spending
FROM learners l
INNER JOIN purchases p ON l.learner_id = p.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.Country
HAVING COUNT(DISTINCT c.category) > 1
ORDER BY categories_purchased DESC, total_spending DESC;

-- Q5. Courses That Have Not Been Purchased at All
SELECT
    c.course_id,
    c.course_name,
    c.category,
    CAST(c.unit_price AS DECIMAL(10, 2)) AS unit_price
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL
ORDER BY c.course_name ASC;
