DROP TABLE payment CASCADE CONSTRAINTS;
DROP TABLE feedback CASCADE CONSTRAINTS;
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE ordercombo CASCADE CONSTRAINTS;
DROP TABLE comboitem CASCADE CONSTRAINTS;
DROP TABLE combo CASCADE CONSTRAINTS;
DROP TABLE itemingredient CASCADE CONSTRAINTS;
DROP TABLE ingredient CASCADE CONSTRAINTS;
DROP TABLE orderitem CASCADE CONSTRAINTS;
DROP TABLE item CASCADE CONSTRAINTS;
DROP TABLE dinein CASCADE CONSTRAINTS;
DROP TABLE delivery CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE employee CASCADE CONSTRAINTS;
DROP TABLE branch CASCADE CONSTRAINTS;

CREATE TABLE branch (
    BranchID CHAR(2) PRIMARY KEY,
    Location VARCHAR(50) UNIQUE NOT NULL,
    DateOpened DATE,
    Status VARCHAR(12) CHECK (Status IN ('Construction', 'Active', 'Repairs', 'Closed')) NOT NULL
);

CREATE TABLE employee (
    EmployeeID CHAR(4) PRIMARY KEY,
    EmployeeName VARCHAR(20) UNIQUE NOT NULL,
    Gender CHAR CHECK (Gender IN ('M', 'F')) NOT NULL,
    MonthlySalary NUMERIC(7, 2) CHECK (MonthlySalary >= 2500),
    WeeklyHours NUMERIC(2) CHECK (WeeklyHours >= 40 AND WeeklyHours <= 45),
    HireDate DATE NOT NULL,
    BranchID CHAR(2) NOT NULL,
    JobTitle VARCHAR(13) CHECK (JobTitle IN ('Manager', 'Chef', 'Kitchen Staff', 'Waiter')) NOT NULL,
    JobStatus VARCHAR(6) CHECK (JobStatus IN ('Active', 'Left', 'Fired')) NOT NULL,
    FOREIGN KEY (BranchID) REFERENCES branch(BranchID)
);

CREATE TABLE orders (
    OrderID CHAR(5) PRIMARY KEY,
    BranchID CHAR(2) NOT NULL,
    OrderTime DATE NOT NULL,
    OrderType VARCHAR(8) CHECK (OrderType IN ('Dine In', 'Takeaway', 'Delivery')) NOT NULL, 
    FOREIGN KEY (BranchID) REFERENCES branch(BranchID)
);

CREATE TABLE delivery (
    DeliveryID CHAR(4) PRIMARY KEY,
    OrderID CHAR(5) UNIQUE NOT NULL,
    Location VARCHAR(100) NOT NULL,
    DeliveredTime date NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID)
);

CREATE TABLE dinein (
    ID CHAR(4) PRIMARY KEY,
    OrderID CHAR(5) UNIQUE NOT NULL,
    PersonCount NUMERIC(2) CHECK (PersonCount > 0) NOT NULL,
    TableNumber CHAR(2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID)
);

CREATE TABLE item (
    ItemID CHAR(3) PRIMARY KEY,
    ItemName VARCHAR(20) UNIQUE NOT NULL,
    ItemType VARCHAR(11) CHECK (ItemType IN ('Appetizer', 'Main Course', 'Side', 'Beverage', 'Dessert')) NOT NULL,
    ItemPrice NUMERIC(5, 2) CHECK (ItemPrice > 0) NOT NULL,
    Description VARCHAR(100)
);

CREATE TABLE orderitem (
    OrderID CHAR(5) NOT NULL,
    ItemID CHAR(3) NOT NULL,
    Quantity NUMERIC(3) CHECK (Quantity > 0) NOT NULL,
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES item(ItemID)
);

CREATE TABLE ingredient (
    IngredientID CHAR(3) PRIMARY KEY,
    IngredientName VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE itemingredient (
    ItemID CHAR(3) NOT NULL,
    IngredientID CHAR(3) NOT NULL,
    PRIMARY KEY (ItemID, IngredientID),
    FOREIGN KEY (ItemID) REFERENCES item(ItemID),
    FOREIGN KEY (IngredientID) REFERENCES ingredient(IngredientID)
);

CREATE TABLE combo (
    ComboID CHAR(2) PRIMARY KEY,
    ComboName VARCHAR(30) UNIQUE NOT NULL,
    ComboPrice NUMERIC(5, 2) NOT NULL
);

CREATE TABLE comboitem (
    ComboID CHAR(2) NOT NULL,
    ItemID CHAR(3) NOT NULL,
    PRIMARY KEY (ComboID, ItemID),
    FOREIGN KEY (ComboID) REFERENCES combo(comboID),
    FOREIGN KEY (ItemID) REFERENCES item(ItemID)
);

CREATE TABLE ordercombo (
    OrderID CHAR(5) NOT NULL,
    ComboID CHAR(2) NOT NULL,
    Quantity NUMERIC(3) CHECK (Quantity > 0),
    PRIMARY KEY (OrderID, ComboID),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ComboID) REFERENCES combo(ComboID)
);

CREATE TABLE customer (
    CustomerID CHAR(4) PRIMARY KEY,
    CustomerName VARCHAR(30) NOT NULL,
    CustomerPhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    CustomerEmail VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE payment (
    PaymentID CHAR(4) PRIMARY KEY,
    OrderID CHAR(5) UNIQUE NOT NULL,
    CustomerID CHAR(4) NOT NULL,
    AmountPaid NUMERIC(6, 2) NOT NULL CHECK (AmountPaid > 0),
    Discount NUMERIC(2) CHECK (Discount IN (0, 10, 12, 14, 16, 18, 20)) NOT NULL,
    PaymentMethod CHAR(6) CHECK (PaymentMethod IN ('cash', 'credit', 'online')) NOT NULL,
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID)
);

CREATE TABLE feedback (
    FeedbackID CHAR(5) PRIMARY KEY,
    OrderID CHAR(5) UNIQUE NOT NULL,
    CustomerID CHAR(4) NOT NULL,
    Rating numeric(1, 0) CHECK (Rating IN (1, 2, 3, 4, 5)) NOT NULL,
    content varchar(500) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID)
);

