# 📚 Library Management System (Prisma ORM & MySQL/MariaDB)

[![Prisma](https://img.shields.io/badge/Prisma-7.x-2D3748?style=for-the-badge&logo=prisma)](https://www.prisma.io/)
[![Node.js](https://img.shields.io/badge/Node.js-ESM-339933?style=for-the-badge&logo=node.js)](https://nodejs.org/)
[![MySQL](https://img.shields.io/badge/MySQL%20%2F%20MariaDB-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![pnpm](https://img.shields.io/badge/pnpm-11.x-F69220?style=for-the-badge&logo=pnpm&logoColor=white)](https://pnpm.io/)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg?style=for-the-badge)](https://opensource.org/licenses/ISC)

A complete relational database model and data layer for a **Library Management System**, designed using **Node.js (ES Modules)**, **Prisma ORM v7**, and the **`@prisma/adapter-mariadb`** driver adapter.

This project showcases modern Prisma 7 conventions—including the TypeScript configuration file (`prisma.config.ts`), shadow database integration for zero-downtime migrations, and a modular schema covering books, authors, genres, patrons, and loan tracking.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Database Schema & Architecture](#-database-schema--architecture)
  - [Entity-Relationship (ER) Diagram](#entity-relationship-er-diagram)
  - [Models Breakdown](#models-breakdown)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Environment Setup](#environment-setup)
  - [Database Migrations](#database-migrations)
- [Available Scripts](#-available-scripts)
- [Database Testing (`test-db.js`)](#-database-testing-test-dbjs)
- [Usage Example](#-usage-example)
- [Prisma 7 Highlights](#-prisma-7-highlights)
- [Contributing & License](#-contributing--license)

---

## 🔍 Overview

The goal of this project is to manage library operations efficiently by structuring real-world entities and relationships:

- **Catalog Management**: Books linked to authors and classified across multiple genres.
- **Many-to-Many Relationships**: Books and Genres mapped via an explicit join table (`Book_Genres`) with unique composite indexing.
- **Membership & Circulation**: Library members borrowing books with due dates, returned dates, and loan lifecycle statuses (`ACTIVE`, `RETURNED`, `OVERDUE`).
- **Modern Connection Architecture**: Utilizes Prisma 7's MariaDB/MySQL connection adapter with custom connection pooling.

---

## 📐 Database Schema & Architecture

### Entity-Relationship (ER) Diagram

```mermaid
erDiagram
    Authors ||--o{ Books : writes
    Books ||--o{ Book_Genres : has
    Genres ||--o{ Book_Genres : categorizes
    Books ||--o{ Loans : borrowed_as
    Members ||--o{ Loans : borrows

    Authors {
        Int id PK
        String name
    }

    Books {
        Int id PK
        String title
        DateTime publication_date
        Decimal price
        Int authorId FK
    }

    Genres {
        Int id PK
        String name
    }

    Book_Genres {
        Int bookId PK, FK
        Int genreId PK, FK
    }

    Members {
        Int id PK
        String name
        String email UK
    }

    Loans {
        Int id PK
        DateTime start_date
        DateTime due_date
        DateTime return_date
        Loans_Status status
        Int booksId FK
        Int membersId FK
    }
```

### Models Breakdown

| Model | Description | Key Fields & Relations |
| :--- | :--- | :--- |
| **`Authors`** | Stores authors who write books. | `id`, `name`, `books[]` (1-to-many with `Books`) |
| **`Books`** | Catalog of library books. | `id`, `title`, `publication_date`, `price`, `authorId`, `genres[]`, `loans[]` |
| **`Genres`** | Categories (e.g., Fiction, Sci-Fi, History). | `id`, `name`, `bookGenres[]` |
| **`Book_Genres`** | Explicit pivot table connecting books and genres. | `bookId`, `genreId` (with `@@unique([bookId, genreId])`) |
| **`Members`** | Registered library patrons. | `id`, `name`, `email` (unique), `loans[]` |
| **`Loans`** | Loan history and active borrowings. | `id`, `start_date`, `due_date`, `return_date`, `status` (`ACTIVE`, `RETURNED`, `OVERDUE`) |

---

## 🛠 Tech Stack

- **Runtime**: [Node.js](https://nodejs.org/) (Native ES Modules / `"type": "module"`)
- **ORM**: [Prisma ORM v7](https://www.prisma.io/)
- **Driver Adapter**: [`@prisma/adapter-mariadb`](https://www.npmjs.com/package/@prisma/adapter-mariadb)
- **Database**: [MySQL](https://www.mysql.com/) / [MariaDB](https://mariadb.org/)
- **Configuration & Env**: [`dotenv`](https://www.npmjs.com/package/dotenv), TypeScript CLI Config (`prisma.config.ts`)
- **Package Manager**: [pnpm](https://pnpm.io/)

---

## 📂 Project Structure

```text
library-prisma/
├── prisma/
│   ├── migrations/             # SQL migration history
│   │   ├── 20261029204512_init/
│   │   ├── 20261029205709_add_authors/
│   │   ├── 20261029210634_add_genres/
│   │   ├── 20261029213615_add_loans/
│   │   ├── 20261029214924_add_members/
│   │   └── 20261029215302_loans_relations/
│   └── schema.prisma           # Prisma data models & relations
├── .env.example                # Sample environment variables
├── .gitignore                  # Ignored files (node_modules, .env)
├── package.json                # Project scripts and dependencies
├── pnpm-lock.yaml              # Lockfile
├── prisma-client.js            # Initialized PrismaClient with MariaDB adapter
├── prisma.config.ts            # Prisma 7 CLI configuration (datasources & shadow DB)
├── test-db.js                  # Test script for manual data insertion & verification
└── README.md                   # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have installed:
- **Node.js** (v18 or higher recommended)
- **pnpm** (`npm install -g pnpm`)
- A running **MySQL** or **MariaDB** server instance (e.g., via Docker, XAMPP, or local service)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/library-prisma.git
   cd library-prisma
   ```

2. **Install dependencies:**
   ```bash
   pnpm install
   ```

### Environment Setup

1. Copy the example `.env.example` file to create your `.env`:
   ```bash
   cp .env.example .env
   ```

2. Open `.env` and fill in your database credentials:
   ```env
   # Main database connection for Prisma CLI
   DATABASE_URL="mysql://root:password@localhost:3306/library_db"

   # Shadow database for Prisma migrations (must exist and be empty)
   SHADOW_DATABASE_URL="mysql://root:password@localhost:3306/library_db_shadow"

   # Runtime parameters used by @prisma/adapter-mariadb in prisma-client.js
   DATABASE_HOST="localhost"
   DATABASE_PORT="3306"
   DATABASE_USER="root"
   DATABASE_PASSWORD="password"
   DATABASE_NAME="library_db"
   ```

> [!NOTE]
> **Why a Shadow Database?**
> Prisma 7 uses the `SHADOW_DATABASE_URL` to safely detect schema drift, generate clean migrations, and validate SQL migration steps against a clean state before applying them to your primary database.

### Database Migrations

Apply existing migrations and create the tables in your database:

```bash
pnpm migrate
```

Generate the Prisma Client types:

```bash
pnpm generate
```

---

## 💻 Available Scripts

| Command | Script | Description |
| :--- | :--- | :--- |
| `pnpm validate` | `prisma validate` | Validates your `schema.prisma` file for syntax errors. |
| `pnpm migrate` | `prisma migrate dev` | Applies pending migrations and updates Prisma Client in development. |
| `pnpm generate` | `prisma generate` | Generates the strongly-typed Prisma Client. |
| `pnpm studio` | `prisma studio` | Opens the visual database browser at `http://localhost:5555`. |

---

## 🧪 Database Testing (`test-db.js`)

A dedicated test script (`test-db.js`) is included to verify database connectivity and test relational data insertion manually.

The script demonstrates Prisma's **nested writes** (`create` with relation) and top-level `await` support in native ES Modules:

```javascript
import { client } from "./prisma-client.js";

const newBook = await client.books.create({
    data: {
        title: "Rich dad poor dad",
        publication_date: new Date('2000-04-01'),
        price: 14.99,

        // Automatically creates and links the associated author record
        authors: {
            create: {
                name: "Robert Kiyosaki"
            }
        }
    }
});

// Closes the connection pool opened by the adapter
await client.$disconnect();
```

### Running the Test Script

Run the file directly with Node.js:

```bash
node test-db.js
```

> [!TIP]
> After running the test script, launch **Prisma Studio** with `pnpm studio` to visually inspect the newly created book and author records in your browser.

---

## 💡 Usage Example

You can import and use the pre-configured `client` from `prisma-client.js` in your scripts or server:

```javascript
import { client } from "./prisma-client.js";

async function main() {
  // 1. Create an author and a book in a single transaction
  const newAuthor = await client.authors.create({
    data: {
      name: "George Orwell",
      books: {
        create: [
          { title: "1984" },
          { title: "Animal Farm" }
        ]
      }
    },
    include: {
      books: true
    }
  });

  console.log("Created author with books:", newAuthor);

  // 2. Fetch all books along with author and genres
  const books = await client.books.findMany({
    include: {
      authors: true,
      genres: {
        include: {
          genres: true
        }
      }
    }
  });

  console.dir(books, { depth: null });
}

main()
  .catch((e) => console.error(e))
  .finally(async () => {
    await client.$disconnect();
  });
```

---

## ⚡ Prisma 7 Highlights

This repository demonstrates modern Prisma 7 architecture:
1. **Config File (`prisma.config.ts`)**: Database URLs and shadow URLs are declared cleanly in configuration files instead of hardcoding datasource blocks in `schema.prisma`.
2. **Driver Adapters (`@prisma/adapter-mariadb`)**: Instead of relying solely on internal binary engines, Prisma utilizes JavaScript/TypeScript database driver adapters for improved connection management and compatibility with modern serverless/edge environments.
3. **Explicit Junction Relations**: Full control over many-to-many relationship tables (`Book_Genres`) allowing future metadata additions (e.g., date added, tags, primary genre flags).

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to open an issue or submit a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the [ISC License](LICENSE).

