/*
  Warnings:

  - Added the required column `price` to the `Books` table without a default value. This is not possible if the table is not empty.
  - Added the required column `publication_date` to the `Books` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `books` ADD COLUMN `price` DECIMAL(10, 2) NOT NULL,
    ADD COLUMN `publication_date` DATETIME(3) NOT NULL;