-- Insert data into the branch table
INSERT INTO branch VALUES (1, 'Sunway Pyramid', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Active');
INSERT INTO branch VALUES (2, 'Citta Mall Ara Damansara', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'Active');
INSERT INTO branch VALUES (3, 'Pavilion Mall Bukit Jalil', TO_DATE('2024-09-01', 'YYYY-MM-DD'), 'Active');
INSERT INTO branch VALUES (4, 'Mid Valley Megamall', NULL, 'Construction');
INSERT INTO branch VALUES (5, 'One Utama Shopping Centre', NULL, 'Construction');
INSERT INTO branch VALUES (6, 'The Gardens Mall', NULL, 'Construction');
INSERT INTO branch VALUES (7, 'Suria KLCC', NULL, 'Construction');
INSERT INTO branch VALUES (8, 'Paradigm Mall', NULL, 'Construction');

-- Insert data into the employee table
-- Branch 1 Employees (Sunway Pyramid)
INSERT INTO employee VALUES (1, 'Alice Tan', 'F', 5500.00, 42, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1, 'Manager', 'Active');
INSERT INTO employee VALUES (2, 'Bob Lee', 'M', 2700.00, 40, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1, 'Kitchen Staff', 'Active');
INSERT INTO employee VALUES (3, 'Cathy Wong', 'F', 2700.00, 40, TO_DATE('2024-01-18', 'YYYY-MM-DD'), 1, 'Kitchen Staff', 'Active');
INSERT INTO employee VALUES (4, 'David Lim', 'M', 2700.00, 40, TO_DATE('2024-02-25', 'YYYY-MM-DD'), 1, 'Kitchen Staff', 'Left');
INSERT INTO employee VALUES (5, 'Emma Tan', 'F', 4500.00, 40, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1, 'Chef', 'Active');
INSERT INTO employee VALUES (6, 'Frank Ng', 'M', 4500.00, 40, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1, 'Chef', 'Active');
INSERT INTO employee VALUES (7, 'Grace Yeo', 'F', 2600.00, 40, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1, 'Waiter', 'Active');
INSERT INTO employee VALUES (8, 'Hank Tan', 'M', 2600.00, 40, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1, 'Waiter', 'Active');
INSERT INTO employee VALUES (9, 'Ivy Chan', 'F', 2600.00, 40, TO_DATE('2024-02-15', 'YYYY-MM-DD'), 1, 'Waiter', 'Fired');
INSERT INTO employee VALUES (10, 'Jack Liew', 'M', 2600.00, 40, TO_DATE('2024-02-20', 'YYYY-MM-DD'), 1, 'Waiter', 'Active');
INSERT INTO employee VALUES (31, 'Ella Ng', 'F', 2600.00, 40, TO_DATE('2024-03-01', 'YYYY-MM-DD'), 1, 'Waiter', 'Active');
INSERT INTO employee VALUES (32, 'Felix Tan', 'M', 2700.00, 40, TO_DATE('2024-03-15', 'YYYY-MM-DD'), 1, 'Kitchen Staff', 'Active');
-- Branch 2 Employees (Citta Mall Ara Damansara)
INSERT INTO employee VALUES (11, 'Karen Teoh', 'F', 5300.00, 42, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 2, 'Manager', 'Active');
INSERT INTO employee VALUES (12, 'Leo Tan', 'M', 2600.00, 40, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 2, 'Kitchen Staff', 'Active');
INSERT INTO employee VALUES (13, 'Mona Goh', 'F', 2600.00, 40, TO_DATE('2024-06-02', 'YYYY-MM-DD'), 2, 'Kitchen Staff', 'Active');
INSERT INTO employee VALUES (14, 'Nathan Chew', 'M', 2600.00, 40, TO_DATE('2024-06-09', 'YYYY-MM-DD'), 2, 'Kitchen Staff', 'Fired');
INSERT INTO employee VALUES (15, 'Olivia Tan', 'F', 4300.00, 40, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 2, 'Chef', 'Active');
INSERT INTO employee VALUES (16, 'Paul Lim', 'M', 4300.00, 40, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 2, 'Chef', 'Active');
INSERT INTO employee VALUES (17, 'Quinn Lau', 'F', 2500.00, 40, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 2, 'Waiter', 'Active');
INSERT INTO employee VALUES (18, 'Ryan Soh', 'M', 2500.00, 40, TO_DATE('2024-06-03', 'YYYY-MM-DD'), 2, 'Waiter', 'Active');
INSERT INTO employee VALUES (19, 'Sophie Tan', 'F', 2500.00, 40, TO_DATE('2024-06-10', 'YYYY-MM-DD'), 2, 'Waiter', 'Left');
INSERT INTO employee VALUES (20, 'Tom Ng', 'M', 2500.00, 40, TO_DATE('2024-06-28', 'YYYY-MM-DD'), 2, 'Waiter', 'Active');
INSERT INTO employee VALUES (33, 'Gina Wong', 'F', 2500.00, 40, TO_DATE('2024-07-01', 'YYYY-MM-DD'), 2, 'Waiter', 'Active');
INSERT INTO employee VALUES (34, 'Harry Lim', 'M', 4300.00, 40, TO_DATE('2024-07-05', 'YYYY-MM-DD'), 2, 'Chef', 'Active');
-- Branch 3 Employees (Pavilion Mall Bukit Jalil)
INSERT INTO employee VALUES (21, 'Uma Liew', 'F', 5100.00, 42, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Manager', 'Active');
INSERT INTO employee VALUES (22, 'Victor Tan', 'M', 2500.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Kitchen Staff', 'Active');
INSERT INTO employee VALUES (23, 'Wendy Ho', 'F', 2500.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Kitchen Staff', 'Active');
INSERT INTO employee VALUES (24, 'Xander Lim', 'M', 2500.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Kitchen Staff', 'Fired');
INSERT INTO employee VALUES (25, 'Yara Leong', 'F', 4100.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Chef', 'Active');
INSERT INTO employee VALUES (26, 'Zane Koh', 'M', 4100.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Chef', 'Active');
INSERT INTO employee VALUES (27, 'Abby Gan', 'F', 2500.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Waiter', 'Active');
INSERT INTO employee VALUES (28, 'Brian Chin', 'M', 2500.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Waiter', 'Active');
INSERT INTO employee VALUES (29, 'Chloe Chan', 'F', 2500.00, 40, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 3, 'Waiter', 'Left');
INSERT INTO employee VALUES (30, 'Derek Ong', 'M', 2500.00, 40, TO_DATE('2024-09-28', 'YYYY-MM-DD'), 3, 'Waiter', 'Active');
INSERT INTO employee VALUES (35, 'Irene Tan', 'F', 2500.00, 40, TO_DATE('2024-10-01', 'YYYY-MM-DD'), 3, 'Waiter', 'Active');
INSERT INTO employee VALUES (36, 'Jason Liew', 'M', 2500.00, 40, TO_DATE('2024-10-10', 'YYYY-MM-DD'), 3, 'Kitchen Staff', 'Active');


-- Insert data into the orders table
INSERT INTO orders VALUES (1, 1, TO_DATE('2024-12-01 11:05', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (2, 1, TO_DATE('2024-12-01 12:15', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (3, 1, TO_DATE('2024-12-01 13:25', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (4, 1, TO_DATE('2024-12-01 14:40', 'YYYY-MM-DD HH24:MI'), 'Takeaway');
INSERT INTO orders VALUES (5, 1, TO_DATE('2024-12-01 15:55', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (6, 1, TO_DATE('2024-12-01 17:10', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (7, 1, TO_DATE('2024-12-01 18:30', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (8, 1, TO_DATE('2024-12-01 19:45', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (9, 1, TO_DATE('2024-12-01 21:05', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (10, 1, TO_DATE('2024-12-01 22:30', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (11, 2, TO_DATE('2024-12-01 11:10', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (12, 2, TO_DATE('2024-12-01 12:20', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (13, 2, TO_DATE('2024-12-01 13:30', 'YYYY-MM-DD HH24:MI'), 'Takeaway');
INSERT INTO orders VALUES (14, 2, TO_DATE('2024-12-01 14:45', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (15, 2, TO_DATE('2024-12-01 16:00', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (16, 2, TO_DATE('2024-12-01 17:20', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (17, 2, TO_DATE('2024-12-01 18:40', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (18, 2, TO_DATE('2024-12-01 19:50', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (19, 2, TO_DATE('2024-12-01 21:15', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (20, 2, TO_DATE('2024-12-01 22:40', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (21, 3, TO_DATE('2024-12-01 11:20', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (22, 3, TO_DATE('2024-12-01 12:35', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (23, 3, TO_DATE('2024-12-01 13:45', 'YYYY-MM-DD HH24:MI'), 'Takeaway');
INSERT INTO orders VALUES (24, 3, TO_DATE('2024-12-01 15:00', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (25, 3, TO_DATE('2024-12-01 16:10', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (26, 3, TO_DATE('2024-12-01 17:25', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (27, 3, TO_DATE('2024-12-01 18:50', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (28, 3, TO_DATE('2024-12-01 20:05', 'YYYY-MM-DD HH24:MI'), 'Dine In');
INSERT INTO orders VALUES (29, 3, TO_DATE('2024-12-01 21:30', 'YYYY-MM-DD HH24:MI'), 'Delivery');
INSERT INTO orders VALUES (30, 3, TO_DATE('2024-12-01 22:50', 'YYYY-MM-DD HH24:MI'), 'Delivery');

-- Insert data into the delivery table with updated locations
INSERT INTO delivery VALUES (1, 2, 'No. 12, Jalan PJS 11/10, Bandar Sunway, 47500 Subang Jaya, Selangor', TO_DATE('2024-12-01 12:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (2, 6, 'No. 19, Jalan PJU 1A/5, Ara Damansara, 47301 Petaling Jaya, Selangor', TO_DATE('2024-12-01 17:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (3, 9, 'No. 15, Jalan Bukit Raja, Shah Alam, 40460 Selangor', TO_DATE('2024-12-01 22:15', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (4, 12, 'No. U16/24B, Jalan Elektron, Denai Alam, 40160 Shah Alam, Selangor', TO_DATE('2024-12-01 12:50', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (5, 17, 'No. 35, Jalan Bukit Jelutong, Bukit Jelutong, 40150 Shah Alam, Selangor', TO_DATE('2024-12-01 19:10', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (6, 19, 'No. 50, Jalan PJU 1A/25, Ara Damansara, 47301 Petaling Jaya, Selangor', TO_DATE('2024-12-01 21:50', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (7, 27, 'No. 7, Jalan Elmina, Elmina, 40100 Shah Alam, Selangor', TO_DATE('2024-12-01 19:20', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (8, 29, 'No. 9, Jalan SS 15/4, Subang Jaya, 47500 Selangor', TO_DATE('2024-12-01 20:30', 'YYYY-MM-DD HH24:MI'));
INSERT INTO delivery VALUES (9, 30, 'No. 25, Jalan USJ 10/1, Taipan, 47620 Subang Jaya, Selangor', TO_DATE('2024-12-01 22:00', 'YYYY-MM-DD HH24:MI'));

-- Insert data into the dinein table
INSERT INTO dinein VALUES (1, 1, 1, 1);
INSERT INTO dinein VALUES (2, 3, 2, 2);
INSERT INTO dinein VALUES (3, 5, 4, 3);
INSERT INTO dinein VALUES (4, 7, 2, 4);
INSERT INTO dinein VALUES (5, 8, 1, 5);
INSERT INTO dinein VALUES (6, 10, 4, 6);
INSERT INTO dinein VALUES (7, 11, 6, 7);
INSERT INTO dinein VALUES (8, 14, 8, 8);
INSERT INTO dinein VALUES (9, 15, 2, 9);
INSERT INTO dinein VALUES (10, 16, 2, 1);
INSERT INTO dinein VALUES (11, 18, 2, 2);
INSERT INTO dinein VALUES (12, 20, 4, 3);
INSERT INTO dinein VALUES (13, 21, 3, 4);
INSERT INTO dinein VALUES (14, 22, 3, 5);
INSERT INTO dinein VALUES (15, 24, 4, 6);
INSERT INTO dinein VALUES (16, 25, 2, 7);
INSERT INTO dinein VALUES (17, 26, 8, 8);
INSERT INTO dinein VALUES (18, 28, 9, 9);

-- Insert data into the item table
-- Appetizers
INSERT INTO item VALUES (1, 'Bruschetta', 'Appetizer', 12.00, 'Toasted baguette slices topped with fresh tomatoes and garlic.');
INSERT INTO item VALUES (2, 'Crispy Calamari', 'Appetizer', 18.00, 'Lightly breaded calamari served with tangy aioli.');
INSERT INTO item VALUES (3, 'Spring Rolls', 'Appetizer', 18.00, 'Crispy vegetable rolls with sweet chili dipping sauce.');
INSERT INTO item VALUES (4, 'Chicken Satay', 'Appetizer', 14.00, 'Grilled chicken skewers with peanut sauce.');
-- Main Courses
INSERT INTO item VALUES (5, 'Grilled Salmon', 'Main Course', 38.00, 'Fresh salmon served with lemon butter sauce.');
INSERT INTO item VALUES (6, 'Beef Rendang', 'Main Course', 28.00, 'Tender beef slow-cooked in a rich, spiced coconut sauce.');
INSERT INTO item VALUES (7, 'Vegetarian Lasagna', 'Main Course', 26.00, 'Layered pasta with creamy bechamel and roasted vegetables.');
INSERT INTO item VALUES (8, 'Chicken Chop', 'Main Course', 24.00, 'Crispy chicken served with black pepper gravy.');
INSERT INTO item VALUES (9, 'Spaghetti Carbonara', 'Main Course', 22.00, 'Creamy pasta with smoky beef bacon and parmesan.');
INSERT INTO item VALUES (10, 'Lamb Shank', 'Main Course', 45.00, 'Slow-braised lamb in a savory herb and spice reduction.');
-- Sides
INSERT INTO item VALUES (11, 'Mashed Potatoes', 'Side', 10.00, 'Creamy mashed potatoes with a hint of butter.');
INSERT INTO item VALUES (12, 'Pumpkin Rice', 'Side', 12.00, 'Aromatic rice infused with pumpkin and herbs.');
INSERT INTO item VALUES (13, 'French Fries', 'Side', 5.00, 'Crispy golden fries served with a side of ketchup.');
INSERT INTO item VALUES (14, 'Caesar Salad', 'Side', 9.00, 'Crisp romaine lettuce with creamy Caesar dressing, croutons, and parmesan.');
-- Desserts
INSERT INTO item VALUES (15, 'Chocolate Lava Cake', 'Dessert', 18.00, 'Warm molten chocolate cake with vanilla ice cream.');
INSERT INTO item VALUES (16, 'Pavlova', 'Dessert', 16.00, 'Meringue topped with fresh cream and fruits.');
INSERT INTO item VALUES (17, 'Classic Tiramisu', 'Dessert', 20.00, 'Coffee-infused layers of mascarpone and sponge.');
INSERT INTO item VALUES (18, 'Cendol', 'Dessert', 10.00, 'Traditional Malaysian dessert with pandan jelly and gula Melaka.');
INSERT INTO item VALUES (19, 'Classic Cheesecake', 'Dessert', 15.00, 'Creamy cheesecake with a graham cracker crust.');
INSERT INTO item VALUES (20, 'Banoffee Pie', 'Dessert', 17.00, 'Banana and toffee layers with whipped cream.');
-- Beverages
INSERT INTO item VALUES (21, 'Iced Lemon Tea', 'Beverage', 6.00, 'Refreshing tea with a hint of lemon.');
INSERT INTO item VALUES (22, 'Latte', 'Beverage', 10.00, 'Creamy espresso-based coffee.');
INSERT INTO item VALUES (23, 'Mango Smoothie', 'Beverage', 12.00, 'Sweet, fruity blend of ripe mangoes.');
INSERT INTO item VALUES (24, 'Virgin Mojito', 'Beverage', 12.00, 'Lime and mint mocktail, perfect for cooling off.');
INSERT INTO item VALUES (25, 'Chai Latte', 'Beverage', 10.00, 'Spiced tea with frothy milk.');
INSERT INTO item VALUES (26, 'Sparkling Water', 'Beverage', 8.00, 'Refreshing, fizzy, and light.');
INSERT INTO item VALUES (27, 'Hot Chocolate', 'Beverage', 10.00, 'Rich, velvety chocolate drink.');
INSERT INTO item VALUES (28, 'Green Tea', 'Beverage', 6.00, 'Soothing and lightly aromatic.');

-- Insert data into the ingredient table
INSERT INTO ingredient VALUES (1, 'Bread');
INSERT INTO ingredient VALUES (2, 'Tomato');
INSERT INTO ingredient VALUES (3, 'Garlic');
INSERT INTO ingredient VALUES (4, 'Olive Oil');
INSERT INTO ingredient VALUES (5, 'Basil');
INSERT INTO ingredient VALUES (6, 'Squid');
INSERT INTO ingredient VALUES (7, 'Egg');
INSERT INTO ingredient VALUES (8, 'Baking Soda');
INSERT INTO ingredient VALUES (9, 'Salt');
INSERT INTO ingredient VALUES (10, 'Cornstarch');
INSERT INTO ingredient VALUES (11, 'Rice');
INSERT INTO ingredient VALUES (12, 'Peanut Oil');
INSERT INTO ingredient VALUES (13, 'Wrappers');
INSERT INTO ingredient VALUES (14, 'Vermicelli');
INSERT INTO ingredient VALUES (15, 'Chicken');
INSERT INTO ingredient VALUES (16, 'Peanut Sauce');
INSERT INTO ingredient VALUES (17, 'Salmon');
INSERT INTO ingredient VALUES (18, 'Lemon');
INSERT INTO ingredient VALUES (19, 'Butter');
INSERT INTO ingredient VALUES (20, 'Beef');
INSERT INTO ingredient VALUES (21, 'Coconut Milk');
INSERT INTO ingredient VALUES (22, 'Spices');
INSERT INTO ingredient VALUES (23, 'Pasta');
INSERT INTO ingredient VALUES (24, 'Vegetables');
INSERT INTO ingredient VALUES (25, 'Cheese');
INSERT INTO ingredient VALUES (26, 'Tomato Sauce');
INSERT INTO ingredient VALUES (27, 'Chicken Gravy');
INSERT INTO ingredient VALUES (28, 'Beef Bacon');
INSERT INTO ingredient VALUES (29, 'Parmesan');
INSERT INTO ingredient VALUES (30, 'Cream');
INSERT INTO ingredient VALUES (31, 'Lamb');
INSERT INTO ingredient VALUES (32, 'Red Wine');
INSERT INTO ingredient VALUES (33, 'Chocolate');
INSERT INTO ingredient VALUES (34, 'Ice Cream');
INSERT INTO ingredient VALUES (35, 'Meringue');
INSERT INTO ingredient VALUES (36, 'Whipped Cream');
INSERT INTO ingredient VALUES (37, 'Fruits');
INSERT INTO ingredient VALUES (38, 'Mascarpone');
INSERT INTO ingredient VALUES (39, 'Sponge Cake');
INSERT INTO ingredient VALUES (40, 'Pandan Jelly');
INSERT INTO ingredient VALUES (41, 'Gula Melaka');
INSERT INTO ingredient VALUES (42, 'Banana');
INSERT INTO ingredient VALUES (43, 'Toffee');
INSERT INTO ingredient VALUES (44, 'Tea');
INSERT INTO ingredient VALUES (45, 'Lemon Juice');
INSERT INTO ingredient VALUES (46, 'Coffee Beans');
INSERT INTO ingredient VALUES (47, 'Mango');
INSERT INTO ingredient VALUES (48, 'Mint Leaves');
INSERT INTO ingredient VALUES (49, 'Lime');
INSERT INTO ingredient VALUES (50, 'Milk');
INSERT INTO ingredient VALUES (51, 'Carbonated Water');
INSERT INTO ingredient VALUES (52, 'Cocoa Powder');
INSERT INTO ingredient VALUES (53, 'Green Tea Leaves');
INSERT INTO ingredient VALUES (54, 'Honey');
INSERT INTO ingredient VALUES (55, 'Cinnamon');
INSERT INTO ingredient VALUES (56, 'Onion');
INSERT INTO ingredient VALUES (57, 'Garlic Powder');
INSERT INTO ingredient VALUES (58, 'Flour');
INSERT INTO ingredient VALUES (59, 'Vanilla');
INSERT INTO ingredient VALUES (60, 'Sugar');
INSERT INTO ingredient VALUES (61, 'Potato');
INSERT INTO ingredient VALUES (62, 'Pumpkin');
INSERT INTO ingredient VALUES (63, 'Vinegar');
INSERT INTO ingredient VALUES (64, 'Lettuce');
INSERT INTO ingredient VALUES (65, 'Mustard Sauce');

-- Insert data into the itemingedient table
INSERT INTO itemingredient VALUES (1, 1);
INSERT INTO itemingredient VALUES (1, 2);
INSERT INTO itemingredient VALUES (1, 3);
INSERT INTO itemingredient VALUES (1, 4);
INSERT INTO itemingredient VALUES (1, 5);
INSERT INTO itemingredient VALUES (1, 60);
INSERT INTO itemingredient VALUES (2, 6);
INSERT INTO itemingredient VALUES (2, 7);
INSERT INTO itemingredient VALUES (2, 8);
INSERT INTO itemingredient VALUES (2, 9);
INSERT INTO itemingredient VALUES (2, 10);
INSERT INTO itemingredient VALUES (2, 11);
INSERT INTO itemingredient VALUES (2, 12);
INSERT INTO itemingredient VALUES (2, 4);
INSERT INTO itemingredient VALUES (2, 56);
INSERT INTO itemingredient VALUES (3, 13);
INSERT INTO itemingredient VALUES (3, 14);
INSERT INTO itemingredient VALUES (3, 24);
INSERT INTO itemingredient VALUES (3, 9);
INSERT INTO itemingredient VALUES (3, 12);
INSERT INTO itemingredient VALUES (3, 56); 
INSERT INTO itemingredient VALUES (4, 15);
INSERT INTO itemingredient VALUES (4, 16);
INSERT INTO itemingredient VALUES (4, 4);
INSERT INTO itemingredient VALUES (4, 22);
INSERT INTO itemingredient VALUES (4, 56); 
INSERT INTO itemingredient VALUES (5, 17);
INSERT INTO itemingredient VALUES (5, 18);
INSERT INTO itemingredient VALUES (5, 4);
INSERT INTO itemingredient VALUES (5, 19);
INSERT INTO itemingredient VALUES (5, 56); 
INSERT INTO itemingredient VALUES (6, 20);
INSERT INTO itemingredient VALUES (6, 21);
INSERT INTO itemingredient VALUES (6, 22);
INSERT INTO itemingredient VALUES (6, 56);
INSERT INTO itemingredient VALUES (6, 9); 
INSERT INTO itemingredient VALUES (7, 23);
INSERT INTO itemingredient VALUES (7, 24);
INSERT INTO itemingredient VALUES (7, 25);
INSERT INTO itemingredient VALUES (7, 26);
INSERT INTO itemingredient VALUES (7, 4);
INSERT INTO itemingredient VALUES (7, 30);
INSERT INTO itemingredient VALUES (7, 56); 
INSERT INTO itemingredient VALUES (8, 15);
INSERT INTO itemingredient VALUES (8, 27);
INSERT INTO itemingredient VALUES (8, 4);
INSERT INTO itemingredient VALUES (8, 56);
INSERT INTO itemingredient VALUES (8, 22); 
INSERT INTO itemingredient VALUES (9, 23);
INSERT INTO itemingredient VALUES (9, 28);
INSERT INTO itemingredient VALUES (9, 29);
INSERT INTO itemingredient VALUES (9, 4);
INSERT INTO itemingredient VALUES (9, 30);
INSERT INTO itemingredient VALUES (9, 56); 
INSERT INTO itemingredient VALUES (10, 31);
INSERT INTO itemingredient VALUES (10, 32);
INSERT INTO itemingredient VALUES (10, 4);
INSERT INTO itemingredient VALUES (10, 22);
INSERT INTO itemingredient VALUES (10, 56);
INSERT INTO itemingredient VALUES (11, 61);
INSERT INTO itemingredient VALUES (11, 3);
INSERT INTO itemingredient VALUES (11, 50);
INSERT INTO itemingredient VALUES (11, 19);
INSERT INTO itemingredient VALUES (11, 9);
INSERT INTO itemingredient VALUES (12, 11);
INSERT INTO itemingredient VALUES (12, 62);
INSERT INTO itemingredient VALUES (12, 4);
INSERT INTO itemingredient VALUES (13, 61);
INSERT INTO itemingredient VALUES (13, 63);
INSERT INTO itemingredient VALUES (13, 9);
INSERT INTO itemingredient VALUES (13, 12);
INSERT INTO itemingredient VALUES (14, 25);
INSERT INTO itemingredient VALUES (14, 16);
INSERT INTO itemingredient VALUES (14, 3);
INSERT INTO itemingredient VALUES (14, 65);
INSERT INTO itemingredient VALUES (14, 4);
INSERT INTO itemingredient VALUES (15, 33);
INSERT INTO itemingredient VALUES (15, 34);
INSERT INTO itemingredient VALUES (15, 30);
INSERT INTO itemingredient VALUES (15, 59);
INSERT INTO itemingredient VALUES (15, 60); 
INSERT INTO itemingredient VALUES (16, 35);
INSERT INTO itemingredient VALUES (16, 36);
INSERT INTO itemingredient VALUES (16, 37);
INSERT INTO itemingredient VALUES (16, 60); 
INSERT INTO itemingredient VALUES (17, 38);
INSERT INTO itemingredient VALUES (17, 39);
INSERT INTO itemingredient VALUES (17, 46);
INSERT INTO itemingredient VALUES (17, 60); 
INSERT INTO itemingredient VALUES (18, 40);
INSERT INTO itemingredient VALUES (18, 41);
INSERT INTO itemingredient VALUES (18, 60);
INSERT INTO itemingredient VALUES (19, 36);
INSERT INTO itemingredient VALUES (19, 25);
INSERT INTO itemingredient VALUES (19, 59);
INSERT INTO itemingredient VALUES (19, 60); 
INSERT INTO itemingredient VALUES (20, 42);
INSERT INTO itemingredient VALUES (20, 43);
INSERT INTO itemingredient VALUES (20, 36);
INSERT INTO itemingredient VALUES (20, 60); 
INSERT INTO itemingredient VALUES (21, 44);
INSERT INTO itemingredient VALUES (21, 45);
INSERT INTO itemingredient VALUES (21, 54); 
INSERT INTO itemingredient VALUES (22, 46);
INSERT INTO itemingredient VALUES (22, 50);
INSERT INTO itemingredient VALUES (23, 47);
INSERT INTO itemingredient VALUES (23, 50);
INSERT INTO itemingredient VALUES (23, 54); 
INSERT INTO itemingredient VALUES (24, 48);
INSERT INTO itemingredient VALUES (24, 49);
INSERT INTO itemingredient VALUES (24, 54); 
INSERT INTO itemingredient VALUES (25, 44);
INSERT INTO itemingredient VALUES (25, 50);
INSERT INTO itemingredient VALUES (25, 55); 
INSERT INTO itemingredient VALUES (26, 51); 
INSERT INTO itemingredient VALUES (27, 50);
INSERT INTO itemingredient VALUES (27, 52);
INSERT INTO itemingredient VALUES (27, 54); 
INSERT INTO itemingredient VALUES (28, 53);
INSERT INTO itemingredient VALUES (28, 54);

-- Insert data into the combo table
INSERT INTO combo VALUES (1, 'Classic Indulgence', 55.00);
INSERT INTO combo VALUES (2, 'Taste of the Tropics', 44.00);
INSERT INTO combo VALUES (3, 'Veggie Bliss', 34.00);
INSERT INTO combo VALUES (4, 'All-American Comfort', 49.00);
INSERT INTO combo VALUES (5, 'Ocean’s Delight', 56.00);
INSERT INTO combo VALUES (6, 'Eastern Feast', 48.00);
INSERT INTO combo VALUES (7, 'Lamb Lover’s Special', 54.00);
INSERT INTO combo VALUES (8, 'Sweet Escape', 29.00);

-- Insert data into the comboitem table
-- Classic Indulgence
INSERT INTO comboitem VALUES (1, 5);
INSERT INTO comboitem VALUES (1, 14);
INSERT INTO comboitem VALUES (1, 19);
-- Taste of the Tropics
INSERT INTO comboitem VALUES (2, 6);
INSERT INTO comboitem VALUES (2, 12);
INSERT INTO comboitem VALUES (2, 23);
-- Veggie Bliss
INSERT INTO comboitem VALUES (3, 7);
INSERT INTO comboitem VALUES (3, 14);
INSERT INTO comboitem VALUES (3, 21);
-- All-American Comfort
INSERT INTO comboitem VALUES (4, 8);
INSERT INTO comboitem VALUES (4, 13);
INSERT INTO comboitem VALUES (4, 15);
INSERT INTO comboitem VALUES (4, 27);
-- Ocean’s Delight
INSERT INTO comboitem VALUES (5, 2);
INSERT INTO comboitem VALUES (5, 5);
INSERT INTO comboitem VALUES (5, 11);
-- Eastern Feast
INSERT INTO comboitem VALUES (6, 4);
INSERT INTO comboitem VALUES (6, 9);
INSERT INTO comboitem VALUES (6, 17);
-- Lamb Lover’s Special
INSERT INTO comboitem VALUES (7, 10);
INSERT INTO comboitem VALUES (7, 11);
INSERT INTO comboitem VALUES (7, 26);
-- Sweet Escape
INSERT INTO comboitem VALUES (8, 3);
INSERT INTO comboitem VALUES (8, 20);


-- Insert data into the orderitem table
INSERT INTO orderitem VALUES (1, 21, 1);
INSERT INTO orderitem VALUES (2, 1, 2);
INSERT INTO orderitem VALUES (2, 10, 1);
INSERT INTO orderitem VALUES (2, 26, 1);
INSERT INTO orderitem VALUES (4, 4, 12);
INSERT INTO orderitem VALUES (4, 28, 3);
INSERT INTO orderitem VALUES (5, 2, 1); 
INSERT INTO orderitem VALUES (5, 6, 1);
INSERT INTO orderitem VALUES (5, 9, 1);
INSERT INTO orderitem VALUES (5, 12, 1);
INSERT INTO orderitem VALUES (5, 14, 1);
INSERT INTO orderitem VALUES (5, 18, 1);
INSERT INTO orderitem VALUES (5, 24, 1);
INSERT INTO orderitem VALUES (7, 2, 2); 
INSERT INTO orderitem VALUES (7, 5, 2);
INSERT INTO orderitem VALUES (7, 24, 2);
INSERT INTO orderitem VALUES (8, 7, 1); 
INSERT INTO orderitem VALUES (8, 16, 1);
INSERT INTO orderitem VALUES (8, 22, 2);
INSERT INTO orderitem VALUES (9, 10, 1); 
INSERT INTO orderitem VALUES (9, 11, 1);
INSERT INTO orderitem VALUES (9, 27, 1);
INSERT INTO orderitem VALUES (10, 3, 2); 
INSERT INTO orderitem VALUES (10, 15, 2);
INSERT INTO orderitem VALUES (10, 24, 2);
INSERT INTO orderitem VALUES (11, 9, 1);
INSERT INTO orderitem VALUES (11, 1, 1);
INSERT INTO orderitem VALUES (11, 2, 1);
INSERT INTO orderitem VALUES (11, 3, 1);
INSERT INTO orderitem VALUES (11, 4, 1);
INSERT INTO orderitem VALUES (12, 26, 2);
INSERT INTO orderitem VALUES (12, 4, 2);
INSERT INTO orderitem VALUES (12, 12, 1);
INSERT INTO orderitem VALUES (12, 23, 1);
INSERT INTO orderitem VALUES (13, 9, 1);
INSERT INTO orderitem VALUES (13, 15, 1);
INSERT INTO orderitem VALUES (13, 25, 2);
INSERT INTO orderitem VALUES (15, 5, 2);
INSERT INTO orderitem VALUES (15, 18, 2);
INSERT INTO orderitem VALUES (15, 28, 3);
INSERT INTO orderitem VALUES (16, 21, 1);
INSERT INTO orderitem VALUES (16, 1, 2);
INSERT INTO orderitem VALUES (17, 10, 1);
INSERT INTO orderitem VALUES (19, 2, 12);
INSERT INTO orderitem VALUES (19, 25, 3);
INSERT INTO orderitem VALUES (20, 1, 1); 
INSERT INTO orderitem VALUES (20, 6, 1);
INSERT INTO orderitem VALUES (20, 9, 1);
INSERT INTO orderitem VALUES (20, 12, 1);
INSERT INTO orderitem VALUES (20, 13, 1);
INSERT INTO orderitem VALUES (20, 19, 1);
INSERT INTO orderitem VALUES (20, 26, 1);
INSERT INTO orderitem VALUES (22, 10, 3); 
INSERT INTO orderitem VALUES (22, 11, 3);
INSERT INTO orderitem VALUES (22, 27, 3);
INSERT INTO orderitem VALUES (23, 5, 1); 
INSERT INTO orderitem VALUES (23, 16, 1);
INSERT INTO orderitem VALUES (24, 10, 1); 
INSERT INTO orderitem VALUES (24, 11, 1);
INSERT INTO orderitem VALUES (24, 27, 1);
INSERT INTO orderitem VALUES (25, 3, 2); 
INSERT INTO orderitem VALUES (25, 15, 2);
INSERT INTO orderitem VALUES (25, 28, 2);
INSERT INTO orderitem VALUES (26, 9, 1);
INSERT INTO orderitem VALUES (26, 1, 1);
INSERT INTO orderitem VALUES (26, 2, 1);
INSERT INTO orderitem VALUES (26, 3, 1);
INSERT INTO orderitem VALUES (26, 4, 1);
INSERT INTO orderitem VALUES (27, 26, 2);
INSERT INTO orderitem VALUES (27, 4, 2);
INSERT INTO orderitem VALUES (27, 12, 1);
INSERT INTO orderitem VALUES (27, 23, 1);
INSERT INTO orderitem VALUES (29, 9, 1);
INSERT INTO orderitem VALUES (29, 15, 1);
INSERT INTO orderitem VALUES (29, 25, 2);
INSERT INTO orderitem VALUES (30, 5, 3);
INSERT INTO orderitem VALUES (30, 18, 3);

-- Insert data into the ordercombo table
INSERT INTO ordercombo VALUES (1, 1, 1);
INSERT INTO ordercombo VALUES (2, 7, 1);
INSERT INTO ordercombo VALUES (2, 8, 1);
INSERT INTO ordercombo VALUES (3, 4, 2);
INSERT INTO ordercombo VALUES (5, 1, 1);
INSERT INTO ordercombo VALUES (5, 4, 1);
INSERT INTO ordercombo VALUES (6, 3, 5);
INSERT INTO ordercombo VALUES (9, 7, 2);
INSERT INTO ordercombo VALUES (9, 1, 1);
INSERT INTO ordercombo VALUES (11, 1, 1);
INSERT INTO ordercombo VALUES (11, 2, 1);
INSERT INTO ordercombo VALUES (11, 3, 1);
INSERT INTO ordercombo VALUES (11, 4, 1);
INSERT INTO ordercombo VALUES (11, 7, 1);
INSERT INTO ordercombo VALUES (14, 7, 8);
INSERT INTO ordercombo VALUES (16, 5, 1);
INSERT INTO ordercombo VALUES (17, 6, 1);
INSERT INTO ordercombo VALUES (17, 8, 1);
INSERT INTO ordercombo VALUES (18, 4, 2);
INSERT INTO ordercombo VALUES (20, 2, 1);
INSERT INTO ordercombo VALUES (20, 3, 1);
INSERT INTO ordercombo VALUES (21, 3, 3);
INSERT INTO ordercombo VALUES (24, 7, 2);
INSERT INTO ordercombo VALUES (24, 1, 1);
INSERT INTO ordercombo VALUES (26, 1, 1);
INSERT INTO ordercombo VALUES (26, 2, 1);
INSERT INTO ordercombo VALUES (26, 3, 1);
INSERT INTO ordercombo VALUES (26, 4, 1);
INSERT INTO ordercombo VALUES (26, 7, 1);
INSERT INTO ordercombo VALUES (28, 1, 9);

-- Insert data into the customer table
INSERT INTO customer VALUES (1, 'John Doe', '0123456789', 'johndoe@example.com');
INSERT INTO customer VALUES (2, 'Jane Smith', '0112233445', 'janesmith@example.com');
INSERT INTO customer VALUES (3, 'Alice Brown', '0145678901', 'alicebrown@example.com');
INSERT INTO customer VALUES (4, 'Bob Johnson', '0167890123', 'bobjohnson@example.com');
INSERT INTO customer VALUES (5, 'Charlie White', '0198765432', 'charliewhite@example.com');
INSERT INTO customer VALUES (6, 'David Lee', '0132345678', 'davidlee@example.com');
INSERT INTO customer VALUES (7, 'Emma Taylor', '0176543210', 'emmataylor@example.com');
INSERT INTO customer VALUES (8, 'Fiona Green', '0187654321', 'fionagreen@example.com');
INSERT INTO customer VALUES (9, 'George Hall', '0156789012', 'georgehall@example.com');
INSERT INTO customer VALUES (10, 'Hannah King', '0129876543', 'hannahking@example.com');
INSERT INTO customer VALUES (11, 'Isla Wright', '0143567890', 'islawright@example.com');
INSERT INTO customer VALUES (12, 'Jack Lewis', '0162345789', 'jacklewis@example.com');
INSERT INTO customer VALUES (13, 'Karen Scott', '0134768901', 'karenscott@example.com');
INSERT INTO customer VALUES (14, 'Liam Adams', '0181234567', 'liamadams@example.com');
INSERT INTO customer VALUES (15, 'Mia Carter', '0112233446', 'miacarter@example.com');
INSERT INTO customer VALUES (16, 'Noah Evans', '0123344556', 'noahevans@example.com');
INSERT INTO customer VALUES (17, 'Olivia Miller', '0191234567', 'oliviamiller@example.com');
INSERT INTO customer VALUES (18, 'Paul Moore', '0174455667', 'paulmoore@example.com');

-- Insert data into the payment table
INSERT INTO payment VALUES (1, 1, 1, 76.00, 0, 'cash', TO_DATE('2024-12-01 11:15', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (2, 2, 2, 160.00, 0, 'credit', TO_DATE('2024-12-01 12:25', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (3, 3, 3, 98.00, 0, 'online', TO_DATE('2024-12-01 13:35', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (4, 4, 4, 186.00, 0, 'cash', TO_DATE('2024-12-01 14:50', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (5, 5, 5, 215.00, 0, 'credit', TO_DATE('2024-12-01 16:05', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (6, 6, 6, 170.00, 0, 'online', TO_DATE('2024-12-01 17:20', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (7, 7, 7, 136.00, 0, 'cash', TO_DATE('2024-12-01 18:40', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (8, 8, 8, 127.00, 0, 'credit', TO_DATE('2024-12-01 19:55', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (9, 9, 9, 228.00, 0, 'online', TO_DATE('2024-12-01 21:15', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (10, 10, 10, 96.00, 0, 'cash', TO_DATE('2024-12-01 22:40', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (11, 11, 11, 320.00, 0, 'credit', TO_DATE('2024-12-01 11:20', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (12, 12, 12, 68.00, 0, 'online', TO_DATE('2024-12-01 12:30', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (13, 13, 13, 60.00, 0, 'cash', TO_DATE('2024-12-01 13:50', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (14, 14, 14, 432.00, 0, 'credit', TO_DATE('2024-12-01 15:05', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (15, 15, 15, 114.00, 0, 'online', TO_DATE('2024-12-01 16:15', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (16, 16, 16, 86.00, 0, 'cash', TO_DATE('2024-12-01 17:30', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (17, 17, 17, 122.00, 0, 'credit', TO_DATE('2024-12-01 18:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (18, 18, 18, 98.00, 0, 'online', TO_DATE('2024-12-01 20:10', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (19, 19, 1, 221.40, 10, 'cash', TO_DATE('2024-12-01 21:25', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (20, 20, 3, 166.50, 10, 'credit', TO_DATE('2024-12-01 22:45', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (21, 21, 2, 91.80, 10, 'online', TO_DATE('2024-12-01 11:25', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (22, 22, 12, 178.20, 10, 'cash', TO_DATE('2024-12-01 12:40', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (23, 23, 11, 48.60, 10, 'credit', TO_DATE('2024-12-01 13:55', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (24, 24, 18, 205.20, 10, 'online', TO_DATE('2024-12-01 15:10', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (25, 25, 17, 75.60, 10, 'cash', TO_DATE('2024-12-01 16:20', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (26, 26, 11, 281.60, 12, 'credit', TO_DATE('2024-12-01 17:35', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (27, 27, 2, 59.84, 12, 'online', TO_DATE('2024-12-01 18:50', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (28, 28, 12, 435.60, 12, 'cash', TO_DATE('2024-12-01 20:15', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (29, 29, 3, 52.80, 12, 'credit', TO_DATE('2024-12-01 21:35', 'YYYY-MM-DD HH24:MI'));
INSERT INTO payment VALUES (30, 30, 2, 123.84, 14, 'online', TO_DATE('2024-12-01 22:55', 'YYYY-MM-DD HH24:MI'));


--Insert data into feedback table
INSERT INTO feedback VALUES (1, 2, 2, 4, 'The Grilled Salmon was perfectly cooked, flaky and tender, while the Beef Rendang was rich in flavor with a perfect balance of spices. Both dishes were absolutely delicious!');
INSERT INTO feedback VALUES (2, 5, 5, 3, 'The Pumpkin Rice was decent, though it could use a bit more seasoning. The Mango Smoothie was 
                                            refreshing but a bit too sweet for my taste. Overall, a good but not outstanding meal');
INSERT INTO feedback VALUES (3, 8, 8, 5, 'The Chocolate Lava Cake was absolutely divine! The rich, molten center paired perfectly 
                                            with the warm, soft cake. A decadent treat that’s sure to satisfy any dessert lover’s cravings!');
INSERT INTO feedback VALUES (4, 11, 11, 4, 'The Classic Cheesecake was creamy and smooth, with just the right amount of sweetness. 
                                            The Cendol was refreshing, though a bit too icy for my liking. Overall, a great dessert duo!');
INSERT INTO feedback VALUES (5, 18, 18, 5, 'The Crispy Calamari was perfectly fried, light, and crunchy, with a delicious dip. 
                                            The Caesar Salad was fresh, with crisp lettuce and a creamy dressing. A fantastic combination, highly recommended!');
INSERT INTO feedback VALUES (6, 22, 12, 3, 'The Lamb Shank was tender but lacked a bit of seasoning, while the Mashed Potatoes were creamy but slightly too bland. 
                                            A decent dish overall, though it could use a little more flavor.');
INSERT INTO feedback VALUES (7, 24, 18, 5, 'The Vegetarian Lasagna was incredibly flavorful, with layers of perfectly cooked vegetables and a rich, cheesy sauce. 
                                            The Banoffee Pie was heavenly, with a perfect balance of sweetness and texture. A delightful meal!');
INSERT INTO feedback VALUES (8, 28, 12, 2, 'The Mashed Potatoes were too watery and lacked flavor, while the Pavlova was overly sweet and the 
                                            texture wasn’t as light as expected. Disappointing overall, but the presentation was nice.');


SELECT * FROM branch;
SELECT * FROM employee;
SELECT * FROM orders;
SELECT * FROM delivery;
SELECT * FROM dinein;
SELECT * FROM item;
SELECT * FROM orderitem;
SELECT * FROM ingredient;
SELECT * FROM itemingredient;
SELECT * FROM combo;
SELECT * FROM comboitem;
SELECT * FROM ordercombo;
SELECT * FROM customer;
SELECT * FROM payment;
SELECT * FROM feedback;


-- (a) A query that requires an outer join
-- In this query, we are identifying orders that do not contain any orderitem but rather only consist of combo sets.
-- This is to find out whether the combo sets created are fulfilling a customers full visit in which they do not require any add ons. 
SELECT 
    (SELECT COUNT(*) 
     FROM orders o
     LEFT JOIN orderitem oi 
     ON o.OrderID = oi.OrderID
     WHERE oi.ItemID IS NULL) AS "No. of orders with combos only",
    (SELECT COUNT(*) 
     FROM orders) AS "Total number of orders",
    ROUND(
        (SELECT COUNT(*) 
         FROM orders o
         LEFT JOIN orderitem oi 
         ON o.OrderID = oi.OrderID
         WHERE oi.ItemID IS NULL) * 100 / 
        (SELECT COUNT(*) 
         FROM orders), 2) AS "Percentage of combo-only orders"
FROM dual;

-- (b) A query with a minimum of 4 table join with a group by function query. 
-- In this query, we are identifying the combosets with the most ingredient requirement and the most common ingredient of each combos
-- This emphasizes on qaulity ingredient stock management by identifying the ingredient that the restaurant must always have and 
-- to tailor the the ingredient stock count based on the most popular combos appropriately.
SELECT 
    c.comboname,
    COUNT(*) AS ingredient_count,
    (SELECT n.ingredientname
     FROM ingredient n
     JOIN itemingredient ii ON n.ingredientid = ii.ingredientid
     GROUP BY n.ingredientname
     ORDER BY COUNT(*) DESC
     FETCH FIRST 1 ROWS ONLY) AS most_common_ingredient
FROM combo c
JOIN comboitem ci ON c.comboid = ci.comboid
JOIN item i ON ci.itemid = i.itemid
JOIN itemingredient ii ON i.itemid = ii.itemid
GROUP BY c.comboname
ORDER BY ingredient_count DESC;


-- (c) A query with a string pattern matching and date function query
-- This query identifies waiters that have been with the business since the very start
-- This allows the employer to identify the employee exact details and possibly provide them with loyalty bonuses.
SELECT employeeid, location, employeename, monthlysalary, hiredate, jobtitle
FROM employee e
JOIN branch b
ON b.branchid = e.branchid
WHERE hiredate < TO_DATE('2024-07-01', 'YYYY-MM-DD')
AND jobtitle LIKE 'Waiter'
AND jobStatus LIKE 'Active';


-- (d) A query having both OR and AND operator
-- This query identifies customers that provided a rating of 3 or lower or having content that consists of the keywords bad and poor in regards to a Potato ingredient.
-- This showcases how feedback from customers can be queried upon to find content that particularly targets a specific criteria.
SELECT f.orderID, c.customerID, c.customerName, c.customerphonenumber, c.customerEmail, f.content, f.rating
FROM customer c
JOIN feedback f ON c.customerID = f.customerID
WHERE 
    (f.rating <= 3 OR f.content LIKE '%poor%' OR f.content LIKE '%bad%')
    AND 
    f.content LIKE '%Potatoes%';


-- (e) A query that consists of atleast 2 subqueries
-- In this query, we are identifying the average item ordered and average cost of each person that dines in.
-- This allows the restaurant to identify how many items each person usually require to tailor combo sets and based on.
-- While the average price per person allows the restaurant to figure out whether the restaurant is afforadable or not.
SELECT 
    (SELECT ROUND(AVG(average_per_person), 2)
     FROM (
         SELECT ROUND(SUM(p.amountpaid) / SUM(d.personcount), 2) AS average_per_person
         FROM payment p
         JOIN orders o ON p.orderid = o.orderid
         JOIN dinein d ON o.orderid = d.orderid
         GROUP BY o.orderid
     )) AS "Average Payment per Person",
    
    (SELECT ROUND(AVG("Average item per person"), 2)
     FROM (
         SELECT orderid, SUM("TemporaryAverage") AS "Average item per person"
         FROM (
             SELECT o.orderid, (SUM(quantity) / personcount) AS "TemporaryAverage"
             FROM payment p
             JOIN orders o ON p.orderid = o.orderid
             JOIN orderitem oi ON o.orderid = oi.orderid
             JOIN dinein d ON o.orderid = d.orderid
             GROUP BY o.orderid, d.personcount
             UNION
             SELECT o.orderid, (SUM(quantity) / personcount) AS "TemporaryAverage"
             FROM payment p
             JOIN orders o ON p.orderid = o.orderid
             JOIN ordercombo oc ON o.orderid = oc.orderid
             JOIN comboitem ci ON ci.comboid = oc.comboid
             JOIN dinein d ON o.orderid = d.orderid
             GROUP BY o.orderid, personcount
         )
         GROUP BY orderid
     )) AS "Average Items per Person"
FROM DUAL;


-- (f) Identify dished (items) that are frequently ordered together to create new combo meals and replace the underperforming ones that already exist. 
-- This is to ensure that combo sets are tailored based on customer preferences.
SELECT i1.ItemName AS ItemA, i2.ItemName AS ItemB, i3.ItemName AS ItemC, COUNT(*) AS PairCount
FROM OrderItem oi1
JOIN OrderItem oi2
ON oi1.OrderID = oi2.OrderID
AND oi1.ItemID < oi2.ItemID 
JOIN OrderItem oi3
ON oi2.OrderID = oi3.OrderID
AND oi2.ItemID < oi3.ItemID
JOIN Item i1 
ON oi1.ItemID = i1.ItemID
JOIN Item i2 
ON oi2.ItemID = i2.ItemID
JOIN Item i3 
ON oi3.ItemID = i3.ItemID
GROUP BY i1.ItemName, i2.ItemName, i3.ItemName
ORDER BY PairCount DESC;
