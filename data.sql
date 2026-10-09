-- ==========================================
-- POPULATE DATA
-- ==========================================

INSERT INTO departments (name) VALUES 
('Human Resources'), ('Engineering'), ('Sales'), ('Operations');

-- Generate realistic PII for Employees
INSERT INTO employees (first_name, last_name, email, phone, ssn, dob, department_id) VALUES
('Alice', 'Smith', 'asmith@company.local', '555-0101', '123-45-6789', '1985-03-12', 1),
('Bob', 'Johnson', 'bjohnson@company.local', '555-0102', '987-65-4321', '1990-07-22', 2),
('Charlie', 'Davis', 'cdavis@company.local', '555-0103', '456-78-1234', '1988-11-05', 2),
('Diana', 'Prince', 'dprince@company.local', '555-0104', '321-65-0987', '1992-01-30', 3),
('Evan', 'Wright', 'ewright@company.local', '555-0105', '654-32-1098', '1979-09-18', 4),
('Fiona', 'Gallagher', 'fgallagher@company.local', '555-0106', '789-01-2345', '1995-04-25', 2);

-- Insert Grievances
INSERT INTO grievances (reporter_id, accused_id, category, incident_date, status) VALUES
(2, 3, 'Workplace Harassment', '2026-09-15', 'Under Investigation'),
(4, NULL, 'Compensation Policy', '2026-10-01', 'Open'),
(5, 1, 'Unprofessional Conduct', '2026-09-28', 'Closed'),
(6, 3, 'Code Authorship Theft', '2026-10-04', 'Open');

-- Insert Comments and Remarks
INSERT INTO remarks (grievance_id, author_id, remark_text, created_at) VALUES
(1, 2, 'Charlie repeatedly interrupted my presentation and made derogatory comments about my code quality in front of the client.', '2026-09-16 09:00:00'),
(1, 1, 'Initial meeting held with Bob. He provided Slack transcripts as evidence.', '2026-09-17 14:30:00'),
(1, 3, 'I was merely pointing out critical security flaws. I apologize if my tone was perceived as harsh.', '2026-09-18 10:15:00'),
(2, 4, 'The new Q4 commission structure unfairly penalizes enterprise sales reps with long sales cycles.', '2026-10-01 11:00:00'),
(2, 1, 'Forwarded to the Compensation Committee for Q4 review.', '2026-10-02 09:45:00'),
(3, 5, 'Alice dismissed my PTO request without review and cited "department needs" despite ample coverage.', '2026-09-28 16:20:00'),
(3, 1, 'The PTO request overlapped with the annual system migration weekend. Policy dictates a blackout period.', '2026-09-29 11:00:00'),
(4, 6, 'Charlie merged my PR into the main branch under his own account, stripping my commit history.', '2026-10-04 15:30:00');

-- Optional: Generate bulk filler data for volume testing (adds 50 generic grievances)
INSERT INTO grievances (reporter_id, accused_id, category, incident_date)
SELECT 
    (floor(random() * 6) + 1)::int, 
    NULL, 
    'General Complaint', 
    CURRENT_DATE - (random() * 365)::int
FROM generate_series(1, 50);

-- Add more departments
INSERT INTO departments (name) VALUES 
('Marketing'), ('Legal'), ('IT Support'), ('Finance');

-- Insert 15 more employees with PII
INSERT INTO employees (first_name, last_name, email, phone, ssn, dob, department_id) VALUES
('George', 'Miller', 'gmiller@company.local', '555-0201', '111-22-3333', '1982-05-14', 5),
('Hannah', 'Lee', 'hlee@company.local', '555-0202', '222-33-4444', '1990-08-21', 6),
('Ian', 'Gomez', 'igomez@company.local', '555-0203', '333-44-5555', '1993-12-02', 7),
('Julia', 'Roberts', 'jroberts@company.local', '555-0204', '444-55-6666', '1986-04-19', 8),
('Kevin', 'Chen', 'kchen@company.local', '555-0205', '555-66-7777', '1991-09-30', 2),
('Laura', 'Wilson', 'lwilson@company.local', '555-0206', '666-77-8888', '1989-11-11', 1),
('Marcus', 'Brown', 'mbrown@company.local', '555-0207', '777-88-9999', '1975-02-28', 3),
('Nina', 'Patel', 'npatel@company.local', '555-0208', '888-99-0000', '1994-07-15', 7),
('Oscar', 'Martinez', 'omartinez@company.local', '555-0209', '999-00-1111', '1980-10-05', 4),
('Rachel', 'Kim', 'rkim@company.local', '555-0210', '000-11-2222', '1996-03-22', 5),
('Sam', 'Taylor', 'staylor@company.local', '555-0211', '123-12-1234', '1984-06-17', 2),
('Tina', 'Fey', 'tfey@company.local', '555-0212', '234-23-2345', '1987-01-09', 1),
('Victor', 'Hugo', 'vhugo@company.local', '555-0213', '345-34-3456', '1992-05-05', 8),
('Wendy', 'Wu', 'wwu@company.local', '555-0214', '456-45-4567', '1995-12-12', 3),
('Xavier', 'Reed', 'xreed@company.local', '555-0215', '567-56-5678', '1988-08-08', 4);

