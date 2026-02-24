# SneakerShop E-Commerce System 👟🛒

A console-based e-commerce application built with Java and MySQL. This project demonstrates how to connect a Java backend to a relational database using JDBC to manage customers, inventory, and orders for a fictional shoe store. 

## 📌 Features
* **User Authentication:** Customers can log securely into the system using their registered username (first name) and password.
* **Product Catalog:** View all available sneakers, including live inventory stock, sizes, and pricing.
* **Shopping Cart System:** Users can add products to their active orders. The system utilizes a MySQL Stored Procedure (`AddToCart`) to automatically:
  * Check if the product is in stock.
  * Create a new active order or append to an existing one.
  * Deduct the purchased amount from the live inventory.
* **Inventory Management:** Includes a MySQL Trigger (`trg_check_out_of_stock`) that automatically logs an event in the `OutOfStock` table the exact moment a product's inventory hits zero.

## 🛠️ Technologies Used
* **Language:** Java
* **Database:** MySQL
* **API:** Java Database Connectivity (JDBC)
* **Database Concepts:** * Relational schema design (1-to-M and M-to-M relationships)
  * Stored Procedures
  * Triggers
  * Transactions (Commit & Rollback)
  * Complex `JOIN`, `GROUP BY`, and `HAVING` queries

## 🚀 How to Run
1. Ensure you have MySQL running on your local machine.
2. Run the provided SQL scripts in your database manager (e.g., MySQL Workbench) in the following order:
   * Execute the table creation and mock-data insertion script (`CREATE DATABASE...`).
   * Execute the Procedure and Trigger scripts.
3. In the Java project, update the `DatabaseConnection` class with your MySQL credentials (if they differ from `root` and `password`).
4. Run the `Main` class to start the application.
5. Log in using one of the test accounts (e.g., Username: `Anna`, Password: `password123`).
