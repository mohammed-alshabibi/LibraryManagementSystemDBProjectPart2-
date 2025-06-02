# 📚 Library Management System – DB Project Part 2

This project simulates a **production-ready SQL Server database** for a library system, designed with features commonly used by backend developers in real-world systems. It supports reporting, automation, data validation, and frontend API-like access.

---

## ✅ Repository Structure

| File Name               | Purpose                                                   |
|------------------------|-----------------------------------------------------------|
| `LibrarySystemDBCreationsQuery.sql` | All table definitions (Library, Book, Member, Loan, etc.) |
| `LibrarySystemDBInsetQuery.sql`     | Sample data insertions for all tables              |
| `SELECT_Queries.sql`                | SQL queries acting as API endpoints                |
| `Views.sql`                         | Views for frontend integration                     |
| `Functions.sql`                     | Reusable UDFs (e.g. ratings, occupancy)            |
| `StoredProcedures.sql`             | Backend logic: loan updates, member ranking        |
| `Triggers.sql`                     | Real-time triggers for availability, validation    |
| `Aggregations.sql`                 | Dashboard queries (totals, top books, summaries)   |
| `AdvancedAggregations.sql`         | Insights using HAVING, subqueries, and analytics   |
| `TransactionalFlows.sql`           | Real-world flows with transaction control          |
| `Test_Triggers.sql`                | Scripts to validate trigger functionality          |

---

## 📌 Key Features

### 🔍 SELECT Queries (API-style Endpoints)
- Overdue loans, unavailable books, top borrowers
- Ratings, reviews, staff per library, book history
- Members with fines, popular books, genre stats

### 📊 Views – Frontend Support
- `ViewPopularBooks`, `ViewAvailableBooks`, `ViewPaymentOverview`
- Summarized data for member dashboards and staff panels

### 🧠 Functions – Reusable Logic
Used across pages like:
- **Book pages**: Average rating, top-rated books
- **Member profiles**: Loan counts, name formatting
- **Admin analytics**: Occupancy, availability filters

### 🛠️ Stored Procedures
- Mark books unavailable when loaned
- Auto-update loan status (returned/overdue)
- Rank members by total fines

### ⚡ Triggers
- Auto update availability after loan
- Validate return dates
- Update revenue per payment

### 📈 Aggregations & Insights
- Total fines per member
- Avg price by genre
- Top 3 reviewed books
- Library revenue reports
- Members with loans but no fine
- Max price per genre
- Genres with high average rating

### 🔄 Transactions
- Borrow a book (insert + update)
- Return a book (update + restore availability)
- Register payments with checks
- Batch insert with rollback on failure

---

## 🧪 How to Use
1. Execute `LibrarySystemDBCreationsQuery.sql` to build the schema.
2. Run `LibrarySystemDBInsetQuery.sql` to populate test data.
3. Load views, functions, procedures, and triggers sequentially.
4. Use `Test_Triggers.sql` and `TransactionalFlows.sql` for simulation testing.
5. Explore queries in `SELECT_Queries.sql` and dashboards via aggregation files.

---

## 🙋 Reflection

> **Where would such functions be used in a frontend?**

- Book pages → `GetBookAverageRating`, `fn_GetTopRatedBooks`
- Library filter → `fn_ListAvailableBooksByLibrary`
- Admin dashboard → `CalculateLibraryOccupancyRate`, `sp_RankMembersByFines`
- Member profile → `fn_GetMemberLoanCount`, `fn_FormatMemberName`

These features simulate how backend SQL development directly powers dynamic features in real-world apps.

---

📂 Built with ❤️ for full-stack integration, backend simulation, and real-world scenarios.

---

## 🧑‍💻 Developer Reflection

### 🔸 What part was hardest and why?
The most challenging part was building the stored procedures and triggers. Ensuring data consistency and handling errors within `TRY...CATCH` blocks required careful attention to avoid conflicts and data corruption — especially in transactional flows.

### 🔸 Which concept helped you think like a backend developer?
Using **transactions** and **triggers** helped me understand how real-world systems enforce rules automatically. Also, the use of **functions** for encapsulating logic felt like writing backend utility code but inside SQL.

### 🔸 How would you test this if it were a live web app?
I’d simulate frontend calls by:
- Calling views and functions from a service layer
- Running transactional procedures through API endpoints (e.g., borrow/return book)
- Verifying trigger-based updates (like book availability) through test cases or logs

Unit testing could be implemented using T-SQL test scripts and integration testing using Postman or a frontend connected to the DB.