-- Insert targeted grievances referencing the new employee IDs (assuming IDs 7-21 based on previous inserts)
INSERT INTO grievances (reporter_id, accused_id, category, incident_date, status) VALUES
(7, 10, 'Idea Theft', '2026-09-10', 'Under Investigation'),
(9, NULL, 'Equipment Failure', '2026-10-02', 'Open'),
(12, 14, 'Inappropriate Language', '2026-09-20', 'Closed'),
(15, 11, 'Micromanagement', '2026-10-05', 'Open'),
(8, NULL, 'Hostile Environment', '2026-08-15', 'Escalated'),
(18, 19, 'Credit Stealing', '2026-09-28', 'Open'),
(20, 21, 'Unpaid Overtime', '2026-10-01', 'Under Investigation');

-- Insert remarks linking to the new grievances (assuming grievance IDs start around 55 due to the previous generate_series bulk insert)
DO $$
DECLARE
    g_id1 INT; g_id2 INT; g_id3 INT; g_id4 INT; g_id5 INT; g_id6 INT; g_id7 INT;
BEGIN
    -- Fetch the last 7 grievance IDs inserted
    SELECT id INTO g_id1 FROM grievances ORDER BY id DESC OFFSET 6 LIMIT 1;
    SELECT id INTO g_id2 FROM grievances ORDER BY id DESC OFFSET 5 LIMIT 1;
    SELECT id INTO g_id3 FROM grievances ORDER BY id DESC OFFSET 4 LIMIT 1;
    SELECT id INTO g_id4 FROM grievances ORDER BY id DESC OFFSET 3 LIMIT 1;
    SELECT id INTO g_id5 FROM grievances ORDER BY id DESC OFFSET 2 LIMIT 1;
    SELECT id INTO g_id6 FROM grievances ORDER BY id DESC OFFSET 1 LIMIT 1;
    SELECT id INTO g_id7 FROM grievances ORDER BY id DESC LIMIT 1;

    INSERT INTO remarks (grievance_id, author_id, remark_text) VALUES
    (g_id1, 7, 'Julia presented my Q3 marketing strategy as her own during the board meeting.'),
    (g_id1, 10, 'I heavily modified the draft George sent over. The core concepts were my own.'),
    (g_id1, 12, 'HR requires meeting minutes and version history of the document to proceed.'),
    
    (g_id2, 9, 'My issued laptop battery has expanded and is a fire hazard. IT Support has ignored my tickets for 3 weeks.'),
    (g_id2, 14, 'A replacement MacBook Pro has been ordered but is backordered due to supply chain issues.'),
    
    (g_id3, 12, 'Nina used profanity during the sprint planning meeting when her tickets were reprioritized.'),
    (g_id3, 14, 'I was frustrated but the language was not directed at any individual.'),
    (g_id3, 6, 'Mandatory conflict resolution training completed. Closing ticket.'),

    (g_id4, 15, 'Kevin requires me to send hourly updates on my coding progress. It is impeding my actual work.'),
    (g_id4, 11, 'Oscar is currently on a Performance Improvement Plan, which mandates tight supervision.'),
    
    (g_id5, 8, 'The overall atmosphere in the Legal department is highly toxic, with frequent yelling from management.'),
    
    (g_id6, 18, 'Wendy took all the credit for closing the enterprise deal with Acme Corp.'),
    (g_id6, 19, 'I was the primary account executive on the deal.'),
    
    (g_id7, 20, 'Xavier expected me to work through the weekend to finish the end-of-month reconciliation without pay.'),
    (g_id7, 1, 'Reviewing timesheets and provincial labor laws to determine appropriate compensation.');
END $$;
